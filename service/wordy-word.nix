{ config, pkgs, ... }:

{
  environment.systemPackages =
  [
    pkgs.leiningen
    pkgs.openjdk
  ];

  nixpkgs.config =
  {
    packageOverrides = pkgs: rec
    {
      wordy-word = pkgs.callPackage ../pkg/wordy-word.nix { };
    };
  };

  environment.etc =
  {
    "user/wordy-word/run-server" =
    {
      text =
      ''
        #!/run/current-system/sw/bin/bash
        set -eu
        export PATH=${pkgs.wget}/bin:${pkgs.gnutar}/bin:$PATH

        if [ ! -f unapproved-nouns ];
        then
          ${pkgs.wordy-word}/bin/build-word-lists
        fi

        ${pkgs.openjdk}/bin/java -jar ${pkgs.wordy-word}/bin/wordy-word.jar
      '';
      mode = "0775";
    },
    "user/wordy-word/build-word-lists" =
    {
      text = lib.readFile ${pkgs.wordy-word}/bin/build-word-lists;
    }
  };

  systemd.services.wordy-word =
  {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig =
    {
      User = "wordy-word";
      WorkingDirectory = "/etc/user/wordy-word";
      ExecStart = "/etc/user/wordy-word/run-server";
    };
  };

  users.users.wordy-word =
  {
    isNormalUser = false;
    home = "/etc/user/wordy-word";
    createHome = true;
  };

  system.activationScripts =
  {
    wordy-word-home =
    {
      deps = [];
      text =
      ''
        chown -R wordy-word:users /etc/user/wordy-word
      '';
    };
  };
}
