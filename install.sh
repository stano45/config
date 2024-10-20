#!/bin/bash

GITCONFIG=".gitconfig"
ZSHRC=".zshrc"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

move_gitconfig() {
    echo "Moving .gitconfig to home directory..."
    cp "$GITCONFIG" "$HOME/"
}

install_zsh() {
    echo "Updating system package manager..."
    sudo apt-get update

    echo "Installing zsh..."
    if ! command -v zsh &>/dev/null; then
        sudo apt-get install -y zsh
    else
        echo "Zsh is already installed."
    fi

    echo "Installing Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh is already installed."
    fi

    echo "Setting zsh as the default shell..."
    chsh -s /usr/bin/zsh
}

move_zsh_config() {
    echo "Moving .zshrc to home directory..."
    cp "$ZSHRC" "$HOME/"

    echo "Moving .p10k.zsh to home directory..."
    cp .p10k.zsh "$HOME/"
}

install_zsh_plugins() {
    echo "Installing zsh-syntax-highlighting plugin..."
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo "source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>"$HOME/.zshrc"
    fi

    echo "Installing zsh-autosuggestions plugin..."
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo "source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >>"$HOME/.zshrc"
    fi

    echo "Installing Powerlevel10k theme..."
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 -- https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi
}

move_gitconfig
install_zsh
move_zsh_config
install_zsh_plugins

echo "Reloading zsh to apply changes..."
exec zsh
source ~/.zshrc
