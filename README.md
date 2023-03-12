# nix-config

A nix flake that holds all of the system configurations of my personal machines.

## Configurations & Modules

Name        		| Description
----------------------- | -----------
[Hosts](./hosts)	| Host specific configurations (system-wide & Home-Manager)
[Profiles](./profiles)  | Shared system-wide configurations between hosts
[Home](./home)          | Shared Home-Manager configurations between hosts
[Packages](./packages)  | Modified nixpkgs packages and custom packages
[Lib](./lib)            | libraries, tools and functions used in across this repo

## Hosts

Name              		     	    | Description
------------------------------------------- | -----------
[Pongo](./hosts/pongo) 	                    | My desktop running a Ryzen 7 2700X, 16GB of RAM and a GTX 950 
[Pan](./hosts/pan)     	                    | My ThinkPad T430
[Hetzner](./hosts/hetzner)                  | CPX31 VPS running on Hetzner Cloud
