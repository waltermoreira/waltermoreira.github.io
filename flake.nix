{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    shell-utils.url = "github:waltermoreira/shell-utils";
  };
  outputs = { self, nixpkgs, flake-utils, shell-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      shell = shell-utils.myShell.${system};
      ruby = pkgs.ruby_3_4.withPackages (ps: [ ps.jekyll ]);
    in
    {
      devShell = shell {
        name = "github-pages";
        extraInitRc = '' '';
        buildInputs = with pkgs; [
          bundler
          go-task
          findutils
          ruby
        ] ++ lib.optional stdenv.isDarwin apple-sdk_14;
      };
    }
  );
}
