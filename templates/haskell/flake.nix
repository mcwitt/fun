{
  description = "Anonymous Haskell project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskell.packages.ghc922;
        packageName = "default";
      in
      rec {
        packages.${packageName} =
          haskellPackages.callCabal2nix packageName ./. { };

        defaultPackage = self.packages.${system}.${packageName};

        devShell = haskellPackages.shellFor {
          packages = _: [ defaultPackage ];
          withHoogle = true;
          buildInputs = with pkgs; [
            cabal-install
            ghcid
            haskell.packages.ghc902.cabal-fmt
            haskellPackages.haskell-language-server
            ormolu
          ];
        };
      });
}
