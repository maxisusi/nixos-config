{ inputs, pkgs, ... }:
let
  # Build the addons with *our* pkgs (which sets allowUnfree = true) so unfree
  # extensions like 1Password evaluate. The flake's prebuilt `.packages` use
  # their own nixpkgs with allowUnfree = false.
  addons = (inputs.firefox-addons.overlays.default pkgs pkgs).firefox-addons;

  # Combined Hunspell dictionary dir (English + French) for Firefox spell-check.
  # Firefox reads dictionaries from the directory in spellchecker.dictionary_path.
  spellDicts = pkgs.symlinkJoin {
    name = "firefox-hunspell-dicts";
    paths = [
      pkgs.hunspellDicts.en_US
      pkgs.hunspellDicts.fr-moderne
    ];
  };
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

      settings = {
        # Required for userChrome.css to take effect.
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Disable middle-click paste (primary selection) — stops accidental
        # pastes into search bars and form fields when clicking with the wheel.
        "middlemouse.paste" = false;

        # Spell-checking in English (en_US) and French (fr_FR) simultaneously.
        "spellchecker.dictionary_path" = "${spellDicts}/share/hunspell";
        "spellchecker.dictionary" = "en_US,fr_FR";
        "layout.spellcheckDefault" = 2; # also check single-line text inputs

        # Dark theme: force the built-in dark UI and dark website rendering.
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.toolbar-theme" = 0; # 0 = dark
        "browser.theme.content-theme" = 0; # 0 = dark
        "layout.css.prefers-color-scheme.content-override" = 0; # 0 = dark
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };

      # Tabs on the bottom of the window. Copied from
      # https://github.com/jonhoo/configs/blob/master/gui/.mozilla/firefox/chrome/userChrome.css
      userChrome = ''
        @-moz-document url(chrome://browser/content/browser.xhtml) {
        	/* tabs on bottom of window */
        	/* requires that you set
        	 * toolkit.legacyUserProfileCustomizations.stylesheets = true
        	 * in about:config
        	 * figure out current firefox's profile folder in about:support
        	 */
        	#main-window body { flex-direction: column-reverse !important; }
        	#navigator-toolbox { flex-direction: column-reverse !important; }
        	#urlbar-searchmode-switcher { position: static !important; }
        	#urlbar {
        		top: unset !important;
        		bottom: calc(var(--urlbar-container-height) + 2 * var(--urlbar-padding-block)) !important;
        		box-shadow: none !important;
        		display: flex !important;
        		flex-direction: column !important;
        	}
        		#urlbar > * {
        			flex: none;
        		}
        	#urlbar .urlbar-input-container {
        		order: 2;
        	}
        	#urlbar > .urlbarView {
        		order: 1;
        		border-bottom: 1px solid #666;
        	}
        	#urlbar-results {
        		display: flex;
        		flex-direction: column-reverse;
        	}
        	.search-one-offs { display: none !important; }
        	.tab-background { border-top: none !important; }
        	#navigator-toolbox::after { border: none; }
        	#TabsToolbar .tabbrowser-arrowscrollbox,
        	#tabbrowser-tabs, .tab-stack { min-height: 28px !important; }
        	.tabbrowser-tab { font-size: 80%; }
        	.tab-content { padding: 0 5px; }
        	.tab-close-button .toolbarbutton-icon { width: 12px !important; height: 12px !important; }
        	toolbox[inFullscreen=true] { display: none; }
        	/*
        	 * the following makes it so that the on-click panels in the nav-bar
        	 * extend upwards, not downwards. some of them are in the #mainPopupSet
        	 * (hamburger + unified extensions), and the rest are in
        	 * #navigator-toolbox. They all end up with an incorrectly-measured
        	 * max-height (based on the distance to the _bottom_ of the screen), so
        	 * we correct that. The ones in #navigator-toolbox then adjust their
        	 * positioning automatically, so we can just set max-height. The ones
        	 * in #mainPopupSet do _not_, and so we need to give them a
        	 * negative margin-top to offset them *and* a fixed height so their
        	 * bottoms align with the nav-bar. We also calc to ensure they don't
        	 * end up overlapping with the nav-bar itself. The last bit around
        	 * cui-widget-panelview is needed because "new"-style panels (those
        	 * using "unified" panels) don't get flex by default, which results in
        	 * them being the wrong height.
        	 *
        	 * Oh, yeah, and the popup-notification-panel (like biometrics prompts)
        	 * of course follows different rules again, and needs its own special
        	 * rule.
        	 */
        	#mainPopupSet panel.panel-no-padding { margin-top: calc(-50vh + 40px) !important; }
        	#mainPopupSet .panel-viewstack, #mainPopupSet popupnotification { max-height: 50vh !important; height: 50vh; }
        	#mainPopupSet panel.panel-no-padding.popup-notification-panel { margin-top: calc(-50vh - 35px) !important; }
        	#navigator-toolbox .panel-viewstack { max-height: 75vh !important; }
        	panelview.cui-widget-panelview { flex: 1; }
        	panelview.cui-widget-panelview > vbox { flex: 1; min-height: 50vh; }
        }
      '';

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
                        name = "tipee app";
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
                        url = "https://api.tipee.ch/guides-and-resources/first-steps";
                      }
                      {
                        name = "Local API";
                        url = "http://localhost:10510/api/doc";
                      }
                    ];
                  }
                  {
                    name = "GitHub";
                    bookmarks = [
                      {
                        name = "Latest PR";
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
                    name = "Design system";
                    url = "https://design.tipee.ch/7e40187d1/p/77bd55-tipee--design";
                  }
                  {
                    name = "Sloth";
                    url = "https://sloth.gammadia.net/";
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
                name = "course";
                bookmarks = [
                  {
                    name = "Maîtriser KiCad - Conçois tes propres circuits imprimés";
                    url = "https://cours.abregeacademy.com/products/maitriser-kicad-concois-tes-propres-circuits-imprimes/";
                  }
                ];
              }
              {
                name = "Printables";
                url = "https://www.printables.com/";
              }
            ];
          }
        ];
      };
    };
  };

  # Make Firefox the default browser.
  home.sessionVariables.BROWSER = "firefox";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
