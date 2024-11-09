#!/bin/bash

# Script de instalación automatizada de Arch Linux
# Autor: Claude
# Uso: Ejecutar después de bootear el live USB/ISO de Arch Linux

# Colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para mostrar mensajes
show_message() {
    echo -e "${BLUE}==>${NC} ${1}"
}

# Función para verificar errores
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: ${1}${NC}"
        exit 1
    fi
}

# Verificar modo UEFI
if [ ! -d "/sys/firmware/efi/efivars" ]; then
    echo -e "${RED}Error: El sistema no está en modo UEFI${NC}"
    exit 1
fi

# Verificar conexión a internet
show_message "Verificando conexión a internet..."
ping -c 1 archlinux.org > /dev/null
check_error "No hay conexión a internet"

# Actualizar reloj del sistema
show_message "Actualizando reloj del sistema..."
timedatectl set-ntp true

# Particionar el disco
show_message "Particionando el disco..."
(
echo g # Crear nueva tabla GPT
echo n # Nueva partición (EFI)
echo 1 # Número de partición
echo   # Primer sector (default)
echo +512M # Tamaño
echo t # Cambiar tipo
echo 1 # EFI System
echo n # Nueva partición (swap)
echo 2 # Número de partición
echo   # Primer sector (default)
echo +2G # Tamaño
echo t # Cambiar tipo
echo 2 # Número de partición
echo 19 # Linux swap
echo n # Nueva partición (root)
echo 3 # Número de partición
echo   # Primer sector (default)
echo   # Último sector (resto del disco)
echo w # Escribir cambios
) | fdisk /dev/sda
check_error "Error al particionar el disco"

# Formatear particiones
show_message "Formateando particiones..."
mkfs.fat -F32 /dev/sda1
check_error "Error al formatear partición EFI"
mkswap /dev/sda2
check_error "Error al crear swap"
mkfs.ext4 /dev/sda3
check_error "Error al formatear partición root"

# Montar particiones
show_message "Montando particiones..."
mount /dev/sda3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
swapon /dev/sda2

# Instalar sistema base
show_message "Instalando sistema base..."
pacstrap /mnt base base-devel linux linux-firmware networkmanager grub efibootmgr xorg xorg-server xfce4 xfce4-goodies lightdm lightdm-gtk-greeter firefox nano sudo git virtualbox-guest-utils
check_error "Error al instalar paquetes base"

# Generar fstab
show_message "Generando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
check_error "Error al generar fstab"

# Configurar sistema
show_message "Configurando sistema..."
arch-chroot /mnt /bin/bash << EOF
# Configurar zona horaria
ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc

# Configurar idioma
echo "es_AR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=es_AR.UTF-8" > /etc/locale.conf

# Configurar hostname
echo "archlinux" > /etc/hostname

# Configurar hosts
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /etc/hosts

# Configurar GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Habilitar servicios
systemctl enable NetworkManager
systemctl enable lightdm
systemctl enable vboxservice

# Crear usuario MakuSensei
useradd -m -G wheel -s /bin/bash MakuSensei
echo "MakuSensei:fate2020" | chpasswd
echo "root:fate2020" | chpasswd

# Configurar sudo
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel

# Habilitar multilib
echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Actualizar sistema
pacman -Sy

# Instalar yay
sudo -u MakuSensei bash << EEOF
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
EEOF

EOF

# Desmontando particiones
show_message "Desmontando particiones..."
umount -R /mnt

show_message "¡Instalación completada! Puedes reiniciar el sistema."