{ config, pkgs, ... }:

{
  security.sudo =
  {
    enable = false;
    wheelNeedsPassword = true;
  };

  security.pam.loginLimits =
  [
    { domain = "*"; item = "nproc"; type = "soft"; value = "500"; }
    { domain = "*"; item = "nproc"; type = "hard"; value = "500"; }
    { domain = "*"; item = "maxlogins"; type = "hard"; value = "3"; }
    { domain = "*"; item = "nofile"; type = "hard"; value = "512"; }
  ];

  users.users.jeaye =
  {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" ];
  };

  # Allow useradd/groupadd imperatively
  users.mutableUsers = true;

  services.fail2ban =
  {
    enable = true;

    # Brute-force password attacks
    jails.ssh-iptables =
    ''
      maxretry = 5
      bantime  = 3600 # 1 hour
      enabled  = true
    '';
    # Port scanning
    jails.port-scan =
    ''
      filter   = portscan
      action   = iptables-allports[name=portscan]
      maxretry = 2
      bantime  = 7200 # 2 hours
      enabled  = true
    '';
  };
  environment.etc."fail2ban/filter.d/portscan.conf".text =
  ''
    [Definition]
    failregex = rejected connection: .* SRC=<HOST>
  '';

  # Limit stack size to reduce memory usage
  systemd.services.fail2ban.serviceConfig.LimitSTACK = 256 * 1024;
}
