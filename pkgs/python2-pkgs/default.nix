{ callPackage }:
rec {
  python-box = callPackage ./python-box.nix {};
  paho-mqtt = callPackage ./paho-mqtt.nix {};
}
