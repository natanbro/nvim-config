#!/bin/env sh
echo Installing dependencies...
sudo dnf install -y \
	git-all \
	python-virtualenv \
	python3-virtualenv \
	ag \
	xsel \
	python-jedi \
	python3-jedi \
	${NULL}

echo Setting up python venv

mkdir -p ~/.config/nvim/

pushd ~/.config/nvim
virtualenv-3 ./pyenv3
pyenv3/bin/pip install --upgrade neovim
virtualenv-2 ./pyenv2
pyenv2/bin/pip install --upgrade neovim
popd

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
