#!/bin/env sh
echo Installing dependencies...
sudo dnf install -y \
	git-all \
	python-virtualenv \
	python3-virtualenv \
	ag \
	python-jedi \
	python3-jedi \
	${NULL}

echo Setting up python venv
pyenv3=$(rpm -ql python3-virtualenv | grep /usr/bin/virtualenv-)
pyenv2=$(rpm -ql python-virtualenv | grep /usr/bin/virtualenv-)

pushd ~/.config/nvim
$pyenv3 pyenv3
pyenv3/bin/pip install --upgrade neovim
$pyenv2 pyenv2
pyenv2/bin/pip install --upgrade neovim
popd
