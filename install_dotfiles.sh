#!/bin/bash


#Homebrew
if ! which brew > /dev/null; then
	read -p "Homebrew is a package manager used for installing dependencies and is required for running the remainder of this script.  Continue and install Homebrew? [y/N] " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "Installing Homebrew\n....."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo -e "Exiting..."
    exit
  fi
else
	echo -e "Homebrew is already installed!"
fi


#pyenv
if ! which pyenv; then
	read -p "pyenv is a Python version manager.  Continue and install pyenv? [y/N] " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "Installing pyenv\n....."
    brew install pyenv
    echo -e "Setting zshrc configs for pyenv\n....."
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  else
    echo -e "Skipping installing pyenv\n..."
  fi
else
	echo -e "pyenv is already installed!"
fi


#Poetry
if ! which poetry; then
  read -p "Poetry is a dependency manager for Python.  Continue and install Poetry? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "Installing poetry\n....."
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
  else
    echo -e "Skipping installing poetry\n..."
  fi
else
  echo -e "Poetry is already installed!"
fi


#aliases
echo "" >> ~/.zshrc
echo "alias ll='ls -la'" >> ~/.zshrc
echo "alias su='sudo -i'" >> ~/.zshrc
echo "alias .="cd .."" >> ~/.zshrc
echo "alias ..="cd ../.."" >> ~/.zshrc
echo "alias ...="cd ../../.."" >> ~/.zshrc
