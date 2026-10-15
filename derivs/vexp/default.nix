# vexp (https://vexp.dev) -- local code-graph context engine + MCP server for coding agents.
# Proprietary: npm CLI (vexp-cli) + prebuilt Rust core (@vexp/core-<platform>).
# Bump: update version + both hashes (`integrity` from registry.npmjs.org/<pkg>/<version>),
# then regenerate package-lock.json with optionalDependencies stripped (see postPatch).
{
  lib,
  buildNpmPackage,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jq,
  nodejs,
  stdenv,
  # Stable path to bin/vexp-core (e.g. the user profile). `vexp setup` bakes the core's
  # path into per-repo .claude/hooks; a store path there goes dead after the next GC.
  corePath ? null,
}: let
  version = "3.3.4";
  # shortcut: x86_64-linux core only, add @vexp/core-linux-arm64 if an arm host needs vexp.
  core = fetchurl {
    url = "https://registry.npmjs.org/@vexp/core-linux-x64/-/core-linux-x64-${version}.tgz";
    hash = "sha512-nGcB8UByV6R52jgGdmsHS/xVEe6lXMbhSrEq5awAWN3WqTcw6zdBDwojTfVWEx/3/Xq3+b1onmm1nPUd2cCjUA==";
  };
in
  buildNpmPackage {
    pname = "vexp";
    inherit version;

    src = fetchurl {
      url = "https://registry.npmjs.org/vexp-cli/-/vexp-cli-${version}.tgz";
      hash = "sha512-2S6w96h/E+9Ql9/uHukQxtRQpG2Vs4qK8Oy8J9dvpVa88/hdcFqZVKDwmpY61CP8pWdah4474HC7Z8j0X262RA==";
    };

    # Platform cores are optionalDependencies; drop them so npm doesn't fetch all five.
    postPatch = ''
      ${jq}/bin/jq 'del(.optionalDependencies)' package.json > package.json.new
      mv package.json.new package.json
      cp ${./package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-84e69vxTIqbGRJbhUbGp2iy6T4/3NeJSgSUCsvxfvVc=";
    dontNpmBuild = true;

    nativeBuildInputs = [autoPatchelfHook makeWrapper];
    buildInputs = [stdenv.cc.cc.lib];

    # Both the CLI and mcp/mcp-server.cjs find the core at node_modules/@vexp/core-linux-x64.
    # Nix owns updates and store paths move on upgrade, so no update nags and no
    # autostart unit baking in a store path.
    postInstall = ''
      corePkg=$out/lib/node_modules/vexp-cli/node_modules/@vexp/core-linux-x64
      mkdir -p $corePkg
      tar xzf ${core} -C $corePkg --strip-components=1
      ln -s $corePkg/bin/vexp-core $out/bin/vexp-core

      wrapProgram $out/bin/vexp \
        --set VEXP_SKIP_UPDATE_CHECK 1 \
        --set VEXP_NO_AUTOSTART_INSTALL 1 ${lib.optionalString (corePath != null) "--set VEXP_CORE_PATH ${corePath}"}
      makeWrapper ${nodejs}/bin/node $out/bin/vexp-mcp \
        --add-flags $out/lib/node_modules/vexp-cli/mcp/mcp-server.cjs
    '';

    meta = {
      description = "Local dependency-graph context engine and MCP server for AI coding agents";
      homepage = "https://vexp.dev";
      license = lib.licenses.unfree;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = ["x86_64-linux"];
      mainProgram = "vexp";
    };
  }
