#!/bin/bash

#cat /etc/os-release  # for linux / WSL
#uname -srm  # for macbook
# uname -s

# This install script is meant to create a mostly reproducible setup on my unix-like operating systems.

# see if .anyconnect is the same format on linux as it is on macos (or if it even exists)


# TODO:
# - figure out a plugin for vim/nvim that allows multi line editing straight from Shift+I after selecting multiple lines
# figure out optimal printer setup for linux (likely using CUPS)

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

        ;;
esac

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

install_package nvim
