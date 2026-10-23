#!/bin/bash

if (($UID > 0)); then
  echo "Run as superuser."
  exit 1
fi

while [[ $ans != [YyNn] ]]; do
  read -r -p "Install? [y/n] " ans
done

if [[ $ans == [Nn] ]]; then
  exit 0
fi

cd "$(dirname "$0")" || exit 1

if [ -d /etc/zsh ] && [ ! -d /etc/zsh/environment ]; then
  if [ -d /etc/zsh.bak ]; then
    echo "Stopping because there is already a /etc/zsh.bak folder."
    exit 1
  fi
  mv /etc/zsh /etc/zsh.bak || exit 1
fi

cp -r root/. / || exit 1

rsync -a --delete --chown=root:root root/etc/zsh/environment/ /etc/zsh/environment/ || exit 1

echo "Done"
