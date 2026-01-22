#!/bin/bash

# This script installs NeoVim (if not present) and sets it up with ai.nvim and optional plugins.

set -e

# --- Localization Definitions ---
declare -A MESSAGES_ja
MESSAGES_ja["CHOOSE_LANGUAGE"]="言語を選択してください (Please choose your language):"
MESSAGES_ja["LANGUAGE_OPTIONS"]="1) 日本語\n2) English"
MESSAGES_ja["ENTER_CHOICE"]="選択肢の番号を入力してください: "
MESSAGES_ja["INVALID_CHOICE"]="無効な選択です。デフォルトの言語（English）を使用します。"
MESSAGES_ja["STARTING_SETUP"]="NeoVimのセットアップを開始します..."
MESSAGES_ja["PART1_HEADER"]="--- パート1: NeoVimのインストール ---"
MESSAGES_ja["CHECKING_NEOVIM"]="NeoVimの有無を確認しています..."
MESSAGES_ja["NEOVIM_NOT_FOUND"]="NeoVimが見つかりません。インストールを開始します..."
MESSAGES_ja["ERROR_REQUIRED_COMMAND_NOT_FOUND"]="エラー: 必要なコマンド '%s' が見つかりません。インストールしてからスクリプトを再実行してください。"
MESSAGES_ja["DETECTED_ARCHITECTURE"]="検出されたアーキテクチャ: %s"
MESSAGES_ja["INSTALLATION_DIRECTORY"]="インストールディレクトリ: %s"
MESSAGES_ja["DOWNLOADING_APPIMAGE_X86"]="x86_64用のNeoVim AppImage (安定版) をダウンロードしています..."
MESSAGES_ja["DOWNLOADING_TAR_ARM"]="ARM64用のNeoVim tar.gz (安定版) をダウンロードしています..."
MESSAGES_ja["GRANTING_EXEC_PERMISSION"]="実行権限を付与しています..."
MESSAGES_ja["EXTRACTING_APPIMAGE"]="AppImageを展開しています..."
MESSAGES_ja["EXTRACTING_TAR"]="tar.gzを展開しています..."
MESSAGES_ja["ERROR_UNSUPPORTED_ARCHITECTURE"]="エラー: サポートされていないアーキテクチャ '%s' です。NeoVimをインストールできません。"
MESSAGES_ja["ERROR_NVIM_EXECUTABLE_NOT_FOUND"]="エラー: 展開後にnvim実行ファイルが見つかりません。"
MESSAGES_ja["CREATING_SYMLINK"]="nvimのシンボリックリンクを /usr/local/bin に作成しています..."
MESSAGES_ja["ADMIN_PRIVILEGES_REQUIRED"]="これには管理者（sudo）権限が必要です。"
MESSAGES_ja["REMOVING_EXISTING_SYMLINK"]="既存のシンボリックリンク /usr/local/bin/nvim を削除しています。"
MESSAGES_ja["BACKING_UP_EXISTING_FILE"]="既存のファイル /usr/local/bin/nvim を /usr/local/bin/nvim.bak にバックアップしています。"
MESSAGES_ja["NVIM_INSTALLATION_COMPLETE"]="✓ NeoVimのインストールが完了しました！"
MESSAGES_ja["NVIM_AVAILABLE"]="'nvim' コマンドが利用可能になり、%s にリンクされました。"
MESSAGES_ja["NVIM_ALREADY_INSTALLED"]="✓ NeoVimはすでに %s にインストールされています。"
MESSAGES_ja["PART2_HEADER"]="--- パート2: NeoVimの設定 ---"
MESSAGES_ja["CHECKING_CORE_PLUGINS"]="コアNeoVimプラグインを確認しています..."
MESSAGES_ja["GIT_NOT_FOUND"]="エラー: 'git' コマンドが見つかりません。gitをインストールしてからスクリプトを再実行してください。"
MESSAGES_ja["CLONING_PLUGIN"]="'%s' をクローンしています..."
MESSAGES_ja["PLUGIN_CLONED"]="✓ '%s' が正常にクローンされました。"
MESSAGES_ja["PLUGIN_ALREADY_INSTALLED"]="✓ '%s' はすでにインストールされています。"
MESSAGES_ja["STARTING_CONFIGURATION"]="NeoVimの設定を開始します..."
MESSAGES_ja["CREATED_CONFIG_DIR"]="作成/確認済みディレクトリ: %s"
MESSAGES_ja["CREATED_BASE_INIT_LUA"]="ベースの init.lua を %s に作成しました。"
MESSAGES_ja["INSTALL_ESSENTIAL_PLUGINS"]="必須プラグイン（telescope、treesitterなど）をインストールしますか？ [y/N]: "
MESSAGES_ja["ADDED_ESSENTIAL_PLUGINS"]="init.luaに必須プラグインを追加しました。"
MESSAGES_ja["INSTALL_DEVELOPMENT_PLUGINS"]="開発用プラグイン（LSP、補完、デバッガ）をインストールしますか？ [y/N]: "
MESSAGES_ja["ADDED_DEVELOPMENT_PLUGINS"]="init.luaに開発用プラグインを追加しました。"
MESSAGES_ja["INSTALL_GEMINI_CLI"]="Gemini連携のために gemini-cli.nvim をインストールしますか？ [y/N]: "
MESSAGES_ja["ADDED_GEMINI_CLI"]="init.luaに gemini-cli.nvim を追加しました。"
MESSAGES_ja["INSTALL_CODE_COMPANION"]="AI支援のコード補完と生成のために CodeCompanion.nvim をインストールしますか？ [y/N]: "
MESSAGES_ja["ADDED_CODE_COMPANION"]="init.luaに CodeCompanion.nvim を追加しました。"
MESSAGES_ja["CHOOSE_LLM_MODEL"]="CodeCompanion.nvimで使用するLLMモデルを選択してください:"
MESSAGES_ja["LLM_MODEL_OPTIONS"]="1) Gemini 3 Pro\n2) Gemini 3 Flash\n3) Gemini 2.5 Pro\n4) Gemini 2.5 Flash\n5) GPT-5\n6) GPT-4.5\n7) Claude 3.5 Sonnet\n8) Claude Opus"
MESSAGES_ja["ENTER_API_KEY"]="APIキーを入力してください: "
MESSAGES_ja["ADDED_DEV_PLUGIN_CONFIGS"]="init.luaに開発プラグイン設定を追加しました。"
MESSAGES_ja["SETUP_COMPLETE"]="✓ セットアップが完了しました！"
MESSAGES_ja["RUN_NVIM_TO_INSTALL"]="'nvim' を実行して設定されたプラグインをインストールしてください。"

declare -A MESSAGES_en
MESSAGES_en["CHOOSE_LANGUAGE"]="Please choose your language (言語を選択してください):"
MESSAGES_en["LANGUAGE_OPTIONS"]="1) 日本語\n2) English"
MESSAGES_en["ENTER_CHOICE"]="Enter the number of your choice: "
MESSAGES_en["INVALID_CHOICE"]="Invalid choice. Using default language (English)."
MESSAGES_en["STARTING_SETUP"]="Starting NeoVim setup..."
MESSAGES_en["PART1_HEADER"]="--- Part 1: NeoVim Installation ---"
MESSAGES_en["CHECKING_NEOVIM"]="Checking for NeoVim..."
MESSAGES_en["NEOVIM_NOT_FOUND"]="NeoVim not found. Starting installation..."
MESSAGES_en["ERROR_REQUIRED_COMMAND_NOT_FOUND"]="Error: Required command '%s' not found. Please install it and run the script again."
MESSAGES_en["DETECTED_ARCHITECTURE"]="Detected architecture: %s"
MESSAGES_en["INSTALLATION_DIRECTORY"]="Installation directory: %s"
MESSAGES_en["DOWNLOADING_APPIMAGE_X86"]="Downloading NeoVim AppImage for x86_64 (stable)..."
MESSAGES_en["DOWNLOADING_TAR_ARM"]="Downloading NeoVim tar.gz for ARM64 (stable)..."
MESSAGES_en["GRANTING_EXEC_PERMISSION"]="Granting execute permission..."
MESSAGES_en["EXTRACTING_APPIMAGE"]="Extracting AppImage..."
MESSAGES_en["EXTRACTING_TAR"]="Extracting tar.gz..."
MESSAGES_en["ERROR_UNSUPPORTED_ARCHITECTURE"]="Error: Unsupported architecture '%s'. Cannot install NeoVim."
MESSAGES_en["ERROR_NVIM_EXECUTABLE_NOT_FOUND"]="Error: Failed to find nvim executable after extraction at '%s'."
MESSAGES_en["CREATING_SYMLINK"]="Creating a symbolic link for nvim in /usr/local/bin..."
MESSAGES_en["ADMIN_PRIVILEGES_REQUIRED"]="This requires administrator (sudo) privileges."
MESSAGES_en["REMOVING_EXISTING_SYMLINK"]="Removing existing symlink at /usr/local/bin/nvim."
MESSAGES_en["BACKING_UP_EXISTING_FILE"]="Backing up existing file at /usr/local/bin/nvim to /usr/local/bin/nvim.bak."
MESSAGES_en["NVIM_INSTALLATION_COMPLETE"]="✓ NeoVim installation complete!"
MESSAGES_en["NVIM_AVAILABLE"]="'nvim' command is now available and linked to %s."
MESSAGES_en["NVIM_ALREADY_INSTALLED"]="✓ NeoVim is already installed at %s."
MESSAGES_en["PART2_HEADER"]="--- Part 2: NeoVim Configuration ---"
MESSAGES_en["CHECKING_CORE_PLUGINS"]="Checking for core NeoVim plugins..."
MESSAGES_en["GIT_NOT_FOUND"]="Error: 'git' command not found. Please install git and run the script again."
MESSAGES_en["CLONING_PLUGIN"]="Cloning '%s'..."
MESSAGES_en["PLUGIN_CLONED"]="✓ '%s' cloned successfully."
MESSAGES_en["PLUGIN_ALREADY_INSTALLED"]="✓ '%s' already installed."
MESSAGES_en["STARTING_CONFIGURATION"]="Starting NeoVim configuration..."
MESSAGES_en["CREATED_CONFIG_DIR"]="Created/ensured directory: %s"
MESSAGES_en["CREATED_BASE_INIT_LUA"]="Created base init.lua at %s."
MESSAGES_en["INSTALL_ESSENTIAL_PLUGINS"]="Install essential plugins (e.g., telescope, treesitter)? [y/N]: "
MESSAGES_en["ADDED_ESSENTIAL_PLUGINS"]="Added essential plugins to init.lua."
MESSAGES_en["INSTALL_DEVELOPMENT_PLUGINS"]="Install plugins for development (LSP, completion, debugger)? [y/N]: "
MESSAGES_en["ADDED_DEVELOPMENT_PLUGINS"]="Added development plugins to init.lua."
MESSAGES_en["INSTALL_GEMINI_CLI"]="Install gemini-cli.nvim for Gemini integration? [y/N]: "
MESSAGES_en["ADDED_GEMINI_CLI"]="Added gemini-cli.nvim to init.lua."
MESSAGES_en["INSTALL_CODE_COMPANION"]="Install CodeCompanion.nvim for AI-assisted code completion and generation? [y/N]: "
MESSAGES_en["ADDED_CODE_COMPANION"]="Added CodeCompanion.nvim to init.lua."
MESSAGES_en["CHOOSE_LLM_MODEL"]="Choose the LLM model for CodeCompanion.nvim:"
MESSAGES_en["LLM_MODEL_OPTIONS"]="1) Gemini 3 Pro\n2) Gemini 3 Flash\n3) Gemini 2.5 Pro\n4) Gemini 2.5 Flash\n5) GPT-5\n6) GPT-4.5\n7) Claude 3.5 Sonnet\n8) Claude Opus"
MESSAGES_en["ENTER_API_KEY"]="Please enter your API key: "
MESSAGES_en["ADDED_DEV_PLUGIN_CONFIGS"]="Added development plugin configurations to init.lua."
MESSAGES_en["SETUP_COMPLETE"]="✓ Setup complete!"
MESSAGES_en["RUN_NVIM_TO_INSTALL"]="Run 'nvim' to start NeoVim and install the configured plugins."

CURRENT_LANG_CODE="en"

_msg() {
    local key="$1"
    local lang_map_name="MESSAGES_${CURRENT_LANG_CODE}[$key]"
    if [[ -v "$lang_map_name" ]]; then
        printf "${!lang_map_name}" "${@:2}"
    elif [[ -v "MESSAGES_en[$key]" ]]; then
        printf "${MESSAGES_en[$key]}" "${@:2}"
    else
        echo "$key" "${@:2}"
    fi
}

echo "$(_msg \"CHOOSE_LANGUAGE\")"
echo -e "$(_msg \"LANGUAGE_OPTIONS\")"
read -p "$(_msg \"ENTER_CHOICE\")" LANG_CHOICE
case "$LANG_CHOICE" in
    1) CURRENT_LANG_CODE="ja" ;; 
    2) CURRENT_LANG_CODE="en" ;; 
    *) echo "$(_msg \"INVALID_CHOICE\")"; CURRENT_LANG_CODE="en" ;; 
esac
echo
echo "$(_msg \"STARTING_SETUP\")"
echo

echo "$(_msg \"PART1_HEADER\")"
if ! command -v nvim &> /dev/null; then
    echo "$(_msg "NEOVIM_NOT_FOUND")"
    for cmd in curl chmod sudo tar uname file rg; do
        if ! command -v $cmd &> /dev/null; then
            echo "$(_msg "ERROR_REQUIRED_COMMAND_NOT_FOUND" "$cmd")"
            exit 1
        fi
    done
    ARCH=$(uname -m)
    echo "$(_msg \"DETECTED_ARCHITECTURE\" \"$ARCH\")"
    NVIM_INSTALL_DIR="$HOME/AppImage/nvim-stable"
    mkdir -p "$NVIM_INSTALL_DIR"
    echo "$(_msg \"INSTALLATION_DIRECTORY\" \"$NVIM_INSTALL_DIR\")"
    if [ "$ARCH" = "x86_64" ]; then
        echo "$(_msg "DOWNLOADING_APPIMAGE_X86")"
        curl -Lo "$NVIM_INSTALL_DIR/nvim.appimage" https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-x86_64.appimage
        echo "$(_msg "GRANTING_EXEC_PERMISSION")"
        chmod +x "$NVIM_INSTALL_DIR/nvim.appimage"
        echo "$(_msg "EXTRACTING_APPIMAGE")"
        rm -rf "$NVIM_INSTALL_DIR/squashfs-root"
        (cd "$NVIM_INSTALL_DIR" && ./nvim.appimage --appimage-extract)
        NVIM_EXECUTABLE_PATH="$NVIM_INSTALL_DIR/squashfs-root/usr/bin/nvim"
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        echo "$(_msg "DOWNLOADING_TAR_ARM")"
        curl -Lo "$NVIM_INSTALL_DIR/nvim-linux-arm64.tar.gz" https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-arm64.tar.gz
        echo "$(_msg "EXTRACTING_TAR")"
        rm -rf "$NVIM_INSTALL_DIR/nvim-linux-arm64"
        tar -xzf "$NVIM_INSTALL_DIR/nvim-linux-arm64.tar.gz" -C "$NVIM_INSTALL_DIR"
        NVIM_EXECUTABLE_PATH="$NVIM_INSTALL_DIR/nvim-linux-arm64/bin/nvim"
    else
        echo "$(_msg \"ERROR_UNSUPPORTED_ARCHITECTURE\" \"$ARCH\")"
        exit 1
    fi
    if [ ! -f "$NVIM_EXECUTABLE_PATH" ]; then
        echo "$(_msg \"ERROR_NVIM_EXECUTABLE_NOT_FOUND\" \"$NVIM_EXECUTABLE_PATH\")"
        exit 1
    fi
    echo "$(_msg \"CREATING_SYMLINK\")"
    echo "$(_msg \"ADMIN_PRIVILEGES_REQUIRED\")"
    if [ -e "/usr/local/bin/nvim" ]; then
        if [ -L "/usr/local/bin/nvim" ]; then
            echo "$(_msg \"REMOVING_EXISTING_SYMLINK\")"
            sudo rm /usr/local/bin/nvim
        else
            echo "$(_msg \"BACKING_UP_EXISTING_FILE\")"
            sudo mv /usr/local/bin/nvim /usr/local/bin/nvim.bak
        fi
    fi
    sudo ln -s "$NVIM_EXECUTABLE_PATH" /usr/local/bin/nvim
    echo "$(_msg \"NVIM_INSTALLATION_COMPLETE\")"
    echo "$(_msg \"NVIM_AVAILABLE\" \"$NVIM_EXECUTABLE_PATH\")"
else
    echo "$(_msg \"NVIM_ALREADY_INSTALLED\" \"$(command -v nvim)\")"
fi
echo

echo "$(_msg \"PART2_HEADER\")"
echo "$(_msg \"CHECKING_CORE_PLUGINS\")"
if ! command -v git &> /dev/null; then
    echo "$(_msg \"GIT_NOT_FOUND\")"
    exit 1
fi
clone_plugin() {
    local repo_url=$1
    local plugin_dir=$2
    local plugin_name=$(basename "$plugin_dir")
    if [ ! -d "$plugin_dir" ]; then
        echo "$(_msg \"CLONING_PLUGIN\" \"$plugin_name\")"
        mkdir -p "$(dirname "$plugin_dir")"
        git clone --depth=1 "$repo_url" "$plugin_dir"
        echo "$(_msg \"PLUGIN_CLONED\" \"$plugin_name\")"
    else
        echo "$(_msg \"PLUGIN_ALREADY_INSTALLED\" \"$plugin_name\")"
    fi
}
clone_plugin "https://github.com/gera2ld/ai.nvim.git" "$HOME/.local/share/nvim/site/pack/dist/start/ai.nvim"
clone_plugin "https://github.com/nvim-lua/plenary.nvim.git" "$HOME/.local/share/nvim/site/pack/dist/start/plenary.nvim"
clone_plugin "https://github.com/olimorris/codecompanion.nvim.git" "$HOME/.local/share/nvim/site/pack/dist/start/codecompanion.nvim"
clone_plugin "https://github.com/nvim-treesitter/nvim-treesitter.git" "$HOME/.local/share/nvim/site/pack/dist/start/nvim-treesitter"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
INIT_LUA_PATH="$NVIM_CONFIG_DIR/init.lua"
echo "$(_msg \"STARTING_CONFIGURATION\")"
mkdir -p "$NVIM_CONFIG_DIR"
echo "$(_msg \"CREATED_CONFIG_DIR\" \"$NVIM_CONFIG_DIR\")"
cat << 'EOF' > "$INIT_LUA_PATH"
-- ai.nvim setup
-- For more details, see: https://github.com/gera2ld/ai.nvim
require('ai').setup({
  engine = 'gemini',
  -- add your other ai.nvim configurations here
  plugins = {
    -- astrocore is required for ai.nvim
    { 'AstroNvim/astrocore', opts = {
      mappings = {
        n = {
          ['<Leader>l'] = false,
        },
      },
    } },
EOF
echo "$(_msg \"CREATED_BASE_INIT_LUA\" \"$INIT_LUA_PATH\")"
read -p "$(_msg \"INSTALL_ESSENTIAL_PLUGINS\")" -r install_essential
if [[ "$install_essential" =~ ^[yY](es)?$ ]]; then
  cat << 'EOF' >> "$INIT_LUA_PATH"
    -- Essential & popular plugins
    { 'nvim-telescope/telescope.nvim', tag = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'lewis6991/gitsigns.nvim' },
EOF
  echo "$(_msg \"ADDED_ESSENTIAL_PLUGINS\")"
fi
read -p "$(_msg \"INSTALL_DEVELOPMENT_PLUGINS\")" -r install_specific
if [[ "$install_specific" =~ ^[yY](es)?$ ]]; then
  cat << 'EOF' >> "$INIT_LUA_PATH"
    -- Plugins for development
    { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' } },
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'mfussenegger/nvim-dap' },
EOF
  echo "$(_msg \"ADDED_DEVELOPMENT_PLUGINS\")"
fi
read -p "$(_msg \"INSTALL_GEMINI_CLI\")" -r install_gemini_cli
if [[ "$install_gemini_cli" =~ ^[yY](es)?$ ]]; then
  cat << 'EOF' >> "$INIT_LUA_PATH"
    -- Gemini CLI plugin
    { 'gera2ld/gemini-cli.nvim' },
EOF
  echo "$(_msg \"ADDED_GEMINI_CLI\")"
fi
echo "  }," >> "$INIT_LUA_PATH"
echo "})" >> "$INIT_LUA_PATH"
read -p "$(_msg \"INSTALL_CODE_COMPANION\")" -r install_code_companion
if [[ "$install_code_companion" =~ ^[yY](es)?$ ]]; then
  echo "$(_msg "CHOOSE_LLM_MODEL")"
  echo -e "$(_msg "LLM_MODEL_OPTIONS")"
  read -p "$(_msg "ENTER_CHOICE")" llm_choice
  case "$llm_choice" in
    1) ADAPTER_NAME="gemini"; LLM_MODEL="gemini-3-pro" ;;
    2) ADAPTER_NAME="gemini"; LLM_MODEL="gemini-3-flash" ;;
    3) ADAPTER_NAME="gemini"; LLM_MODEL="gemini-2.5-pro" ;;
    4) ADAPTER_NAME="gemini"; LLM_MODEL="gemini-2.5-flash" ;;
    5) ADAPTER_NAME="openai"; LLM_MODEL="gpt-5" ;;
    6) ADAPTER_NAME="openai"; LLM_MODEL="gpt-4.5" ;;
    7) ADAPTER_NAME="anthropic"; LLM_MODEL="claude-3.5-sonnet" ;;
    8) ADAPTER_NAME="anthropic"; LLM_MODEL="claude-opus" ;;
    *) ADAPTER_NAME="gemini"; LLM_MODEL="gemini-3-pro" ;;
  esac
  read -sp "$(_msg 'ENTER_API_KEY')" API_KEY
  echo
  cat << EOF >> "$INIT_LUA_PATH"

-- Setup CodeCompanion separately
require('codecompanion').setup({
  adapters = {
    ["$ADAPTER_NAME"] = {
      model = "'$LLM_MODEL'",
      api_key = "'$API_KEY'",
    }
  },
  tools = {
    -- your tools options
  }
})
EOF
  echo "$(_msg "ADDED_CODE_COMPANION")"
fi
if [[ "$install_specific" =~ ^[yY](es)?$ ]]; then
  cat << 'EOF' >> "$INIT_LUA_PATH"

-- Setup mason so it can manage external tooling
pcall(function()
  require('mason').setup()
  require('mason-lspconfig').setup({
    -- Add servers you want to install automatically.
    -- For example: { 'lua_ls', 'bashls', 'gopls' }
    ensure_installed = {},
  })

  -- Basic LSP and completion setup
  local lspconfig = require('lspconfig')
  local cmp = require('cmp')

  cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
    }
  })

  -- Configure LSP servers here
  -- Example for lua_ls
  -- lspconfig.lua_ls.setup({
  --   settings = {
  --     Lua = {
  --       diagnostics = {
  --         globals = { 'vim' },
  --       },
  --     },
  --   },
  -- })
end)
EOF
  echo "$(_msg \"ADDED_DEV_PLUGIN_CONFIGS\")"
fi
echo
echo "$(_msg \"SETUP_COMPLETE\")"
echo "$(_msg \"RUN_NVIM_TO_INSTALL\")"

exit 0
