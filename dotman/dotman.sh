#!/usr/bin/env bash

rsync -av ~/.bashrc ~/.dotfiles
rsync -av ~/.inputrc ~/.dotfiles
rsync -av ~/.xinitrc ~/.dotfiles
rsync -av ~/.Xresources ~/.dotfiles
rsync -av ~/.config/i3 ~/.dotfiles
rsync -av ~/.config/i3status ~/.dotfiles
rsync -av ~/.config/tmux ~/.dotfiles
rsync -av ~/.config/ghostty ~/.dotfiles
