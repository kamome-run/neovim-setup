# neovim-setup v.0.1.0
NeoVimのインストールと設定をするためのShell Scriptです。
### 必ずインストールされるプラグイン:
   * gera2ld/ai.nvim (プラグインマネージャー)
   * nvim-lua/plenary.nvim (ai.nvimの依存関係)
   * AstroNvim/astrocore (ai.nvimのベース設定に含まれます)
### ユーザーが選択した場合にインストールされるプラグイン:
#### 必須・定番プラグインの選択時:
       * nvim-telescope/telescope.nvim (ファジーファインダー)
       * nvim-treesitter/nvim-treesitter (高度なシンタックスハイライト)
       * lewis6991/gitsigns.nvim (Git連携表示)
#### 開発用プラグインの選択時:
       * hrsh7th/nvim-cmp (自動補完フレームワーク)
       * neovim/nvim-lspconfig (LSPクライアント設定)
       * williamboman/mason.nvim (LSPサーバーなどのパッケージマネージャー)
       * williamboman/mason-lspconfig.nvim (MasonとLSPconfigの連携)
       * mfussenegger/nvim-dap (デバッガー)
#### `gemini-cli.nvim`の選択時:
       * gera2ld/gemini-cli.nvim (Gemini連携)
#### `CodeCompanion.nvim`の選択時:
       * olimorris/CodeCompanion.nvim (AI支援コード補完・生成)
### 使用方法
1. `git clone https://github.com/kamome-run/neovim-setup.git`
2. `cd neovim-setup/`
3. `./setup.sh`
