#! /bin/bash
echo descargar archivo y copiar archivo en el directorio correspondiente
sleep 1
cd /etc/fonts/
wget https://raw.githubusercontent.com/MakuSensei/Mi-Repo/master/Rende-rizado%20de%20fuentes/etc/fonts/local.conf
sleep 1
echo respaldar y eliminar el escalado mapas de bit
sleep 1
sudo cp /etc/fonts/conf.d/10-scale-bitmap-fonts.conf /etc/fonts/conf.d/10-scale-bitmap-fonts.conf.bak
sudo rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf
sleep 1
echo aplicar configuraciones de renderizado
sleep 2
sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sleep 1
sudo sed -i "/export/s/^#//" /etc/profile.d/freetype2.sh
sleep 1
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting "slight"
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing "rgba"
sleep 1
exit
