# ./modules/wyoming.nix
{ ... }:
{
  configurations.nixos."cosmoslaptop".module = { ... }: {
    services.wyoming = {
      # 1. Wake Word (Back-end only)
      openwakeword.enable = true;
      openwakeword.uri = "tcp://127.0.0.1:10400"; # [cite: 164]

      # 2. STT (Required: uri and language)
      faster-whisper.servers.stt = {
        enable = true;
        uri = "tcp://127.0.0.1:10300"; # [cite: 216]
        language = "en";               # [cite: 241]
      };

      piper.servers.tts = {
        enable = true;
        uri = "tcp://127.0.0.1:10200"; 
        voice = "en_US-lessac-medium";]
      };
    };
  };
}