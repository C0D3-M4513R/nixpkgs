{ stdenv
, fetchzip
, cmake
, openssl
, liboqs
}:
stdenv.mkDerivation rec {
  name = "oqs-provider";
  version = "0.6.0";

  src = fetchzip {
    url = "https://github.com/open-quantum-safe/oqs-provider/archive/refs/tags/${version}.zip";
    hash = "sha256-9iVslcBLLzQ4ACS7xsTj4wOLZO56DWWPjKRVmCXaW7I=";
  };

  buildInputs = [ openssl liboqs ];
  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ openssl.bin ];

  preInstall = ''
    mkdir -p "$out"
    for dir in "$out" "${openssl.out}"; do
      mkdir -p .install/"$(dirname -- "$dir")"
      ln -s "$out" ".install/$dir"
    done
    export DESTDIR="$(realpath .install)"
  '';

  enableParallelBuilding = true;

  enableParallelInstalling = false;

  doCheck = true;
}
