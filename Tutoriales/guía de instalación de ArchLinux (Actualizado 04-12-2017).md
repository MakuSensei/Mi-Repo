**Guía básica de instalación Archlinux**

Descargar iso [https://www.archlinux.org/download/](https://www.archlinux.org/download/)

**Configurar teclado en Español**

    loadkeys la-latin1 (Teclado Español Latino)

    loadkeys es (Teclado español)

**Creando particiones**

    usar: cfdisk

**Formatear particiones**

    Raíz: mkfs -t ext4 /dev/sdaX
    Swap: swapon /dev/sdaX

En caso de salir el error: “read swap header failed” Usar mkswap y después volver a usar swapon (este error sale cuando se crea una nueva partición desde cero para la swap, en caso de ya disponerla no nos dará este error al formatearla)

**Montar: Acá montaran las particiones necesarias**

    mount /dev/sdaX /mnt

**Conectar wifi: (solo si dispones conexión por este medio)**

    wifi-menu

**Configurar repos con Rankmirrors (Opcional 1) Esto va a durar por buen rato asi que sean pacientes**

    cd /etc/pacman.d
    cp mirrorlist mirrorlist.backup
    sed ‘/^#\S/ s|#||’ -i mirrorlist.backup (Opcional)
    rankmirrors -n 6 mirrorlist.backup > mirrorlist

**Configurar repos con Reflector (Opcional 2) Esto va a durar por buen rato asi que sean pacientes**

    sudo pacman -S reflector

    cd /etc/pacman.d

Cambiar el 10 por el numero de mirrors que deseen
reflector –verbose -l 10 –sort rate –save /etc/pacman.d/mirrorlist
Mas info [Reflector](https://wiki.archlinux.org/index.php/Reflector_%28Espa%C3%B1ol%29)

**Instalación:**

    pacstrap /mnt base base-devel
    pacstrap /mnt netctl wpa_supplicant dialog
    pacstrap /mnt networkmanager

`pacstrap /mnt xf86-input-synaptics` **(instalar en caso de disponer touchpad)**

Gestor de arranque GRUB (como opcional os-prober si disponen de otros sistemas operativos y ntfs-3g para poder tener acceso de escritura en particiones ntfs)

    pacstrap /mnt grub-bios os-prober ntfs-3g

**Configurando el Sistema**

    genfstab -p /mnt >> /mnt/etc/fstab
    arch-chroot /mnt

**Configurar localhost:**

    nano /etc/hostname

**Configurar Zona/Región**

(Buscar la configuración correcta para tu Región)

**Argentina**: `ln -sf /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime`

**Configurar Localización**

(Buscar la configuración correcta para tu localización)

    nano /etc/locale.conf y agregar LANG=es_AR.UTF-8

`nano /etc/locale.gen` y descomentar es_AR.UTF-8 UTF-8 y es_AR ISO-8859-1

**Generar localización con:**

    locale-gen

**Distribución del teclado:**

    nano /etc/vconsole.conf

**Agregar la siguiente linea**

    “KEYMAP=la-latin1” o “KEYMAP=es”

**Instalar y configurar grub**

    grub-install /dev/sda

    grub-mkconfig -o /boot/grub/grub.cfg

    mkinitcpio -p linux

**Poner clave a la cuenta root y crear nuevo usuario**

    passwd (para el root)

**Crear usuario** (Dependiendo de las necesidades elegir una de las opciones)

**Opción 1:** `useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash USUARIO`
**Opcion 2:** `useradd -m -g users -G wheel -s /bin/bash USUARIO`

`passwd USUARIO` (para el usuario)

**Privilegios Sudo al usuario**

    nano /etc/sudoers

**“User privilege specification”**

(en esta línea agregar debajo de root nuestro usuario)

    root ALL=(ALL) ALL
    USUARIO ALL=(ALL) ALL

 

**Habilitar servicio de red**

    sudo systemctl enable NetworkManager

    sudo systemctl start NetworkManager

**Instalar Xorg, Drivers de video, Soporte 3D**

    sudo pacman -S xorg-server xorg-xinit mesa mesa-demos

**Drivers de video: instalar el que corresponda**

**Intel**

    sudo pacman -S xf86-video-intel

**Nvidia**

**Drivers propietarios:** `sudo pacman -S nvidia nvidia-utils`
**Drivers de código abierto:** `sudo pacman -S xf86-video-nouveau`

**ATI**

    sudo pacman -S xf86-video-ati

**Lista completa de drivers de vídeo de código abierto:**

    sudo pacman -Ss xf86-video

**Video Genérico:**

    sudo pacman -S xf86-video-vesa

**Instalación del escritorio**

**Para instalar Gnome:**

    Sudo pacman -S gnome gnome-extra gnome-shell gdm network-manager-applet

**Habilitar su gestor de inicio “GDM”**

    sudo systemctl enable gdm.service

**Para instalar Kde Plasma:** Para crear las carpetas de usuario leer la wiki de [archlinux XDG_user_directories](https://wiki.archlinux.org/index.php/XDG_user_directories)

    pacman -S kf5 plasma-desktop sddm

**Habilitar su gestor de inicio “SDDM”**

    sudo systemctl enable sddm

**Para instalar con MATE**

    sudo pacman -S mate mate-extra

**Habilitar gestor de inicio LightDM (Se requiere una determinada configuración para funcionar adecuadamente)**

    sudo pacman lightdm lightdm-gtk-greeter

    sudo systemctl enable lightdm.service

**Ir a la sección de “configurar lightDM” mas abajo**

**Para instalar Xfce**

    sudo pacman -S xfce4 xfce4-goodies alsa-utils pavucontrol pulseaudio-alsa

**Habilitar gestor de inicio LightDM (Se requiere una determinada configuración para funcionar adecuadamente)**

    sudo pacman lightdm lightdm-gtk-greeter

    sudo systemctl enable lightdm.service

**Ir a la sección de “configurar lightDM” mas abajo**

**Para instalar Deepin Desktop**

    sudo pacman -S –force deepin deepin-extra

    sudo systemctl enable lightdm.service

Deepin requiere el gestor de inicio lightDM asi que mas abajo pondre detalladamente que modificar

**Salir del Arch-chroot**

    Exit

**Desmontar particiones y reiniciar**

    umount /mnt/

    reboot

 

Para otros escritorios revisar la wiki de [archlinux](https://wiki.archlinux.org/index.php/Category:Desktop_environments)

**Post instalación (Opcionales)**
-----------------------------

**Instalar los paquetes para usar AUR**

**Descargar y compilar**

https://aur.archlinux.org/packages/package-query/
https://aur.archlinux.org/packages/yaourt/

**Compilar con**

    Makepkg -s

**Instalar con**

    pacman -U

**Instalar ZSH como intérprete de comandos BASH**

    sudo pacman -S zsh

`chsh -l` (Este comando nos listará todas las shell para la terminal que disponemos)

    chsh -s /bin/zsh

`zsh /usr/share/zsh/functions/Newuser/zsh-newuser-install -f` (si no sabes que opciones seguir dale a la “q” para salir)
Instalar y configurar oh my zsh (temas y plugins para ZSH)

**yaourt -S oh-my-zsh-git**

Ejecutar

    /usr/share/oh-my-zsh/tools/install.sh

Editar ~/.zshrc para cambiar de temas y agregar plugins (podes revisar los temas y plugins disponibles en tu home “/home/usuario/.oh-my-zsh/”)
Instalar fuentes para ZSH

`yaourt -S powerline-fonts-git` (en la terminal recomiendo la fuente: Ubuntu Mono derivative Powerline)

**Configurar GRUB para que recuerde el último sistema usado**

**Hacer Copia de seguridad del archivo grub**

    sudo cp /etc/default/grub ~/grub.old

**Modificar la configuración del Grub**

    sudo nano /etc/default/grub

buscar la siguiente línea: **“GRUB_DEFAULT=0”** reemplazar “0” por “saved”
Descomentar la línea **“GRUB_SAVEDEFAULT=true”**
**Guardar cambios**
Cargar la nueva configuración al gestor de arranque GRUB

    sudo grub-mkconfig -o /boot/grub/grub.cfg

**Configurar lightDM**

Luego de haber instalado este gestor de inicio y su tema correspondiente. es necesario realizar esta configuración para que funcione adecuadamente y no nos de una pantalla negra en el login

editar el archvo lightdm.conf **“nano /etc/lightdm/lightdm.conf”**
buscar la linea **“#greeter-session=example-gtk-gnome”**
Descomentar y reemplazar **“example-gtk-gnome”** por el tema correspondiente, en este caso para DEs GTK lo ideal es usar **“lightdm-gtk-greeter”**

Para deepin se requiere la siguiente configuración
editar el archivo lightdm.conf **“nano /etc/lightdm/lightdm.conf”**
buscar la linea **“#greeter-session=example-gtk-gnome”**
Descomentar y reemplazar **“example-gtk-gnome”** por el tema correspondiente para deepin **“lightdm-deepin-greeter”**
