{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "omarcospo";
      user.email = "marcos.felipe@usp.br";
      init.defaultBranch = "main";
    };
  };
}
