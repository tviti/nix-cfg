/*

An overlay for building skhd on Darwin systems. As of this writing, this will
source a newer version than nixpkgs.skhd (that one still won't search
$XDG_CONFIG_HOME for skhdrc).

*/

self: super:
{

  skhd = super.skhd.overrideAttrs (oldAttrs: {
    version = "a3dd7bf7dd5135ae567db7922216b4e09d51cae8";
    src = super.fetchFromGitHub {
      owner = "koekeishiya";
      repo = "skhd";
      rev = "a3dd7bf7dd5135ae567db7922216b4e09d51cae8";
      sha256 = "15cnfca1fr2g4jgys9alhviys7n92h42hal9kqhqncmkxq2k64r7";
    };
  });

}
