# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal NixOS flake configuring three machines:

- `pongo` — desktop (Ryzen 7 2700X / GTX 950); also runs the home-server stack (Nextcloud, Jellyfin/*arr media stack, Home Assistant, Zigbee2MQTT, Docker).
- `tamarin` — Framework 13 laptop.
- `hetzner` — Hetzner Cloud CX32 VPS hosting public services (Kanidm IDP at `idm.ilanjoselevich.com`, Grafana, Prometheus, Homer).

## Common commands

All commands assume the repo root and the `nix` devshell (auto-loaded via `direnv` from `.envrc`).

| Task | Command |
| --- | --- |
| Format the tree | `nix fmt` (treefmt: nixfmt + deadnix + statix; configured in `dev/flake-module.nix`) |
| Build a host | `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` |
| Evaluate config | `nix eval .#nixosConfigurations.<host>.config.<path>` |
| Flake-wide check | `nix flake check` |
| Deploy a host | `nix run .#deploy-<host>` (defaults to `switch`; pass another action as `$1`, e.g. `nix run .#deploy-tamarin -- test`) |
| Edit secrets | `agenix -e <name>.age -i identities/kranzes-yk5.pub` from inside `secrets/` (devshell provides `agenix` and `age-plugin-yubikey`) |

The deploy apps (one per host, generated in `dev/flake-module.nix`) wrap `nixos-rebuild` with `--target-host <hostName>`, `--sudo`, `--no-reexec`, and `--ask-sudo-password` when the host requires it. `pongo` additionally builds on itself (`--build-host`).

There is no test suite — `nix build` / `nix flake check` is what's run.

## Big-picture architecture

The flake is composed via **flake-parts**. `flake.nix` wires only inputs and imports five sub-`flake-module.nix` files; each is responsible for a piece of the public flake interface:

- `hosts/flake-module.nix` — defines `flake.nixosConfigurations` (`pongo`, `tamarin`, `hetzner`) through a local `nixosSystemWithDefaults` helper. Every host automatically imports the `commonProfiles` set (agenix, docs, misc, networking, nix-nixpkgs, security, ssh, tailscale, users) plus `./<hostName>` and `networking.hostName` / `nixpkgs.hostPlatform`. Desktop hosts (`pongo`, `tamarin`) additionally import `commonHome` which loads `home-manager.nixosModules.default` and points `users.kranzes` at `home/kranzes`.
- `profiles/flake-module.nix` — exposes `flake.nixosModules.profiles-*`. Modules that need `inputs` are wired with `lib.modules.importApply ./X.nix { inherit inputs; }`; pure modules are referenced as plain paths. Hosts opt into non-common profiles (e.g. `profiles-hyprland`, `profiles-laptop`, `profiles-android`, `profiles-audio`) from their own `default.nix`.
- `hosted/flake-module.nix` — exposes `flake.nixosModules.hosted-*` for self-hosted services (`nginx`, `postgresql`, `restic`, `node-exporter`, `libvirt`). These are imported by each host's `hosts/<host>/hosted/default.nix`, which then layers per-host services next to them (e.g. `hosts/pongo/hosted/{nextcloud,docker,home-assistant,zigbee2mqtt,media}.nix`, `hosts/hetzner/hosted/{kanidm,grafana,prometheus,homer}.nix`).
- `packages/flake-module.nix` — builds the custom `fuzzel-mpd` shell wrapper and re-exports `neovim` from pongo's nixvim build (so `nix build .#neovim` produces the same editor used on that host).
- `dev/flake-module.nix` — devshell, `treefmt`, and the `deploy-<host>` apps.

### Module/path conventions

- Profiles and hosted modules referenced through `inputs.self.nixosModules.<name>` — never imported by relative path from outside their own directory. `commonProfiles` in `hosts/flake-module.nix` is the central include list.
- When a module needs `inputs` it is wrapped with `lib.modules.importApply` in the corresponding `flake-module.nix` and the inner module then takes the standard `{ config, pkgs, lib, ... }` arguments.
- `nix.package` is **Lix** (`pkgs.lixPackageSets.git.lix`) — set in `profiles/nix-nixpkgs.nix`. Do not reintroduce a `lix-module` flake input.
- `home/kranzes/default.nix` is loaded by every desktop host through `commonHome`; per-host home overlays live in `hosts/<host>/home/` and are imported from the host's own `default.nix`.

### Secrets (agenix)

- `secrets/secrets.nix` is the source of truth for which keys can decrypt each `.age` file. Each host has an SSH host key (`systems.<host>`) and the user has two YubiKey age identities (`kranzes-yk5`, `kranzes-yk5c`). When adding a new secret, list it there with the right `publicKeys` and rekey via `agenix`.
- `profiles/agenix.nix` sets `age.identityPaths` to the host's SSH host keys, so decryption at boot uses the same keys advertised in `secrets.nix`.
- File-name convention: `<host>-<purpose>.age` (or `all-…age` for cross-host secrets). `hosted/restic.nix` resolves secret paths from `${config.networking.hostName}-…age`, so renaming a host requires renaming its secret files in lockstep.

### Deploy pipeline

- Deploys are run manually with `nix run .#deploy-<host>`. There is no CI-driven deploy.
- `nix-community.cachix.org` is added as a substituter inside `profiles/nix-nixpkgs.nix`.

## Conventions

- Run `nix fmt` before committing — the tree must be clean under treefmt (nixfmt + deadnix + statix).
- Commit messages follow `<area>: <imperative summary>` (e.g. `treewide: bump kanidm from 1.9 to 1.10`, `home/kranzes/hyprland: enable focus_on_activate`). Match the existing prefix style when committing.
- `allowUnfree = true` is set globally in `profiles/nix-nixpkgs.nix`; no need to add per-package overrides.
