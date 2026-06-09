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
            definedAliases = [ "@k" "@kagi" ];
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
                name = "M. Guillaume Bassand, psychologue à Lausanne | Prendre RDV";
                url = "https://www.onedoc.ch/fr/psychologue/lausanne/pc123/guillaume-bassand";
              }
              {
                name = "tipee • Design";
                url = "https://design.tipee.ch/7e40187d1/p/77bd55-tipee--design";
              }
              {
                name = "typ.ing";
                url = "https://typ.ing/text/code";
              }
              {
                name = "Akiflow";
                url = "https://web.akiflow.com/#/planner/today";
              }
              {
                name = "Tipee";
                url = "https://notre.tipee.net/home.php#/";
              }
              {
                name = "tipee dev";
                url = "http://localhost:10510/";
              }
              {
                name = "2nSUP";
                url = "https://tipee.atlassian.net/jira/software/c/projects/FRM/boards/47";
              }
              {
                name = "API";
                url = "http://localhost:10510/api/doc";
              }
              {
                name = "DD";
                url = "https://app.datadoghq.eu/logs?query=%40instance%3A%28%2Avit%2A%20OR%20%2Avlt%2A%29%20-status%3A%28error%20OR%20warn%29&agg_m=count&agg_m_source=base&agg_t=count&cols=host%2Cservice&fromUser=true&messageDisplay=inline&refresh_mode=sliding&storage=hot&stream_sort=desc&viz=stream&from_ts=1753786869774&to_ts=1756378869774&live=true";
              }
              {
                name = "API ~ TIPEE";
                url = "https://api.tipee.ch/getting-started/introduction";
              }
              {
                name = "Hydro x tipee – Figma";
                url = "https://www.figma.com/design/e1Qymj8y5PQSDBDggeComO/Hydro-x-tipee?node-id=0-1&p=f&m=dev";
              }
              {
                name = "COEURRH";
                url = "https://www.figma.com/design/RBfUjULPT4cU5kLXLZjqi2/Annuaire---dossier-RH?node-id=2620-24200&p=f&m=dev";
              }
              {
                name = "PR's";
                url = "https://github.com/gammadia/tipee/pulls/maxisusi";
              }
              {
                name = "AQUI";
                url = "https://github.com/orgs/tipee-sa/projects/66";
              }
              {
                name = "HYDRO";
                url = "https://github.com/orgs/tipee-sa/projects/58";
              }
              {
                name = "FF_Tipee";
                url = "javascript:(async ()=>{  const u = \"//\"+location.host+\"/admin/feature-flags\";  const p = await fetch(u).then(r=>r.text());  const d = new DOMParser().parseFromString(p, \"text/html\");  const t = d.querySelector('[name=\"form[_token]\"]').value;  const i = [...d.querySelectorAll('form input[type=\"checkbox\"]')];  const x = parseInt(prompt(i.map((i,idx)=>`\${idx+1}. [\${i.checked?%27x%27:%27%20%20%27}]%20\${i.dataset.flag.slice(8)}`).join(%22\\n%22)));%20%20if%20(!x)%20return;%20%20const%20ts%20=%20i.filter((i,idx)=%3E%20x==idx+1%20?%20!i.checked%20:%20i.checked%20).map(i=%3Ei.name);%20%20const%20fd%20=%20new%20FormData();%20%20fd.append(%22form[_token]%22,%20t);%20%20ts.forEach(s=%3Efd.append(s,%20%221%22));%20%20await%20fetch(u,%20{method:%20%27POST%27,%20body:%20fd%20});%20%20location.reload();})()";
              }
              {
                name = "Nooda";
                url = "https://github.com/Nooda-ch/nooda";
              }
              {
                name = "Health";
                url = "https://docs.google.com/spreadsheets/d/1Uaa_eHwbgdA1Lmt72jjeMgss4JfbB2si15yromOEKWE/edit?gid=974214785#gid=974214785";
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
              {
                name = "Dark Triad Test Results";
                url = "https://openpsychometrics.org/tests/SD3/results.php";
              }
              {
                name = "Investment Solutions | Swiss Life Asset Managers";
                url = "https://invest.swisslife-am.com/?list=saved";
              }
              {
                name = "caldigit - Kagi Search";
                url = "https://kagi.com/images?q=caldigit";
              }
              {
                name = "Activité 2.0: amélioration pour Hydro - Miro";
                url = "https://miro.com/app/board/uXjVGHVOA4U=/";
              }
              {
                name = "Agents write code. They don't do software engineering. - The New Stack";
                url = "https://thenewstack.io/ai-agents-software-engineering/";
              }
              {
                name = "[HR-Core] Slidepanel by kinds by brunod1388 · Pull Request #7999 · tipee-sa/tipee";
                url = "https://github.com/tipee-sa/tipee/pull/7999/changes?file-filters%5B%5D=.tsx#diff-24919fe46ad74487585df52458833a493c5e6e9c949e1d16486dac636bf3c02e";
              }
              {
                name = "milanglacier/minuet-ai.nvim: 💃 Dance with Intelligence in Your Code. Minuet offers code completion as-you-type from popular LLMs including OpenAI, Gemini, Claude, Ollama, Llama.cpp, Codestral, and more.";
                url = "https://github.com/milanglacier/minuet-ai.nvim#openai-compatible";
              }
            ];
          }
          {
            name = "confi";
            url = "https://github.com/nix-community/nixvim/blob/main/plugins/by-name/dap/default.nix";
          }
          {
            name = "jsdom/jsdom: A JavaScript implementation of various web standards, for use with Node.js";
            url = "https://github.com/jsdom/jsdom";
          }
          {
            name = "Dev";
            url = "http://localhost:10510/home.php";
          }
        ];
      };
    };
  };
}
