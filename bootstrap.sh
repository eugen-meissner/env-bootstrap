#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# `set -eu` causes an 'unbound variable' error in case SUDO_USER is not set
SUDO_USER=$(whoami)

# Check for Homebrew, install if not installed
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Update and upgrade..."

brew update
brew upgrade

PACKAGES=(
    git
    stylua
    prettier
    thefuck
    z
    fd
    neovim
    fzf
    yarn
    node
    nvm
    ripgrep
    wget
    tmux
    jq
    ffmpeg
    python3
    azure-cli
    openssl
    docker
    transmission-cli
    flycut
    skhd
    nmap
    watch
    zsh
    gh
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

CASKS=(
    alfred
    iterm2
    neovide
    karabiner-elements
    spacelauncher
    yabai
    ubersicht
    firefox
    macs-fan-control
    signal
    dotnet-sdk
    visual-studio-code 
    sublime-text
)

echo "Installing cask apps..."
sudo -u $SUDO_USER brew install --cask ${CASKS[@]}

echo "Cleaning up"
brew cleanup
echo "Ask the doctor"
brew doctor

echo "Install additional apps..."
if [! -d "~/.oh-my-zsh"]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "System configuration..."
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
if ! grep -q "source $(brew --prefix)/etc/profile.d/z.sh"; then
    echo "source $(brew --prefix)/etc/profile.d/z.sh" >> ~/.zshrc
fi

echo "Install dotnet tools..."
if [ ! -f "~/.config/dotnet-tools.json" ]; then
    dotnet new tool-manifest
fi
DOTNET_TOOLS=(
    csharpier
    dotnet-format
)

sudo -u $SUDO_USER dotnet tool install -g ${DOTNET_TOOLS[@]}

echo "MacOS bootstrapping done"
