# Claude Code tooling (home-manager module, shared by every host):
# vexp code-graph MCP server, and a NixOS fix for claude-mem's vector search.
{
  lib,
  pkgs,
  config,
  ...
}: let
  profileBin = "${config.home.profileDirectory}/bin";
  vexp = pkgs.callPackage ../../derivs/vexp {corePath = "${profileBin}/vexp-core";};

  # claude-mem runs chroma-mcp through `uvx`, which installs manylinux wheels
  # (numpy, onnxruntime) that dlopen libstdc++ -- absent from NixOS's global paths.
  claudeMemUvx = pkgs.writeShellScriptBin "uvx" ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.zlib]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    exec ${pkgs.uv}/bin/uvx "$@"
  '';
  # Stable path outside PATH, so only claude-mem picks up the wrapper.
  claudeMemUvxDir = "${config.home.homeDirectory}/.local/share/claude-mem-uvx/bin";
in {
  # Per-repo hooks, CLAUDE.md and the index stay opt-in: `vexp setup` then `vexp index` inside the repo.
  home.packages = [vexp];

  home.file.".local/share/claude-mem-uvx/bin/uvx".source = "${claudeMemUvx}/bin/uvx";

  # claude-mem's settings.json is mutable app state; only pin the uvx override.
  home.activation.claudeMemUvx = lib.hm.dag.entryAfter ["writeBoundary"] ''
    s="$HOME/.claude-mem/settings.json"
    if [ -f "$s" ] && [ "$(${pkgs.jq}/bin/jq -r '.CLAUDE_MEM_CHROMA_UVX_PATH // ""' "$s")" != "${claudeMemUvxDir}" ]; then
      tmp="$(mktemp)"
      ${pkgs.jq}/bin/jq --arg p "${claudeMemUvxDir}" '.CLAUDE_MEM_CHROMA_UVX_PATH = $p' "$s" > "$tmp"
      run mv "$tmp" "$s"
    fi
  '';

  # Same user-scope ~/.claude.json entry `vexp setup` writes, but via the profile so it
  # survives upgrades and GC. ~/.claude.json is Claude Code's own mutable state.
  home.activation.vexpMcp = lib.hm.dag.entryAfter ["writeBoundary"] ''
    c="$HOME/.claude.json"
    if [ -f "$c" ] && [ "$(${pkgs.jq}/bin/jq -r '.mcpServers.vexp.command // ""' "$c")" != "${profileBin}/vexp-mcp" ]; then
      tmp="$(mktemp)"
      ${pkgs.jq}/bin/jq --arg p "${profileBin}/vexp-mcp" '.mcpServers.vexp = {type: "stdio", command: $p, args: []}' "$c" > "$tmp"
      run mv "$tmp" "$c"
    fi
  '';
}
