#!/bin/bash

#Determine which shell
SHELL=$(which $SHELL)
if [[ $SHELL == "/bin/bash" ]]; then
  SHELL=bash
fi
if [[ $SHELL == "/bin/zsh" ]]; then
  SHELL=zsh
fi

echo -e "Your shell is $SHELL!"

#Function for installing packages
installPackage()
{
  read -p "$2 Continue and install $1? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if ! which "$1"; then
      echo -e "Installing $1\n....."
      eval $3
    else
      echo -e "$1 is already installed!"
    fi
  else
    echo -e "Skipping installing $1\n..."
  fi
}

#Function for installing aliases
installAliases()
{
echo -e "$1 contains the following commands :\n"
cat $1
echo -e "\n"
read -p "Continue and apply these aliases? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CURRENT_ALIASES=$(<~/.${SHELL}rc)
  while read alias; do
    if echo "$CURRENT_ALIASES" | grep -q "$alias"; then
      echo "The following alias already exists, skipping.....  $alias"
    else
      echo "This following doesn't exist, adding.....  $alias"
      echo "$alias">> ~/.${SHELL}rc
    fi
  done < $1
else
  echo -e "Skipping applying $1\n..."
fi
}

#Homebrew
brewINSTALL='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
installPackage "brew" "Homebrew is a package manager used for installing dependencies and is required for running the remainder of this script." $brewINSTALL

#pyenv
pyenvINSTALL="brew install pyenv"
installPackage "pyenv" "pyenv is a Python version manager." $pyenvINSTALL
installAliases pyenv_aliases.sh

#Poetry
poetryINSTALL="curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -"
installPackage "poetry" "Poetry is a dependency manager for Python." $poetryINSTALL

#aliases
echo "alias ${SHELL}rc='vim ~/.${SHELL}rc'" >> ~/.${SHELL}rc
echo "alias reload=source ~/.${SHELL}rc" >> ~/.${SHELL}rc

installAliases common_aliases.sh

echo -e "\n\n\nAll installations complete!!!"
