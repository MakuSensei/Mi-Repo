#! /bin/bash
echo Remover archivo
sleep 1
sudo rm /etc/fonts/local.conf
sleep 1
echo restaurar archivo de escalado mapa de bit
sleep 1
sudo cp /etc/fonts/conf.d/10-scale-bitmap-fonts.conf.bak /etc/fonts/conf.d/10-scale-bitmap-fonts.conf
sleep 1
echo Resetear configuraciones de fuentes
sleep 1
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf 
sudo rm /etc/fonts/conf.d/10-sub-pixel-rgb.conf
sudo rm /etc/fonts/conf.d/11-lcdfilter-default.conf
sleep 1
sudo sed -i "/export/s/^/#/" /etc/profile.d/freetype2.sh
sleep 1
gsettings reset org.gnome.settings-daemon.plugins.xsettings hinting
gsettings reset org.gnome.settings-daemon.plugins.xsettings antialiasing
exit
