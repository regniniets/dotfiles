#! /bin/sh

#cleanup
sudo dnf remove -y \
  abrt @"KDE Multimedia support" kaccounts-integration kde-connect kmahjongg kmines konversation kpat krfb akregator kf5-akonadi-server kmail kmouth konqueror kwrite plasma-discover plasma-drkonqi plasma-pk-updates

#prepare repos, update
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update -y
sudo dnf groupupdate core -y

#install usual stuff
sudo dnf install -y \
  okular kate okteta yakuake plasma-workspace-wallpapers fedora-workstation-backgrounds \
  chromium firefox keepassxc vlc syncthing \
  zsh git-core tig tmux nmon neovim tmux htop atool bat fzf fd-find ripgrep yank ffmpeg youtube-dl nethogs nmap powertop tlp ranger nnn borgbackup flatpak \
  jq tokei httpie chafa docker docker-compose lazydocker java-11-openjdk-devel
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  
sudo flatpak install -y com.spotify.Client

sudo systemctl disable --now docker

