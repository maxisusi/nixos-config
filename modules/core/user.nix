{ user, ... }: {

  users.groups.wireshark = { };
  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" ];
  };
}
