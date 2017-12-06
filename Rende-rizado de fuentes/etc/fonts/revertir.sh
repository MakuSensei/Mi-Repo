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
gsettings reset org.gnome.settings-daemon.plugins.xsettings hinting
gsettings reset org.gnome.settings-daemon.plugins.xsettings antialiasing
exit
