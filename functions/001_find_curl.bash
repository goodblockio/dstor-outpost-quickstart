#
# 001 - Find Curl
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for curl...";r_t
  which curl &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found curl version: "
    p_t
    CURL_V="$(curl --version | cut -d\  -f2 | head -n1)"
    echo -n "$CURL_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which curl)"
    return 1
  else
    ERROR="Curl is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "curl"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
