{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.yabai;
in {
  options = {
    services.yabai.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the chunkwm window manager.";
    };

    services.yabai.package = mkOption {
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.yabai = {
      path = [ cfg.package config.environment.systemPath ];
      serviceConfig.ProgramArguments = [ "${getOutput "out" cfg.package}/bin/yabai" ];
      serviceConfig.RunAtLoad = true;
      serviceConfig.KeepAlive = true;
      serviceConfig.ProcessType = "Interactive";
    };
  };
}
