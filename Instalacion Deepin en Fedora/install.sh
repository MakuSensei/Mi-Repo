#! /bin/bash
echo "Instalacion Deepin en Fedora"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf copr enable mosquito/deepin
sudo dnf install startdde deepin-wm deepin-wm-switcher deepin-control-center deepin-daemon deepin-desktop deepin-dock deepin-file-manager deepin-launcher deepin-session-ui deepin-desktop-base deepin-desktop-schemas deepin-gtk-theme deepin-icon-theme deepin-qt5integration gnome-icon-theme-symbolic deepin-image-viewer deepin-movie deepin-music deepin-screen-recoder deepin-calendar deepin-menu deepin-metacity deepin-mutter deepin-nautilus-properties deepin-notifications deepin-screenshot deepin-shortcut-viewer deepin-sound-theme deepin-wallpapers dnfdragora lightdm
# Si ya disponen de LightDM instalado no hace falta realizar el siguiente comando, solo en caso de disponer otro gestor (ejemplo gdm lo desabilitan y habilitan lightDM)
#sudo systemctl disable gdm.service && sudo systemctl enable lightdm.service
sudo sed -e "s/SELINUX=enforcing/SELINUX=disabled/g" -i /etc/selinux/config
sudo su -c "echo -e '[Seat:*]\ngreeter-session=lightdm-deepin-greeter' > /etc/lightdm/lightdm.conf.d/deepin.conf"
exit
