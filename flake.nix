{
  description = "Shell example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        nixpkgsConfig = {
          config = {
            allowUnfree = true;
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          inherit (nixpkgsConfig) config;
        };
      in {
        devShells.default = with pkgs; let
          inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;
          darwin_packages = [CoreServices ApplicationServices Security];

          ruby = ruby_2_7;
        in
          pkgs.mkShellNoCC rec {
            buildInputs =
              [
                autoconf automake bash-completion (hiPrio llvmPackages_14.bintools) bison
                cairo coreutils gdbm git gnumake groff
                libffi libiconv libtool libunwind libxml2
                libxslt libyaml msgpack ncurses netcat openssl
                pkg-config readline ruby shared-mime-info
                sqlcipher sqlite sqlite-interactive zlib
              ]
              ++ lib.optional stdenv.isDarwin darwin_packages;
            shellHook = ''
              export FREEDESKTOP_MIME_TYPES_PATH=${shared-mime-info}/share/mime/packages/freedesktop.org.xml

              mkdir -p .gems
              export GEM_HOME=$PWD/.gems
              export GEM_PATH=$GEM_HOME
              export PATH=$GEM_HOME/bin:$PATH

              # Add additional folders to to XDG_DATA_DIRS if they exists, which will get sourced by bash-completion
              for p in ''${buildInputs}; do
                if [ -d "$p/share/bash-completion" ]; then
                  if [ -z ''${XDG_DATA_DIRS} ]; then
                    XDG_DATA_DIRS="$p/share"
                  else
                    XDG_DATA_DIRS="$XDG_DATA_DIRS:$p/share"
                  fi
                fi
              done

              source ${bash-completion}/etc/profile.d/bash_completion.sh
            '';
          };
      }
    );
}
