{ callPackage }:
rec {
  pykwalify = callPackage ./pykwalify.nix {};
  python-box = callPackage ./python-box.nix {};
  paho-mqtt = callPackage ./paho-mqtt.nix {};
}
