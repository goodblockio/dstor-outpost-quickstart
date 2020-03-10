
# 002 - Find Speedtest CLI
#

# Payload

function sequence() {
  i_t;bold;echo "Pulling speedtest-cli...";r_t

  # cheating the passback of the path to 006_find_bandwidth for speedtest-cli ;)
  SPEEDTEST="$(mktemp -d)"
  cd $SPEEDTEST
  curl -sLo speedtest-cli https://raw.githubusercontent.com/StephanieSunshine/speedtest-cli/master/speedtest.py
  chmod +x speedtest-cli
  SPEEDTEST="$SPEEDTEST/speedtest-cli"

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found speedtest-cli version: "
    p_t
    STCLI_V="$(./speedtest-cli --version | cut -d\  -f2 | head -n1)"
    echo -n "$STCLI_V"
    i_t
    echo -n " path: "
    p_t
    echo "$SPEEDTEST"
    return 1
  else
    f_t
    echo "speedtest-cli failed to pull from GitHub"
    i_t
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
