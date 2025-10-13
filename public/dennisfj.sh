#!/bin/bash

#cat /etc/os-release  # for linux / WSL
#uname -srm  # for macbook
# uname -s

# This install script is meant to create a mostly reproducible setup on my unix-like operating systems.

# see if .anyconnect is the same format on linux as it is on macos (or if it even exists)

# brew cleanup


# TODO:
# - figure out a plugin for vim/nvim that allows multi line editing straight from Shift+I after selecting multiple lines
# figure out optimal printer setup for linux (likely using CUPS)

install_package() {
    case $OS in
        Darwin*)
            brew install $@
            ;;
        Linux*)
            pacman -Sy $@
            ;;
    esac
}

OS=$(uname)
echo "Currently running $OS"

case "$(uname -s)" in
    Linux*)
        # running within linux
        # figure out what distro is being run (whether to use pacman -S, apt install, ...)
        ;;
    Darwin*)
        # running on macbook
        # install homebrew, use brew install
        #Enable key repeat in VSCode (why is this not allowed by default lol)
        #`defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false`
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        install_package python@3.13 coreutils
        ;;
esac

install_package zsh neovim tmux curl gcc cmake 


setup_ds() {
    # https://github.com/conda-forge/miniforge
    # curl -L -O
    wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    # use -h to list the extra options
    bash Miniforge3.sh -b -f -p "${HOME}/miniforge3"
    install_package graphviz sqlite mysql eigen
}

setup_synth() {
    install_package faust chuck flac
}



setup_ds
setup_synth


