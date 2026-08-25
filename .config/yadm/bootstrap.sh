#!/bin/bash

set -e # Exit on error

echo "🚀 Starting Ubuntu bootstrap..."
echo ""

# Install basic dependencies
echo "📦 Installing basic dependencies..."
sudo apt-get install -y curl git build-essential

# Install Neovim
echo "📦 Installing Neovim..."
if ! command -v nvim &>/dev/null; then
  # Install latest stable Neovim from PPA
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install -y neovim
  echo "✅ Neovim installed"
else
  echo "✅ Neovim already installed"
fi

# Install tmux
echo "📦 Installing tmux..."
if ! command -v tmux &>/dev/null; then
  sudo apt-get install -y tmux
  echo "✅ tmux installed"
else
  echo "✅ tmux already installed"
fi

# Install zsh
echo "📦 Installing zsh..."
if ! command -v zsh &>/dev/null; then
  sudo apt-get install -y zsh
  echo "✅ zsh installed"
else
  echo "✅ zsh already installed"
fi

# Install oh-my-zsh
echo "📦 Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "✅ oh-my-zsh installed"
else
  echo "✅ oh-my-zsh already installed"
fi

# Install Powerlevel10k theme
echo "📦 Installing Powerlevel10k..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  echo "✅ Powerlevel10k installed"
else
  echo "✅ Powerlevel10k already installed"
fi

# Install TPM (Tmux Plugin Manager)
echo "📦 Installing TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "✅ TPM installed"
else
  echo "✅ TPM already installed"
fi

# Install LazyVim dependencies
echo "📦 Installing LazyVim dependencies..."

# Install ripgrep
if ! command -v rg &>/dev/null; then
  sudo apt-get install -y ripgrep
  echo "✅ ripgrep installed"
else
  echo "✅ ripgrep already installed"
fi

# Install fd-find
if ! command -v fdfind &>/dev/null; then
  sudo apt-get install -y fd-find
  # Create symlink for 'fd' command (Ubuntu names it fdfind)
  mkdir -p ~/.local/bin
  ln -sf $(which fdfind) ~/.local/bin/fd
  echo "✅ fd-find installed"
else
  echo "✅ fd-find already installed"
fi

# Install fzf
if ! command -v fzf &>/dev/null; then
  sudo apt-get install -y fzf
  echo "✅ fzf installed"
else
  echo "✅ fzf already installed"
fi

# Install lazygit
if ! command -v lazygit &>/dev/null; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
  echo "✅ lazygit installed"
else
  echo "✅ lazygit already installed"
fi

# Change default shell to zsh
echo "🐚 Setting zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s $(which zsh)
  echo "✅ Default shell changed to zsh"
else
  echo "✅ zsh is already the default shell"
fi

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Open tmux and press Ctrl+b then Shift+I to install tmux plugins"
echo "3. Run 'p10k configure' to customize your prompt"
echo "4. Open Neovim - LazyVim will install plugins automatically"
echo ""
