{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  system.stateVersion = "26.05";
  # ===== BOOT CONFIGURATION =====

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "systemd.show_status=auto"
      "transparent_hugepage=always"
      "amd_pstate=guided"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
  };

  # ===== HARDWARE CONFIGURATION =====

  hardware = {
    firmware = [pkgs.linux-firmware];
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    graphics.enable = true;
    graphics.enable32Bit = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  services.fstrim.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
  };

  # ===== NETWORKING =====
  networking = {
    nameservers = ["1.1.1.1" "8.8.8.8"];
    stevenblack = {
      enable = true;
      block = ["fakenews" "gambling" "porn" "social"];
    };
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = false;
      allowedTCPPortRanges.to = 1714;
      allowedTCPPortRanges.from = 1764;
      allowedUDPPortRanges.to = 1714;
      allowedUDPPortRanges.from = 1764;
    };
  };
  services.resolved.enable = true;
  powerManagement.enable = true;

  # ===== AUDIO =====
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # ===== LOCALIZATION =====
  services.timesyncd.enable = false;
  services.chrony = {
    enable = true;
    extraConfig = ''
      server 10.0.0.53 minpoll -7 maxpoll 0 filter 31 polltarget 30 iburst burst maxdelay 0.002 maxdelayquant 0.1 xleave extfield F323
      hwtimestamp *
    '';
  };
  time.timeZone = "America/Sao_Paulo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # ===== USER CONFIGURATION =====
  users.users.nix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # ===== DESKTOP & DISPLAY =====
  services.displayManager = {
    gdm.enable = true;
    sessionPackages = [pkgs.niri];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.gdm.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # ===== PROGRAMS & SERVICES =====
  programs = {
    zsh.enable = true;
    kdeconnect.enable = true;
    firefox.enable = true;
    niri.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
  };

  services = {
    printing.enable = true;
    printing.drivers = [pkgs.hplip];
    gvfs.enable = true;
    udisks2.enable = true;
    syncthing = {
      enable = true;
      user = "nix";
      group = "wheel";
      dataDir = "/home/nix/Documents";
      configDir = "/home/nix/.config/syncthing";
    };
  };

  programs.adb.enable = true;

  # ===== QT/THEMING =====
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  # ===== PORTALS =====
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-wlr];
    configPackages = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-wlr];
  };

  # ===== NIX CONFIGURATION =====
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 1d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ===== ENVIRONMENT =====
  environment = {
    systemPackages = with pkgs; [
      # Desktop portals
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome

      # Build tools & dependencies
      gnumake
      ninja
      gcc
      binutils
      pkgconf
      libpkgconf
      cmake

      # Development
      nodejs
      bun
      uv
      python314
      go
      gopls
      ffmpeg
      libtool
      libffi

      # CLI tools
      wl-clipboard
      killall
      ripgrep
      zoxide
      fzf
      git
      eza
      dua
      sd
      fd
      aria2
      amdctl
      ddcutil
      cliphist
      speedtest-cli

      # GUI applications
      qbittorrent-enhanced
      sqlitestudio
      nautilus
      vdhcoapp
      neovim
      mangohud
      bottles
      gparted
      baobab
      qalculate-gtk
      vesktop
      ocenaudio
    ];

    shellInit = ''export PATH="${pkgs.fontconfig}/bin:${pkgs.cmake}/bin:${pkgs.libpkgconf}/bin:${pkgs.pkgconf}/bin:${pkgs.gcc}/bin:${pkgs.libffi}/bin:$PATH" '';
    sessionVariables = {
      PATH = ["$HOME/go/bin"];
      LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc pkgs.zlib pkgs.nodejs pkgs.libtool pkgs.fontconfig];
    };
  };

  # ===== FONTS =====
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
      poppins
      inter
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
