{ inputs, pkgs, ... }:
let
  # Build the addons with *our* pkgs (which sets allowUnfree = true) so unfree
  # extensions like 1Password evaluate. The flake's prebuilt `.packages` use
  # their own nixpkgs with allowUnfree = false.
  addons = (inputs.firefox-addons.overlays.default pkgs pkgs).firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    profiles.max = {
      id = 0;
      isDefault = true;

      # Extensions managed declaratively via the rycee firefox-addons set.
      extensions.packages = with addons; [
        onepassword-password-manager
        ublock-origin
        react-devtools
      ];

      # Kagi as the sole search engine; hide all the built-in defaults.
      search = {
        force = true;
        default = "Kagi";
        privateDefault = "Kagi";
        engines = {
          "Kagi" = {
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # daily
            definedAliases = [
              "@k"
              "@kagi"
            ];
          };

          # Hide the default built-in engines.
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ddg".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      # Bookmarks imported from Google Chrome (max.balej@tipee.ch profile).
      # The "Toolbar" directory maps to Chrome's "Bookmarks bar".
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "Tipee";
                bookmarks = [
                  {
                    name = "Environments";
                    bookmarks = [
                      {
                        name = "Tipee";
                        url = "https://notre.tipee.net/home.php#/";
                      }
                      {
                        name = "tipee dev";
                        url = "http://localhost:10510/";
                      }
                    ];
                  }
                  {
                    name = "API";
                    bookmarks = [
                      {
                        name = "Public API";
                        url = "https://api.tipee.ch/getting-started/introduction";
                      }
                      {
                        name = "Local api";
                        url = "http://localhost:10510/api/doc";
                      }
                    ];
                  }
                  {
                    name = "GitHub";
                    bookmarks = [
                      {
                        name = "PR's";
                        url = "https://github.com/gammadia/tipee/pulls/maxisusi";
                      }
                      {
                        name = "Acquisition Project";
                        url = "https://github.com/orgs/tipee-sa/projects/66";
                      }
                    ];
                  }
                  {
                    name = "Datadog";
                    url = "https://app.datadoghq.eu/logs?query=%40instance%3A%28%2Avit%2A%20OR%20%2Avlt%2A%29%20-status%3A%28error%20OR%20warn%29&agg_m=count&agg_m_source=base&agg_t=count&cols=host%2Cservice&fromUser=true&messageDisplay=inline&refresh_mode=sliding&storage=hot&stream_sort=desc&viz=stream&from_ts=1753786869774&to_ts=1756378869774&live=true";
                  }
                  {
                    name = "tipee • Design";
                    url = "https://design.tipee.ch/7e40187d1/p/77bd55-tipee--design";
                  }
                ];
              }
              {
                name = "Dev Ressources";
                bookmarks = [
                  {
                    name = "Patterns";
                    url = "https://www.patterns.dev/";
                  }
                  {
                    name = "CyberChef";
                    url = "https://gchq.github.io/CyberChef/";
                  }
                  {
                    name = "RegExr: Learn, Build, & Test RegEx";
                    url = "https://regexr.com/";
                  }
                  {
                    name = "GNU sed live editor";
                    url = "https://sed.js.org/";
                  }
                  {
                    name = "BitwiseCmd";
                    url = "https://bitwisecmd.com/";
                  }
                  {
                    name = "cpm";
                    url = "https://stackoverflow.com/questions/71788254/react-18-typescript-children-fc";
                  }
                  {
                    name = "Regex Tutorial—From Regex 101 to Advanced Regex";
                    url = "https://www.rexegg.com/";
                  }
                  {
                    name = "Regex Golf";
                    url = "https://alf.nu/RegexGolf?world=regex&level=r00";
                  }
                  {
                    name = "Backend Developer Roadmap: What is Backend Development?";
                    url = "https://roadmap.sh/backend";
                  }
                ];
              }
              {
                name = "Cute Fantasy RPG - 16x16 top down pixel art asset pack by Kenmi";
                url = "https://kenmi-art.itch.io/cute-fantasy-rpg";
              }
            ];
          }
        ];
      };
    };
  };
}
