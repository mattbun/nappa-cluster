with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    fluxcd
  ];
}
