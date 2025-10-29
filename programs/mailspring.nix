{
  inputs,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (mailspring.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          wrapProgram $out/bin/mailspring \
            --add-flags "--password-store="gnome-libsecret"" \
        '';
    }))
    xwayland-satellite
  ];
}
