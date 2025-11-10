{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  console.keyMap = "br-abnt2";
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  boot.kernelParams = [
    "transparent_hugepage=always" # Better memory management
  ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;
  };

  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [intel-media-driver intel-vaapi-driver];
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  users.users.nix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = ["networkmanager" "wheel"];
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  networking.networkmanager.enable = true;
  programs.kdeconnect.enable = true;
  networking.firewall = {
    enable = false;
    # KDE Connect
    allowedTCPPortRanges.to = 1714;
    allowedTCPPortRanges.from = 1764;
    allowedUDPPortRanges.to = 1714;
    allowedUDPPortRanges.from = 1764;
  };
  # USB Connection
  services.gvfs.enable = true;
  programs.adb.enable = true;
  services.udisks2.enable = true;
  # Audio
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  #
  services.displayManager.gdm.enable = true;
  services.displayManager.sessionPackages = [pkgs.niri];
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  programs.firefox.enable = true;
  services.printing.enable = true;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-wlr];
    configPackages = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-wlr];
  };
  services = {
    syncthing = {
      enable = true;
      group = "wheel";
      user = "nix";
      dataDir = "/home/nix/Documents";
      configDir = "/home/nix/.config/syncthing";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.nix-ld.enable = true;

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    # build
    cmake
    gnumake
    ninja
    binutils
    bun
    #
    uv
    python314
    git
    neovim
    kitty
    wl-clipboard
    killall
    fzf
    ripgrep
    sd
    fd
    eza
    zoxide
    dua
    networkmanagerapplet
    vdhcoapp
    sqlitestudio
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    nautilus
  ];

  environment = {
    shellInit = ''export PATH="${pkgs.gcc}/bin:$PATH" '';
    sessionVariables = {LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc pkgs.zlib pkgs.nodejs pkgs.libtool];};
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.iosevka
      nerd-fonts.noto
      noto-fonts-cjk-sans
      noto-fonts-monochrome-emoji
      noto-fonts-color-emoji
      open-dyslexic
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
        monospace = ["Iosevka Nerd Font"];
      };
    };
  };
}
