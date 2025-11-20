{
  description = "NixOS 25.05 configuration with Home Manager, Niri, and Neovim Nightly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay/21595d9f79b5da0eef177dcfdd84ca981ac253a9";
    niri-flake.url = "github:sodiboo/niri-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
  in {
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit pkgs;};
      modules = [
        ./configuration.nix
        inputs.niri-flake.nixosModules.niri
      ];
    };

    homeConfigurations.nix = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./home.nix
        inputs.niri-flake.homeModules.niri
        inputs.noctalia.homeModules.default
      ];
    };
  };
}
