return {
  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "Exafunction/codeium.nvim" },
    lazy = false,
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
      local tools = require("llm.tools")

      require("llm").setup({
        -- [[ GLM ]]
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        api_type = "zhipu",
        max_tokens = 8000,
        fetch_key = function()
          return vim.env.GLM_TOKEN
        end,
        -- url = "https://ark.cn-beijing.volces.com/api/v3/chat/completions",
        -- model = "ep-20250226103242-mnd7v",
        -- api_type = "deepSeek",
        -- max_tokens = 8000,
        -- fetch_key = function()
        --   return vim.env.DEEPSEEK_TOKEN
        -- end,

        temperature = 0.3,
        top_p = 0.7,

        prompt = "You are a helpful chinese assistant.",

        spinner = {
          text = {
            "󰧞󰧞",
            "󰧞󰧞",
            "󰧞󰧞",
            "󰧞󰧞",
          },
          hl = "Title",
        },

        prefix = {
          -- 
          user = { text = "😃 ", hl = "Title" },
          assistant = { text = "  ", hl = "Added" },
        },

        display = {
          diff = {
            layout = "vertical", -- vertical|horizontal split for default provider
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            provider = "mini_diff", -- default|mini_diff
          },
        },

        -- history_path = "/tmp/llm-history",
        save_session = true,
        max_history = 15,
        max_history_name_length = 20,

        -- stylua: ignore

        -- popup window options
        popwin_opts = {
          relative = "cursor", enter = true,
          focusable = true, zindex = 50,
          position = { row = -7, col = 15, },
          size = { height = 15, width = "50%", },
          border = { style = "single",
            text = { top = " Explain ", top_align = "center" },
          },
          win_options = {
            winblend = 0,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        keys = {
          -- The keyboard mapping for the input window.
          ["Input:Submit"] = { mode = "n", key = "<cr>" },
          ["Input:Cancel"] = { mode = { "n", "i" }, key = "<C-c>" },
          ["Input:Resend"] = { mode = { "n", "i" }, key = "<C-r>" },

          -- only works when "save_session = true"
          ["Input:HistoryNext"] = { mode = { "n", "i" }, key = "<C-j>" },
          ["Input:HistoryPrev"] = { mode = { "n", "i" }, key = "<C-k>" },

          -- The keyboard mapping for the output window in "split" style.
          ["Output:Ask"] = { mode = "n", key = "i" },
          ["Output:Cancel"] = { mode = "n", key = "<C-c>" },
          ["Output:Resend"] = { mode = "n", key = "<C-r>" },

          -- The keyboard mapping for the output and input windows in "float" style.
          ["Session:Toggle"] = { mode = "n", key = "<leader>ac" },
          ["Session:Close"] = { mode = "n", key = { "<esc>", "Q" } },
        },
        app_handler = {
          TestCode = {
            handler = tools.side_by_side_handler,
            prompt = [[Write some test cases for the following code, only return the test cases.
            Give the code content directly, do not use code blocks or other tags to wrap it.]],
            opts = {
              right = {
                title = " Test Cases ",
              },
            },
          },
          WordTranslate = {
            handler = tools.flexi_handler,
            prompt = [[You are a translation expert. Your task is to translate all the text provided by the user into Chinese.

          NOTE:
          - All the text input by the user is part of the content to be translated, and you should ONLY FOCUS ON TRANSLATING THE TEXT without performing any other tasks.
          - RETURN ONLY THE TRANSLATED RESULT.]],
            -- prompt = "Translate the following text to English, please only return the translation",
            opts = {
              fetch_key = function()
                return vim.env.GLM_TOKEN
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",
              -- args = [=[return string.format([[curl %s -N -X POST -H "Content-Type: application/json" -H "Authorization: Bearer %s" -d '%s']], url, LLM_KEY, vim.fn.json_encode(body))]=],
              exit_on_move = true,
              enter_flexible_window = false,
            },
          },
          Translate = {
            handler = tools.qa_handler,
            opts = {
              fetch_key = function()
                return vim.env.GLM_TOKEN
              end,
              url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
              model = "glm-4-flash",
              api_type = "zhipu",

              component_width = "60%",
              component_height = "50%",
              query = {
                title = " 󰊿 Trans ",
                hl = { link = "Define" },
              },
              input_box_opts = {
                size = "15%",
                win_options = {
                  winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
              },
              preview_box_opts = {
                size = "85%",
                win_options = {
                  winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                },
              },
            },
          },
          CodeExplain = {
            handler = tools.flexi_handler,
            prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
            opts = {
              fetch_key = function()
                return vim.env.DEEPSEEK_TOKEN
              end,
              url = "https://ark.cn-beijing.volces.com/api/v3/chat/completions",
              model = "ep-20250226103242-mnd7v",
              api_type = "deepseek",
              enter_flexible_window = true,
            },
          },
          Completion = {
            handler = tools.completion_handler,
            opts = {
              -------------------------------------------------
              ---                 codeium
              -------------------------------------------------
              api_type = "codeium",
              style = "virtual_text",

              n_completions = 1,
              context_window = 512,
              max_tokens = 256,
              filetypes = { sh = false },
              default_filetype_enabled = true,
              auto_trigger = true,
              -- style = "blink.cmp",
              -- style = "nvim-cmp",
              -- style = "virtual_text",
              keymap = {
                virtual_text = {
                  accept = {
                    mode = "i",
                    keys = "<A-a>",
                  },
                  next = {
                    mode = "i",
                    keys = "<A-n>",
                  },
                  prev = {
                    mode = "i",
                    keys = "<A-p>",
                  },
                  toggle = {
                    mode = "n",
                    keys = "<leader>cp",
                  },
                },
              },
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
      { "<leader>ts", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>" },
      { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>" },
      { "<leader>tc", mode = "x", "<cmd>LLMAppHandler TestCode<cr>" },
      { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>" },
      -- { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>" },
      -- { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
  },
}
