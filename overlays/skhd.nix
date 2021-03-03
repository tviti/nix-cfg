/* An overlay for building skhd on Darwin systems. As of this writing, this will
   source a newer version than nixpkgs.skhd (that one still won't search
   $XDG_CONFIG_HOME for skhdrc).
*/

self: super: {

  skhd = super.skhd.overrideAttrs (oldAttrs: rec {
    version = "b659b90576cf88100b52ca6ab9270d84af7e579b";

    src = super.fetchFromGitHub {
      owner = "koekeishiya";
      repo = "skhd";
      rev = version;
      sha256 = "137v4xdpfjrzdp4vb5jkxa0ka8m30vdkqh701wki2l9xdmzgx7bg";
    };

    buildInputs = oldAttrs.buildInputs ++ [ super.darwin.apple_sdk.frameworks.Cocoa ];
  });

}
