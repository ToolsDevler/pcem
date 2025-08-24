{
  description = "PCem - A PC emulator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "pcem";
          version = "vNext";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
            clang
            llvm
          ];

          buildInputs = with pkgs; [
            SDL2
            openal
            wxGTK32
            alsa-lib
            libpcap
            libGL
            qt5.qtbase
            qt5.qttools
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DPCEM_DISPLAY_ENGINE=wxWidgets"
            "-DUSE_NETWORKING=ON"
            "-DUSE_PCAP_NETWORKING=ON"
            "-DUSE_ALSA=ON"
            "-DPLUGIN_ENGINE=ON"
          ];

          # Ensure clang is used
          preConfigure = ''
            export CC=clang
            export CXX=clang++
          '';

          meta = with pkgs.lib; {
            description = "A PC emulator";
            homepage = "https://github.com/PCem-Team/PCem";
            license = licenses.gpl2Plus;
            platforms = platforms.linux;
            maintainers = [ ];
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            pkg-config
            clang
            llvm
            SDL2
            openal
            wxGTK32
            alsa-lib
            libpcap
            libGL
            qt5.qtbase
            qt5.qttools
            gdb
            valgrind
          ];

          shellHook = ''
            export CC=clang
            export CXX=clang++
            echo "PCem development environment loaded"
            echo "Use 'cmake -B build -S .' to configure"
            echo "Use 'cmake --build build' to build"
          '';
        };
      });
}
