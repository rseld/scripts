#!/usr/bin/env bash

rsync -av ~/.bashrc ~/.dotfiles
rsync -av ~/.inputrc ~/.dotfiles
rsync -av ~/.Xresources ~/.dotfiles
rsync -av ~/.xinitrc ~/.dotfiles
rsync -av ~/.config/tmux ~/.dotfiles
