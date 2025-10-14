#!/bin/bash

#cat /etc/os-release  # for linux / WSL
#uname -srm  # for macbook
# uname -s

# This install script is meant to create a mostly reproducible setup on my unix-like operating systems.

# see if .anyconnect is the same format on linux as it is on macos (or if it even exists)


# TODO:
# - figure out a plugin for vim/nvim that allows multi line editing straight from Shift+I after selecting multiple lines
# figure out optimal printer setup for linux (likely using CUPS)

install_package() {
    case $OS in
        Darwin*)
            brew install $@
            ;;
        Linux*)
            # running within linux
            # figure out what distro is being run (whether to use pacman -S, apt install, ...)
            pacman -Sy $@
            ;;
    esac
}

OS=$(uname)
echo "Currently running $OS"

# do some initial setup: install/update package manager
case "$(uname -s)" in
    Linux*)
        pacman -Syu
        install_package base-devel
        ;;
    Darwin*)
        if ! command -v brew &>/dev/null; then
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew update
        brew upgrade
        brew cleanup
        install_package python@3.13 coreutils

        #Enable key repeat in VSCode (why is this not allowed by default lol)
        # defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
        ;;
esac

install_package zsh neovim tmux curl wget gcc cmake 

install_package git stow make
if [ ! -d "$HOME/dotfiles" ]; then
    git clone --depth 1 "https://github.com/dennisfarmer/dotfiles.git" "$HOME/dotfiles"
fi
cd "$HOME/dotfiles"
stow --adopt .
git restore .
mkdir -p "$HOME/notes"

setup_ds() {
    if [ ! -d "${HOME}/miniforge3" ]; then
        # https://github.com/conda-forge/miniforge
        # curl -L -O
        # use -h to list the extra options
        wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
        bash Miniforge3.sh -b -f -p "${HOME}/miniforge3"
    fi
    install_package graphviz sqlite mysql eigen pyenv
}

setup_synth() {
    install_package faust chuck flac
    # brew link --overwrite chuck --dry-run
    # brew link --overwrite chuck
}


setup_ds
setup_synth

echo "----------------------------------------------------"
echo ""
awk -F',' '{ printf "%s - %s \n%s\n\n", $1, $2, $3 }' $HOME/dotfiles/programs.csv