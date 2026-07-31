# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal NixOS flake configuring three machines:

- `pongo` — desktop (Ryzen 7 2700X / RX 570); also runs the home-server stack (Nextcloud, Jellyfin/*arr media stack, Home Assistant, Zigbee2MQTT, Docker).
- `tamarin` — Framework 13 laptop.
- `hetzner` — Hetzner Cloud CX32 VPS hosting public services (Kanidm IDP at `idm.ilanjoselevich.com`, OpenBao at `secret.ilanjoselevich.com`, Grafana, Prometheus, Homer).

## Common commands

All commands assume the repo root and the `nix` devshell (auto-loaded via `direnv` from `.envrc`).

| Task | Command |
| --- | --- |
| Format the tree | `nix fmt` (treefmt: nixfmt + deadnix + statix; configured in `dev/flake-module.nix`) |
| Build a host | `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` |
| Evaluate config | `nix eval .#nixosConfigurations.<host>.config.<path>` |
| Flake-wide check | `nix flake check` |
| Deploy a host | `nix run .#deploy-<host>` (defaults to `switch`; pass another action as `$1`, e.g. `nix run .#deploy-tamarin -- test`) |
| Read/write a service secret | `bao kv get`/`bao kv put kv/<host>/systemd/<unit>` (devshell provides `bao`; set `BAO_ADDR=https://secret.ilanjoselevich.com`) |
| Edit the AppRole secret ID | `agenix -e <host>-openbao-secret-id.age -i identities/kranzes-yk5.pub` from inside `secrets/` (devshell provides `agenix` and `age-plugin-yubikey`) |

The deploy apps (one per host, generated in `dev/flake-module.nix`) wrap `nixos-rebuild` in a `writeShellApplication` script. Builds happen on the target host for `pongo` and `tamarin` (`--build-host`); only `hetzner` (the small CX32 VPS) builds on the deployer. The script detects "deploying to self" via `$HOSTNAME` and sets `--target-host ""` / `--build-host ""` in that case so activation and build stay local without SSH. Privilege elevation uses `--elevate=run0` (sudo is disabled in favor of run0 + its sudo shim), with `--ask-elevate-password` added when `security.run0.wheelNeedsPassword` is set. Trailing args after `$1` are forwarded to `nixos-rebuild`.

There is no test suite — `nix build` / `nix flake check` is what's run.

## Big-picture architecture

The flake is composed via **flake-parts**. `flake.nix` wires only inputs and imports five sub-`flake-module.nix` files; each is responsible for a piece of the public flake interface:

- `hosts/flake-module.nix` — defines `flake.nixosConfigurations` (`pongo`, `tamarin`, `hetzner`) through a local `nixosSystemWithDefaults` helper. Every host automatically imports the `commonProfiles` set (agenix, docs, misc, networking, nix-nixpkgs, security, ssh, systemd-creds-openbao, tailscale, users) plus `./<hostName>` and `networking.hostName` / `nixpkgs.hostPlatform`. Desktop hosts (`pongo`, `tamarin`) additionally import `commonHome` which loads `home-manager.nixosModules.default` and points `users.kranzes` at `home/kranzes`.
- `profiles/flake-module.nix` — exposes `flake.nixosModules.profiles-*`. Modules that need `inputs` are wired with `lib.modules.importApply ./X.nix { inherit inputs; }`; pure modules are referenced as plain paths. Hosts opt into non-common profiles (e.g. `profiles-hyprland`, `profiles-laptop`, `profiles-android`, `profiles-audio`) from their own `default.nix`.
- `hosted/flake-module.nix` — exposes `flake.nixosModules.hosted-*` for self-hosted services (`nginx`, `postgresql`, `restic`, `node-exporter`, `libvirt`). These are imported by each host's `hosts/<host>/hosted/default.nix`, which then layers per-host services next to them (e.g. `hosts/pongo/hosted/{nextcloud,docker,home-assistant,zigbee2mqtt,media}.nix`, `hosts/hetzner/hosted/{kanidm,openbao,grafana,prometheus,homer}.nix`).
- `packages/flake-module.nix` — builds the custom `fuzzel-mpd` shell wrapper and re-exports `neovim` from pongo's nixvim build (so `nix build .#neovim` produces the same editor used on that host).
- `dev/flake-module.nix` — devshell, `treefmt`, and the `deploy-<host>` apps.

### Module/path conventions

- Profiles and hosted modules referenced through `inputs.self.nixosModules.<name>` — never imported by relative path from outside their own directory. `commonProfiles` in `hosts/flake-module.nix` is the central include list.
- When a module needs `inputs` it is wrapped with `lib.modules.importApply` in the corresponding `flake-module.nix` and the inner module then takes the standard `{ config, pkgs, lib, ... }` arguments.
- `home/kranzes/default.nix` is loaded by every desktop host through `commonHome`; per-host home overlays live in `hosts/<host>/home/` and are imported from the host's own `default.nix`.

### Secrets (systemd-creds-openbao)

Secrets live in OpenBao (`secret.ilanjoselevich.com`, self-hosted on `hetzner`) and reach services as [systemd credentials](https://systemd.io/CREDENTIALS/). `profiles/systemd-creds-openbao.nix` runs the daemon on every host; it authenticates with AppRole (`role_id` is the hostname) and defines the catch-all rule: a unit may read `kv/<hostName>/systemd/<unit name without the .service suffix>`, taking the credential ID as the field name.

Other modules append more specific rules to `services.systemd-creds-openbao.settings.credentials` — `profiles/tailscale.nix` uses a `raw`-backend rule to mint an OIDC ID token from `identity/oidc/token/tailscale`, so tailscale authenticates by workload identity instead of a pre-shared auth key. Rules are **first-match-wins**, so anything more specific must land before the catch-all; nothing enforces that ordering today beyond module evaluation order.

Wiring a consumer takes one of three shapes, depending on what the upstream module offers:

- The module already emits `LoadCredential=` itself — point its option straight at the socket (`services.nextcloud.config.adminpassFile`).
- The option is a path read at runtime — add `LoadCredential` to the unit and point the option at `/run/credentials/<unit>.service/<id>` (kanidm, grafana, restic `passwordFile`, tailscale's `--id-token`).
- The app insists on a fixed filename — add the credential and symlink it in with a `systemd.tmpfiles` `L+` entry (recyclarr `secrets.yml`, home-assistant `secrets.yaml`).

Adding a secret is `bao kv put kv/<host>/systemd/<unit> <credential>=…` plus the wiring above — no repo-side key management. After changing rules, regenerate the daemon's OpenBao policy from `nixosConfigurations.<host>.config.services.systemd-creds-openbao.policyFile` and `bao policy write` it.

A refused or failed fetch surfaces as an **empty** credential rather than an error, and it stays that way for the unit's whole invocation, so a service that started while OpenBao was down or sealed needs restarting. `journalctl -u systemd-creds-openbao` names the credential, path and unit on every request.

- agenix survives for exactly one secret per host: `<host>-openbao-secret-id.age`, the AppRole secret ID the daemon logs in with, which cannot come from OpenBao itself. `secrets/secrets.nix` lists those three files and is the source of truth for which keys decrypt them — each host's SSH host key (`systems.<host>`) plus two YubiKey age identities (`kranzes-yk5`, `kranzes-yk5c`).
- `profiles/agenix.nix` sets `age.identityPaths` to the host's SSH host keys, so decryption at boot uses the same keys advertised in `secrets.nix`.
- The filename is derived from `config.networking.hostName`, so renaming a host requires renaming its secret file in lockstep.

### Deploy pipeline

- Deploys are run manually with `nix run .#deploy-<host>`. There is no CI-driven deploy.

## Conventions

- Run `nix fmt` before committing — the tree must be clean under treefmt (nixfmt + deadnix + statix).
- Commit messages follow `<area>: <imperative summary>` (e.g. `treewide: bump kanidm from 1.9 to 1.10`, `home/kranzes/hyprland: enable focus_on_activate`). Match the existing prefix style when committing.
- `allowUnfree = true` is set globally in `profiles/nix-nixpkgs.nix`; no need to add per-package overrides.
