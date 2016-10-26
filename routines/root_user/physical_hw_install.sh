
function physical_hw_install {
apt-get install -y alsa-base pulseaudio libasound2 libasound2-plugins alsa-utils alsa-oss

usermod -aG pulse,pulse-access engines
echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.17.0.0/16" >> /etc/pulse/default.pa
echo PULSEAUDIO_SYSTEM_START=1 > /etc/default/pulseaudio
  }