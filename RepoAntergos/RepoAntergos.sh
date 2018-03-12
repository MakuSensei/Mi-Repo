#! /bin/bash 
echo Agregar Repositorio Antergos en Archlinux y derivadas
sleep 1
wget https://github.com/Antergos/antergos-packages/raw/master/antergos/antergos-keyring/.SRCINFO
sleep 1
wget https://raw.githubusercontent.com/Antergos/antergos-packages/master/antergos/antergos-keyring/PKGBUILD
sleep 1
wget https://raw.githubusercontent.com/Antergos/antergos-packages/master/antergos/antergos-keyring/antergos-keyring.install
sleep 1
makepkg -i -s
sleep 1
echo Bye Bye, Script creado por @MakuSensei
sleep 2
exit
