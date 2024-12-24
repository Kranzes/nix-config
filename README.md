# nix-config

A nix flake that holds all of the system configurations of my personal machines.

## Configurations & Modules

Name                    | Description
----------------------- | -----------
[Hosts](./hosts)	    | Host specific configurations (system-wide & Home-Manager)
[Profiles](./profiles)  | System-wide "profiles" (modular configurations) used by some hosts
[Home](./home)          | Home-Manager configurations for users that may be imported by some hosts
[Packages](./packages)  | Modified nixpkgs packages and custom packages
[dev](./dev)            | Devshell, deployment tool, etc

## Hosts

Name                                        | Description
------------------------------------------- | -----------
[Pongo](./hosts/pongo) 	                    | My desktop running a Ryzen 7 2700X, 16GB of RAM and a GTX 950 
[Pan](./hosts/pan)     	                    | My ThinkPad T430
[Gorilla](./hosts/gorilla)     	            | My ThinkPad T14s AMD G1
[Hetzner](./hosts/hetzner)     	            | Hetzner Cloud CX32
