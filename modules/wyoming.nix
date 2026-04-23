# ./modules/wyoming.nix
{ pkgs, ... }: {
  configurations.nixos."cosmoslaptop".module = { pkgs, ... }: {
    services.wyoming = {
      openwakeword = {
              enable = true;
              uri = "tcp://127.0.0.1:10400";
              threshold = 0.1;
              # Added --debug to see the internal search paths
              extraArgs = [ 
                "--debug" 
                # "--preload-model" "ok_nabu" 
                "--preload-model" "hey_jarvis" 
              ]; 
            };
      satellite = {
              enable = true;
              name = "cosmos-ear";
              uri = "tcp://127.0.0.1:10700";
              user = "sudha";
              group = "users";
      
              # 1. AUDIO SOURCE (KEEP PAREC)
              microphone.command = "${pkgs.pipewire}/bin/pw-record --rate=16000 --channels=1 --format=s16 --raw -";             
              sound.command = "${pkgs.pipewire}/bin/pw-play --rate=22050 --channels=1 --format=s16 --raw -";              # 2. ENHANCEMENTS (README recommendation)
              # Automatic gain control (0-31 dbFS). [cite: 19, 20]
              microphone.autoGain = 15; 
              # Noise suppression (0-4). [cite: 22]
              microphone.noiseSuppression = 2; 
      
              # 3. DISABLE VAD (README: Unnecessary for local wake word) 
              vad.enable = false;
      
              extraArgs = [
                "--wake-uri" "tcp://127.0.0.1:10400"
                "--wake-word-name" "hey_jarvis"
                "--mic-volume-multiplier" "2.0"
              ];
            };
      
      # Keep STT and TTS as they were [cite: 218-224]
      faster-whisper.servers.stt = {
        enable = true;
        uri = "tcp://127.0.0.1:10300";
        model = "tiny.en";
        language = "en";
        device = "cpu";
      };
      piper.servers.tts = {
        enable = true;
        uri = "tcp://127.0.0.1:10200";
        voice = "en_US-lessac-medium";
      };
    };

    # Systemd Overrides for PipeWire Access
    systemd.services.wyoming-satellite = {
      # This allows the service to find your PipeWire session [cite: 43, 230]
      environment.XDG_RUNTIME_DIR = "/run/user/1000"; 
      
      serviceConfig = {
        # We no longer need to force hardware access because we're using a socket
        PrivateDevices = pkgs.lib.mkForce false; 
        DevicePolicy = pkgs.lib.mkForce "auto"; 
        
        # This is critical: PipeWire requires access to your user's home/run folders
        ProtectHome = pkgs.lib.mkForce "read-only";
      };
    };
  };
}