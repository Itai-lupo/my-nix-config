{ pkgs, ... }:
let
  # 🆕 Define the isolated, safe test runner script
  aiderTestRunner = pkgs.writeShellScriptBin "aider-test" ''
    if command -v just >/dev/null 2>&1 && [ -f justfile ] && just --summary 2>/dev/null | grep -qw test; then
      exec just test
    else
      exit 0
    fi
  '';
in
{
  home.packages = [ pkgs.aider-chat aiderTestRunner ];

  # This creates the config file in your persistent home directory
  home.file.".aider.conf.yml".source = (pkgs.formats.yaml { }).generate "aider-config" {
    # Main Driver
    model = "openai/dev";
    "openai-api-base" = "http://127.0.0.1:4000/v1";
    "openai-api-key" = "sk-local";

    "set-env" = [
      "OLLAMA_API_BASE=http://127.0.0.1:11434"
    ];

    alias = [
      "openai/dev:ollama/deepseek-r1:32b"
      "openai/code:ollama/qwen2.5-coder:7b"
    ];

    "llm-history-file" = ".aider.llm.history";
    verbose = false;

    # Safety Control
    "auto-commits" = false;
    "dirty-commits" = false;
    "dry-run" = false;
    "edit-format" = "diff";
    show-diffs = true;

    # Codebase Context
    gitignore = true;
    watch-files = true;
    "map-tokens" = 2048;

    analytics = false;

    # UI & Streaming Options
    "dark-mode" = true;
    stream = true;

    "lint-cmd" = [
      "rust: cargo check --tests"
      "python: ruff check"
      "nix: nixpkgs-fmt --check"
      "c: clang -fsyntax-only -Wall -Wextra -Werror"
      "cpp: clang++ -fsyntax-only -Wall -Wextra -Werror"
    ];

    # Automated Test Harness Hook
    "test-cmd" = "${aiderTestRunner}/bin/aider-test";


    # Architect Mode (Commented out structure in Nix format)
    architect = true;
    editor-model = "openai/code";
    "auto-accept-architect" = false;
  };
}
