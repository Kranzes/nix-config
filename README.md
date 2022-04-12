# nix-config

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A nix flake that holds all of the system configurations of my personal machines.

## Configurations & Modules

Name        		| Description
----------------------- | -----------
[Hosts](./hosts)	| Host specific configurations (system-wide & Home-Manager)
[Modules](./modules)    | Shared system-wide configurations between hosts
[Home](./home)          | Shared Home-Manager configurations between hosts
[Packages](./packages)  | Modified nixpkgs packages and custom packages
[Lib](./lib)            | libraries, tools and functions used in across this repo

## Hosts

All of my hostnames are named after scientific names of monkeys/apes.

Name              		     	    | Description
------------------------------------------- | -----------
[Pongo (Orangutan)](./hosts/pongo) 	    | My desktop running a Ryzen 7 2700X, 16GB of RAM and a GTX 950 
[Pan (Chimpanzee)](./hosts/pan)     	    | My ThinkPad T430
