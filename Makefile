nappa:
	sudo nixos-rebuild switch -I nixos-config=./nodes/nappa.nix

saibaman%:
	nix-build \
		'<nixpkgs/nixos>' \
		-A config.system.build.sdImage \
		--argstr system aarch64-linux \
		-I nixos-config="./nodes/$@.nix"
