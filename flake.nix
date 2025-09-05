{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = nixpkgs.lib.systems.flakeExposed;
      eachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = nixpkgs.legacyPackages.${system};
            inherit system;
          }
        );
    in
    {
      packages = eachSupportedSystem (
        { pkgs, system }:
        let
          openmoji = pkgs.fetchFromGitHub {
            owner = "hfg-gmuend";
            repo = "openmoji";
            rev = "16.0.0";
            hash = "sha256-4dYtLaABu88z25Ud/cuOECajxSJWR01qcTIZNWN7Fhw=";
          };
          buildResume =
            format:
            pkgs.stdenvNoCC.mkDerivation {
              name = "resume-${format}";

              src = ./.;

              nativeBuildInputs = with pkgs; [
                typst
                fontforge
              ];

              FONTCONFIG_FILE = pkgs.makeFontsConf {
                fontDirectories = [
                  pkgs.libertinus
                  "./fonts"
                ];
              };

              SOURCE_DATE_EPOCH = self.lastModified;

              OPENMOJI = openmoji;

              buildFlags = "resume.${format}";

              installPhase = "mv resume.${format} $out";
            };
        in
        rec {
          inherit openmoji;
          pdf = buildResume "pdf";
          png = buildResume "png";
          svg = buildResume "svg";
          default = pdf;
        }
      );

      devShells = eachSupportedSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShellNoCC {
            inputsFrom = [ self.packages.${system}.default ];

            packages = with pkgs; [
              poppler_utils
              tinymist
              fontconfig
            ];

            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = [
                pkgs.libertinus
                ((builtins.getEnv "PWD") + "/fonts")
              ];
            };

            OPENMOJI = self.packages.${system}.openmoji;
          };
        }
      );
    };
}
