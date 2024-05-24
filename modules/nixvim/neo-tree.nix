{
  plugins.neo-tree = {
    enable = true;
    enableRefreshOnWrite = true;
    enableGitStatus = true;
    enableDiagnostics = true;
    gitStatusAsync = true;
    gitStatusAsyncOptions = {
      batchSize = 1000;
      batchDelay = 10;
      maxLines = 10000;
    };
    filesystem.followCurrentFile = {
      enabled = true;
    };
  };
}
