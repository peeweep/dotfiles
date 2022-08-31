#!/usr/bin/env bash

pacman_archlinuxcn() {
  {
    echo "[archlinuxcn]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch"
    echo "Server = https://repo.archlinuxcn.org/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu --noconfirm --needed archlinuxcn-keyring
  echo "[✔]archlinuxcn-keyring installed"
}

pacman_peeweep() {
  {
    echo "[peeweep]"
    echo "SigLevel = Never"
    echo "Server = https://repo.daydream.ac.cn/archlinux/x86_64"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu --noconfirm --needed curl
  curl https://daydream.ac.cn/pubring.gpg | sudo pacman-key -a -
  sudo pacman-key --lsign-key A4A9C04411BE1F71
  sudo pacman -Syu --noconfirm
  echo "[✔]peeweep repo installed"
}

pacman_ck() {
  {
    echo "[repo-ck]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.bfsu.edu.cn/repo-ck/\$arch"
    echo "Server = http://repo-ck.com/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman-key -r 5EE46C4C --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 5EE46C4C
  sudo pacman -Syu --noconfirm
}

linux_ck() {
  sudo pacman -Syu --noconfirm --needed $(/lib/ld-linux-x86-64.so.2 --help | grep supported | awk '{print $1}' | sort -n | tail -1 | sed 's|x86_64|ck-generic|')
}

pacman_unofficial_packages() {
  sudo pacman -Syu --noconfirm
  # kernel-modules-hook
  sudo pacman --sync --noconfirm --needed kernel-modules-hook
  sudo systemctl enable linux-modules-cleanup

  # install kernel
  if [[ $(sudo dmidecode -s bios-vendor) == "Apple Inc." ]]; then
    sudo pacman --sync --noconfirm --needed linux-macbook linux-macbook-headers
    sudo pacman --sync --noconfirm --needed xorg-xrandr upower tlp-rdw broadcom-wl-dkms
    sudo systemctl enable macbook-wakeup.service
    sudo systemctl enable tlp.service tlp-sleep.service
    sudo sed -i 's/blacklist brcmfmac/\#blacklist brcmfmac/g' \
      /usr/lib/modprobe.d/broadcom-wl-dkms.conf
  else
    pacman_ck
    linux_ck
  fi

  # install unofficial packages
  sudo pacman --sync --noconfirm --needed fcitx5-git fcitx5-gtk-git \
    fcitx5-material-color fcitx5-pinyin-moegirl-rime fcitx5-qt5-git \
    fcitx5-rime-git firefox-nightly-en-us nerd-fonts-complete supersm-git

  # install gpu driver
  gpu_model=$(lspci -mm | awk -F '\"|\" \"|\\(' '/"Display|"3D|"VGA/')
  if echo "${gpu_model}" | grep NVIDIA; then
    sudo pacman --sync --noconfirm --needed nvidia-dkms
  fi
  if echo "${gpu_model}" | grep Intel; then
    # I'm not clear intel device
    sudo pacman --sync --noconfirm --needed mesa xf86-video-intel
  fi

  # ath10k QCA6174 driver
  if [[ -n $(lspci | grep "Qualcomm Atheros QCA6174 802.11ac Wireless Network Adapter") ]]; then
    sudo supersm ath10k -T /
  fi

  sudo pacman -Rs nvidia
  sudo pacman -Rs linux
  sudo pacman -Rs linux-headers
  sudo pacman -Rs nvidia-lts
  sudo pacman -Rs linux-lts
  sudo pacman -Rs linux-lts-headers

  # rebuild grub
  sudo pacman --sync --noconfirm --needed grub efibootmgr os-prober ntfs-3g
  sudo grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

pacman_official_packages() {
  sudo pacman -Syu --noconfirm --needed alsa-utils autopep8 bind-tools dmidecode \
    flameshot htop linux-firmware lshw man mpv neovim networkmanager net-tools \
    noto-fonts-cjk noto-fonts-emoji noto-fonts-extra p7zip pacman-contrib \
    pavucontrol pkgfile pulseaudio python-pylint ripgrep shfmt telegram-desktop \
    tmux ttf-opensans unrar uptimed wget whois zstd gist freerdp

  # bluetooth
  if [[ -n $(sudo lshw | grep -i Bluetooth) ]]; then
    sudo pacman --sync --noconfirm --needed bluez-utils pulseaudio-bluetooth blueman
    sudo systemctl enable bluetooth.service
  fi

  # systemd
  sudo systemctl enable pkgfile-update.timer
  sudo systemctl enable NetworkManager
}

pacman_haveged() {
  # kernel buildin since linux 5.5
  sudo pacman -Syu --noconfirm --needed haveged
  sudo systemctl enable haveged
}

pacman_mirrorlist() {
  sudo cp "${dotfiles}"/devtools/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
}

pacman_init() {
  # pacman_haveged
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

zsh_init() {
  sudo pacman --sync --noconfirm --needed zsh
  supersm zsh
}

vim_init() {
  sudo pacman --sync --noconfirm --needed neovim vim neovim-qt xclip \
    python-lsp-server python-pynvim npm nodejs-neovim clang gopls \
    rust-analyzer rust gotags
  supersm nvim nodejs
}

latex_init(){
  sudo pacman --sync --noconfirm --needed texlab texlive-most texlive-lang
  # xelatex example.tex
}

kitty_scheme() {
  sudo pacman --sync --noconfirm --needed kitty
  supersm kitty
}

pbuilder_init() {
  sudo pacman --sync --noconfirm --needed pbuilder libeatmydata pigz qemu-debootstrap
  sudo supersm pbuilder -T /
}

dotfiles="$HOME/.dotfiles"
git clone https://github.com/peeweep/dotfiles "${dotfiles}"
cd "${dotfiles}" || exit
pacman_init
fcitx5_init
zsh_init
vim_init
kitty_scheme

case $1 in
gnome)
  sudo pacman --sync --noconfirm --needed gnome evolution gnome-tweaks lightdm
  sudo systemctl enable lightdm
  ;;
*)
  sudo pacman --sync --noconfirm --needed i3-gaps i3status numlockx feh rofi xorg-xrdb lightdm lightdm-gtk-greeter xorg-server
  sudo systemctl enable lightdm
  supersm i3
  ;;
esac

#### begin symlink update
# clang
supersm clang
# git
supersm git
# makepkg and pacman
sudo supersm devtools --target /
