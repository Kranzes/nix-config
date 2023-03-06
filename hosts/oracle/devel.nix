{ pkgs, ... }:

{
  users.users.kranzes.packages = with pkgs; [
    git
    nixpkgs-review
  ];

  environment.persistence."/nix/persistent".users.kranzes = {
    directories = [
      "devel"
    ];
    files = [
      ".bash_history"
    ];
  };
}
