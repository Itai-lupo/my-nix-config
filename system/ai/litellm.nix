{ systemSettings, lib, ... }:

{
  services.litellm = {
    enable = true;
    settings = {
      model_list = [
        # 🟢 1. INLINE AUTO-SUGGESTIONS (Fits 100% in VRAM)
        {
          model_name = "lsp";
          litellm_params = {
            model = "ollama/qwen2.5-coder:1.5b";
            api_base = "http://localhost:11434";
            temperature = 0.0;
            num_ctx = 4096;
            max_tokens = 1024;
          };
        }

        # 🟢 2. NEOVIM SIDEBAR CHAT PANEL (Fits 100% in VRAM)
        {
          model_name = "code";
          litellm_params = {
            model = "ollama/qwen2.5-coder:7b";
            api_base = "http://localhost:11434";
            temperature = 0.3;
            num_ctx = 8192;
            max_tokens = 4096;
          };
        }

        # 🟢 3. FAST VRAM REASONING / BRAINSTORMING / OBSIDIAN PRIVATE THOUGHTS
        {
          model_name = "think";
          litellm_params = {
            model = "ollama/deepseek-r1:8b";
            api_base = "http://localhost:11434";
            temperature = 0.3;
            num_ctx = 8192;
            max_tokens = 4096;
          };
        }

        # 🔵 4. DATA SHEETS & LOCAL MULTI-FILE REFACTORING (System RAM)
        {
          model_name = "dev";
          litellm_params = {
            model = "ollama/deepseek-r1:32b";
            api_base = "http://localhost:11434";
            timeout = 9000;
            max_tokens = 8192;
            num_ctx = 32000;
            temperature = 0.6;
          };
        }

        {
          model_name = "specsheet_local";
          litellm_params = {
            model = "ollama/deepseek-r1:32b";
            api_base = "http://localhost:11434";
            timeout = 9000;
            max_tokens = 8192;
            num_ctx = 32000;
            temperature = 0.0;
          };
        }

        # 🔵 5. GENERAL HEAVY LOCAL MATH & LOGIC ORACLE (System RAM)
        {
          model_name = "general";
          litellm_params = {
            model = "ollama/deepseek-r1:32b";
            api_base = "http://localhost:11434";
            timeout = 9000;
            max_tokens = 8192;
            num_ctx = 32000;
            temperature = 0.6;
          };
        }

        # ☁️ 6. UNLIMITED FREE CLOUD DAILY DRIVER (1M Context - Perfect for Obsidian Vaults!)
        {
          model_name = "cloud";
          litellm_params = {
            model = "gemini/gemini-3.5-flash";
            api_key = lib.strings.fileContents "${systemSettings.dotfilePath}/${systemSettings.secretsPath}/gemini.key";
            rpm = 5;
            rpd = 20;
          };
        }

        # ☁️ 7. FREE OPENROUTER ARCHITECTURE GIANT (70B)
        {
          model_name = "best";
          litellm_params = {
            model = "openrouter/meta-llama/llama-3.3-70b";
            api_key = lib.strings.fileContents "${systemSettings.dotfilePath}/${systemSettings.secretsPath}/openrouter.key";
            rpm = 10;
          };
        }

        # ☁️ 8. THE DEEPEST COGNITIVE REASONING FLAGSHIP (V4 - Hard Limited, Use Sparingly!)
        {
          model_name = "deep"; # Successfully updated from boss/agent
          litellm_params = {
            model = "openrouter/deepseek/deepseek-v4-flash:free";
            api_key = lib.strings.fileContents "${systemSettings.dotfilePath}/${systemSettings.secretsPath}/openrouter.key";
            rpm = 10;
          };
        }

        # 🟢 9. LOCAL VECTOR EMBEDDING ENGINE (Unified via LiteLLM)
        {
          model_name = "embed"; # Short, typo-proof alias for vector tasks
          litellm_params = {
            model = "ollama/nomic-embed-text";
            api_base = "http://localhost:11434";
          };
        }
        # 📑 10. THE PRIMARY PARSER (Gemma 4 31B Cloud - Unlimited Layout & OCR Engine)
        {
          model_name = "specsheet";
          litellm_params = {
            model = "gemini/gemma-4-31b-it";
            api_key = lib.strings.fileContents "${systemSettings.dotfilePath}/${systemSettings.secretsPath}/gemini.key";
            rpm = 15;
            rpd = 500;
          };
        }

        # 📦 11. THE LONG-CONTEXT MONSTER (Gemini 3.1 Flash-Lite - 1-Million Token Window)
        {
          model_name = "bulk";
          litellm_params = {
            model = "gemini/gemini-3.1-flash-lite";
            api_key = lib.strings.fileContents "${systemSettings.dotfilePath}/${systemSettings.secretsPath}/gemini.key";
          };
        }
      ];

      set_verbose = true;
      success_callback = [ "langfuse" ]; # Optional: if you want a UI to see history
    };

    port = 4000;
  };


}


































