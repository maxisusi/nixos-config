{

  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [{
        key = "C";
        command = ''
          git commit -m "{{ .Form.Type }}{{if .Form.Scopes}}({{ .Form.Scopes }}){{end}}: {{ .Form.Description }}"'';
        description = "commit with commitizen";
        context = "files";
        prompts = [
          {
            type = "menu";
            title = "Select the type of change you are committing.";
            key = "Type";
            options = [
              {
                name = "Feature";
                description = "a new feature";
                value = "feat";
              }
              {
                name = "Fix";
                description = "a bug fix";
                value = "fix";
              }
              {
                name = "Documentation";
                description = "Documentation only changes";
                value = "docs";
              }
              {
                name = "Styles";
                description =
                  "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)";
                value = "style";
              }
              {
                name = "Code Refactoring";
                description =
                  "A code change that neither fixes a bug nor adds a feature";
                value = "refactor";
              }
              {
                name = "Performance Improvements";
                description = "A code change that improves performance";
                value = "perf";
              }
              {
                name = "Tests";
                description =
                  "Adding missing tests or correcting existing tests";
                value = "test";
              }
              {
                name = "Builds";
                description =
                  "Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)";
                value = "build";
              }
              {
                name = "Continuous Integration";
                description =
                  "Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)";
                value = "ci";
              }
              {
                name = "Chores";
                description =
                  "Other changes that don't modify src or test files";
                value = "chore";
              }
              {
                name = "Reverts";
                description = "Reverts a previous commit";
                value = "revert";
              }
            ];
          }
          {
            type = "input";
            title = "Enter the scope(s) of this change.";
            key = "Scopes";
          }
          {
            type = "input";
            title = "Enter the short description of the change.";
            key = "Description";
          }
          {
            type = "confirm";
            title = "Is the commit message correct?";
            body =
              "{{ .Form.Type }}{{if .Form.Scopes}}({{ .Form.Scopes }}){{end}}: {{ .Form.Description }}";
          }
        ];
      }];
      os = {
        openCommand = "code --goto {{filename}}";
        editCommand = "code";
      };
      git = { overrideGpg = true; };
    };
  };
}
