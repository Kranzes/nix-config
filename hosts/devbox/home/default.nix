{ pkgs, ... }:

{
  home-manager.users.kranzes =
    { config, lib, ... }:
    {
      programs.git = {
        package = pkgs.gitMinimal;
        signing.key = lib.mkForce null;
        settings.gpg.ssh.defaultKeyCommand = toString (
          pkgs.writeShellScript "ssh-agent-signing-key" ''
            key=$(${pkgs.openssh}/bin/ssh-add -L | head -n1) && echo "key::$key"
          ''
        );
      };

      programs.nixvim.plugins.treesitter.grammarPackages = lib.filter (
        g: lib.getName g != "tree-sitter-perl"
      ) config.programs.nixvim.plugins.treesitter.package.allGrammars;

      home.packages = [ pkgs.awscli2 ];
    };
}
