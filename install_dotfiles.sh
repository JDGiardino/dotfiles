#!/bin/bash


#Determine which shell
SHELL=$(which $SHELL)
if [[ $SHELL == "/bin/bash" ]]; then
  SHELL=bash
fi
if [[ $SHELL == "/bin/zsh" ]]; then
  SHELL=zsh
fi

echo -e "Your shell is $SHELL"


#Homebrew
if ! which brew; then
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
    echo -e "Setting ${SHELL}rc configs for pyenv\n....."
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.${SHELL}rc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.${SHELL}rc
    echo 'eval "$(pyenv init -)"' >> ~/.${SHELL}rc
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
echo "alias ${SHELL}rc='vim ~/.${SHELL}rc'" >> ~/.${SHELL}rc
echo "alias reload=source ~/.${SHELL}rc" >> ~/.${SHELL}rc
while read alias; do
  echo "$alias">> ~/.${SHELL}rc
done < aliases.sh


#installPackage()
#{
#  if ! which $1; then
#    read -p "$2 Continue and install $1? [y/N] " response
#    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
#      echo -e "Installing $1\n....."
#      $3
#    else
#      echo -e "Skipping installing $1\n..."
#    fi
#  else
#    echo -e "$1 is already installed!"
#  fi
#}
#
#brewINSTALL=$(brew install pyenv)
#installPackage brew test_string brewINSTALL