{
  inputs = {
    self = {
      submodules = true;
    };
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            zola
          ];
        };
        packages.site = pkgs.stdenv.mkDerivation {
          name = "site";
          src = ./.;

          nativeBuildInputs = [
            pkgs.zola
          ];
          buildPhase = ''
            ${pkgs.zola}/bin/zola build
          '';
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.site;
      }
    );
}
