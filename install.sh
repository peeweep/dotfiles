#!/usr/bin/env bash

pacman_archlinuxcn() {
  {
    echo "[archlinuxcn]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch"
    echo "Server = https://repo.archlinuxcn.org/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu archlinuxcn-keyring
  echo "[✔]archlinuxcn-keyring installed"
}

pacman_peeweep() {
  {
    echo "[peeweep]"
    echo "SigLevel = Never"
    echo "Server = https://repo.peeweep.de/archlinux/x86_64"
    echo "Server = https://peeweep.duckdns.org/archlinux/x86_64"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu --needed curl
  curl https://peeweep.de/pubring.gpg | sudo pacman-key -a -
  sudo pacman-key --lsign-key A4A9C04411BE1F71
  sudo pacman -Syu
  echo "[✔]peeweep repo installed"
}

pacman_ck() {
  {
    echo "[repo-ck]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.bfsu.edu.cn/repo-ck/\$arch"
    echo "Server = http://repo-ck.com/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman-key -r 5EE46C4C && sudo pacman-key --lsign-key 5EE46C4C
  sudo pacman -Syu
}

linux_ck() {
  march=$(gcc -c -Q -march=native --help=target -o /dev/null | grep march | awk '{print $2}' | head -n1)
  case "${march}" in
  bonnell)
    group="ck-atom"
    ;;
  silvermont)
    group="ck-silvermont"
    ;;
  core2)
    group="ck-core2"
    ;;
  nehalem)
    group="ck-nehalem"
    ;;
  sandybridge)
    group="ck-sandybridge"
    ;;
  ivybridge)
    group="ck-ivybridge"
    ;;
  haswell)
    group="ck-haswell"
    ;;
  broadwell)
    group="ck-broadwell"
    ;;
  skylake)
    group="ck-skylake"
    ;;
  pentium4 | prescott | nocona)
    group="ck-p4"
    ;;
  pentm | pentium-m)
    group="ck-pentm"
    ;;
  athlon | athlon-4 | athlon-tbird | athlon-mp | k8-sse3)
    group="ck-kx"
    ;;
  amdfam10)
    group="ck-k10"
    ;;
  btver1)
    group="ck-bobcat"
    ;;
  bdver1)
    group="ck-bulldozer"
    ;;
  bdver2)
    group="ck-piledriver"
    ;;
  znver1)
    group="ck-zen"
    ;;
  *)
    group="ck-generic"
    ;;
  esac

  sudo pacman -Syu ${group}
}

pacman_unofficial_packages() {
  # kernel-modules-hook
  sudo pacman -Syu --needed kernel-modules-hook
  sudo systemctl enable linux-modules-cleanup

  # install kernel
  if [[ $(sudo dmidecode -s bios-vendor) == "Apple Inc." ]]; then
    sudo pacman --sync --needed linux-macbook linux-macbook-headers
    sudo pacman --sync --needed xorg-xrandr upower tlp-rdw broadcom-wl-dkms
    sudo systemctl enable macbook-wakeup.service
    sudo systemctl enable tlp.service tlp-sleep.service
    sudo sed -i 's/blacklist brcmfmac/\#blacklist brcmfmac/g' \
      /usr/lib/modprobe.d/broadcom-wl-dkms.conf
  else
    pacman_ck
    linux_ck
  fi

  # install unofficial packages
  sudo pacman -Syu --needed fcitx5-chinese-addons-git fcitx5-gtk-git p7zip-zstd-codec \
    nerd-fonts-complete supersm-git visual-studio-code-bin unzip-iconv

  # install gpu driver
  gpu_model=$(lspci -mm | awk -F '\"|\" \"|\\(' '/"Display|"3D|"VGA/')
  if echo "${gpu_model}" | grep NVIDIA; then
    sudo pacman --sync --needed nvidia-dkms
  fi
  if echo "${gpu_model}" | grep Intel; then
    # I'm not clear intel device
    sudo pacman --sync --needed mesa xf86-video-intel
  fi

  sudo pacman -Rs nvidia
  sudo pacman -Rs linux
  sudo pacman -Rs linux-headers
  sudo pacman -Rs nvidia-lts
  sudo pacman -Rs linux-lts
  sudo pacman -Rs linux-lts-headers

  # rebuild grub
  sudo pacman -Syu --needed grub efibootmgr os-prober ntfs-3g
  sudo grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

pacman_official_packages() {
  sudo pacman -Syu --needed alsa-utils autopep8 axel bind-tools chromium cloc cmake dmidecode \
    exfat-utils flameshot gdb htop jdk-openjdk jq jre-openjdk linux-firmware lldb man mpv ncdu \
    neofetch neovim net-tools noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    p7zip pacman-contrib pavucontrol pkgfile pkgstats pulseaudio python-pylint screen \
    screenfetch shellcheck shfmt telegram-desktop tldr tmux tree ttf-opensans unrar \
    uptimed wget whois youtube-dl zstd networkmanager

  # systemd
  sudo systemctl enable pkgfile-update.timer
  sudo systemctl enable NetworkManager
}

pacman_haveged() {
  sudo pacman -Syu --needed haveged
  sudo systemctl enable haveged
}

pacman_mirrorlist() {
  sudo cp "${dotfiles}"/pacman/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
}

pacman_init() {
  pacman_haveged
  pacman_mirrorlist
  # add unofficial repo
  pacman_archlinuxcn
  pacman_peeweep
  # install packages
  pacman_official_packages
  pacman_unofficial_packages
}

fcitx5_init() {
  supersm fcitx5
}

omz_init() {
  sudo mkdir -p /usr/share/fonts/OTF/
  sudo pacman --sync --needed zsh zsh-autosuggestions oh-my-zsh-git
  supersm zsh
}

sound_panel() {
  sudo pacman --sync --needed pulseaudio xfce4-pulseaudio-plugin xfce4-panel pavucontrol
  echo "xfce4 volume panel installed"
}

xfceterminal_scheme() {
  sudo pacman --sync --needed xfce4-terminal
  supersm xfce4-terminal
}

add_konsole_scheme() {
  sudo pacman --sync --needed konsole
  sudo supersm konsole --target /
}

vim_init() {
  sudo pacman --sync --needed vim-plug-git neovim vim neovim-qt xclip
  sudo pacman --sync --needed python-language-server python-pynvim
  sudo pacman --sync --needed npm nodejs-neovim
  sudo pacman --sync --needed clang
  supersm nvim
  nvim -c :PlugInstall
}

desktop_session() {
  case "${XDG_CURRENT_DESKTOP}" in
  KDE)
    add_konsole_scheme
    ;;
  XFCE)
    sound_panel
    xfceterminal_scheme
    ;;
  esac
  omz_init
  vim_init
}

i3gaps() {
  sudo pacman --sync --needed i3-gaps i3status-rust-git picom numlockx feh rofi xorg-xrdb sddm
  sudo systemctl enable sddm
  supersm i3
  xfceterminal_scheme
}

dotfiles="$HOME/.dotfiles"
git clone https://github.com/peeweep/dotfiles "${dotfiles}"
cd "${dotfiles}" || exit
pacman_init
fcitx5_init
desktop_session

case $1 in
gnome)
  sudo pacman --sync --needed gnome evolution gnome-tweaks sddm
  sudo systemctl enable sddm
  ;;
*)
  i3gaps
  ;;
esac

#### begin symlink update
# clang
supersm clang
# git
supersm git
# makepkg and pacman
sudo supersm devtools --target /
# mutt
sudo pacman --sync --needed neomutt neovim msmtp offlineimap
supersm mutt
