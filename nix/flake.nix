{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
      # nixpkgs.config.allowUnsupportedSystem = true;

      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.neovim
          pkgs.tmux
          pkgs.git
          pkgs.alacritty
          pkgs.obsidian
          pkgs.vscode
          # pkgs.brave
          # pkgs.opera
          pkgs.google-chrome
          pkgs.docker
          pkgs.teams
          pkgs.terraform
          pkgs.vpn-slice
          pkgs.slack
          pkgs.
          pkgs.fzf
          pkgs.gh
          pkgs.gitleaks
          pkgs.awscli
          # pkgs.azure-cli
          # pkgs.direnv
          pkgs.go
          pkgs.go-task
          pkgs.git-crypt
          pkgs.black
          pkgs.jq
          pkgs.jupyter
          pkgs.kns
          pkgs.kubectx
          pkgs.kubelogin
          pkgs.libtool
          pkgs.libzip
          pkgs.openconnect
          pkgs.minikube
          pkgs.ripgrep
          pkgs.wget
          pkgs.redis
          pkgs.yarn
          pkgs.zoxide
          pkgs.zip
          pkgs.zsh
          pkgs.zsh-autocomplete
          pkgs.zsh-autosuggestions
          pkgs.zsh-syntax-highlighting
          pkgs.mas
          pkgs.oh-my-zsh
        ];
	    
      homebrew = {
        enable = true;
        brews = [
          "azure-cli"
          "direnv"
          # "gcc"
          # "jupyterlab"
          # "ipython"
          "keyring"
          "kubernetes-cli"
          "node@20"
          "make"
          "python@3.9"
          "python@3.10"
          "python@3.12"
        ];
        casks = [
          "google-cloud-sdk"
          "caffeine"
          "nikitabobko/tap/aerospace"
          "adoptopenjdk"
          "git-credential-manager"
          # "microsoft-azure-storage-explorer"
          # "brave-browser"
          # "opera"
        ];
        masApps = {
          # "Logic Pro" = 634148309;
          # "Splice" = 1363505768;
        };
        # onActivation.cleanup = "zap";
        # onActivation.autoUpdate = true;
        # onActivation.upgrade = true;
      };

      fonts.packages = [
	      (pkgs.nerdfonts.override {fonts = [ "JetBrainsMono" ];})
      ];

      programs.zsh.enable = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
      security.pam.enableSudoTouchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPath = [
        "/Users/youriprive/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        "/Users/youriprive/.deno/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/usr/bin"
        "/bin"
        "/usr/sbin"
      ];

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        dock.show-recents = false;
        dock.persistent-apps = [
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/System/Applications/Music.app"
          "/Applications/Opera.app"
          "/System/Applications/System\ Settings.app"
        ];
        dock.tilesize = 50;
        dock.wvous-bl-corner = 1;
        dock.wvous-br-corner = 4;
        dock.wvous-tr-corner = 1;
        dock.wvous-tl-corner = 1;
        dock.appswitcher-all-displays = true;
        dock.show-process-indicators = true;
        dock.mouse-over-hilite-stack = true;
        finder.FXPreferredViewStyle = "clmv";
        # NSGGlobalDomain.AppleInterfaceStyle = "Dark";
        # NSGGlobalDomain.AppleICUForce24HourTime = "true";
      };


      # code from dreams of autonomy to fix cmd+spacebar spotlight apps
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';
          };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#SB-yourivis
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "youriprive";
            autoMigrate = true;
          };
        }
       ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}

# nix stuff to memorize
# "nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#simple"