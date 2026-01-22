# リリースノート
## v0.0.1 2026/1/22
### neovim-setupをリリースしました。
必ずインストールされるプラグイン:
* gera2ld/ai.nvim
* nvim-lua/plenary.nvim
* AstroNvim/astrocore
ユーザーが選択した場合にインストールされるプラグイン:
必須・定番プラグインの選択時:
* nvim-telescope/telescope.nvim
* nvim-treesitter/nvim-treesitter
* lewis6991/gitsigns.nvim
開発用プラグインの選択時:
* hrsh7th/nvim-cmp
* neovim/nvim-lspconfig
* williamboman/mason.nvim
* williamboman/mason-lspconfig.nvim
* mfussenegger/nvim-dap
gemini-cli.nvimの選択時:
* gera2ld/gemini-cli.nvim
codecompanion.nvimの選択時:
* dnlr-dev/CodeCompanion.nvim\
日本語とアメリカ英語に対応しました。

## v0.1.0 2026/1/23
### 一部プラグインの変更をしました。
* dnlr-dev/CodeCompanion.nvimをolimorris/codecompanion.nvimに変更しました。
### 機能追加をしました。
* olimorris/codecompanion.nvimをダイアログ形式で設定できる機能を追加しました。
  * 設定できるLLM
    * Gemini 3 Pro
    * Gemini 3 Flash
    * Gemini 2.5 Pro
    * Gemini 2.5 Flash
    * GPT-5
    * GPT-4.5
    * Claude 3.5 Sonnet
    * Claude Opus
  * LLMを選択後に、API KEYを入力できるようにしました。
