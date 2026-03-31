{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  model = "claude-opus-4-6";
  llmPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.mcp = {
    enable = true;
    servers = {
      nixos.command = lib.getExe pkgs.mcp-nixos;
    };
  };

  programs.claude-code = {
    enable = true;
    package = llmPackages.claude-code;
    enableMcpIntegration = true;
    lspServers = {
      nix = {
        command = "nixd";
        extensionToLanguage.".nix" = "nix";
      };
      rust = {
        command = "rust-analyzer";
        extensionToLanguage.".rs" = "rust";
      };
    };
    settings = {
      inherit model;
      enabledPlugins = {
        "commit-commands@claude-plugins-official" = true;
      };
    };
  };

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    package = llmPackages.opencode;
    settings = {
      plugin = [
        "opencode-claude-auth"
        "@slkiser/opencode-quota"
        "cc-safety-net"
      ];
      enabled_providers = [ "anthropic" ];
      inherit model;
    };
  };
}
