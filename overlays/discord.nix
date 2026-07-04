# Discord lags behind in nixpkgs, so it nags to update (and can't self-update
# under Nix). This overlay pins it to the latest release.
#
# To bump: set `version`, then refresh the hashes with:
#   v=1.0.XXX; b=https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/$v
#   nix store prefetch-file "$b/full.distro"
#   for m in discord_cloudsync discord_desktop_core discord_dispatch \
#            discord_erlpack discord_game_utils discord_krisp discord_modules \
#            discord_rpc discord_spellcheck discord_utils discord_voice \
#            discord_zstd; do echo $m; nix store prefetch-file "$b/$m/1/full.distro"; done
# ponytail: hashes pinned by hand; Nix needs them, "always latest" isn't possible without IFD.
final: prev:
let
  version = "1.0.144";
  base = "https://stable.dl2.discordapp.net/distro/app/stable/linux/x64/${version}";
  mkModule = name: hash: {
    inherit hash version;
    url = "${base}/${name}/1/full.distro";
  };
  moduleHashes = {
    discord_cloudsync = "sha256-waCBE5ch939dUHBvn/MXXqZMfUsilU0ibdxV5WoPY7o=";
    discord_desktop_core = "sha256-QLgMl9F/fGsGUBJztzRFcp446KEbCQa046fRaLFn+tI=";
    discord_dispatch = "sha256-njLo5N5FC9YSvjQ9rQVN+9qrOWXKvzaaHg7HNwPKi+k=";
    discord_erlpack = "sha256-aBQFOhy1vTByxQg9DqdEZyaH/oOlyWf50aMLFSifbvo=";
    discord_game_utils = "sha256-uVkKc8hK8zwK1LRs5GqdOPlpG++s+qaZyMcHFV2gnXY=";
    discord_krisp = "sha256-mgXOsvsFFxeW50Hk9/64DDf2I2OoaYY4SRs4N5azC40=";
    discord_modules = "sha256-L2Ab18BnUJedBVpcoAt9XJ787ahQhipUIlLMtfMuqkg=";
    discord_rpc = "sha256-CQgtSoNNXqGsB93fzevcNm8mvlEdzGcJaaNKGLSNN08=";
    discord_spellcheck = "sha256-1Jzi0SXWC1v6b4caHncezrQlcV8zawESLG4hNYjY4to=";
    discord_utils = "sha256-xUZ4IeTKOxLlrYOem65p79ZOGpn9PAf1ao3G8rSoAe0=";
    discord_voice = "sha256-s5GQ+z8hv1wFbXp2wtbLcXBhLRqnZTZ0U1f+vySnw7c=";
    discord_zstd = "sha256-T4RWIOHUEa+MgKMwEuChMPTRVsA+fsUxbPiNTOz09eo=";
  };
in
{
  discord = prev.discord.override {
    source = {
      inherit version;
      distro = {
        url = "${base}/full.distro";
        hash = "sha256-fgtszwNLSypVpcijOLc1QPgsRWkq743qpsZjv+iBtBQ=";
      };
      modules = prev.lib.mapAttrs mkModule moduleHashes;
    };
  };
}
