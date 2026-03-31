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
        "cc-safety-net"
      ];
      enabled_providers = [ "anthropic" ];
      inherit model;
    };
  };

  home.sessionVariables = {
    OPENCODE_DISABLE_CLAUDE_CODE = "true";
    OPENCODE_EXPERIMENTAL_DISABLE_COPY_ON_SELECT = "true";
    OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
  };
}
