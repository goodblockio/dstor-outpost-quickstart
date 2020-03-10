#
# 001 - Find Certbot
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for certbot...";r_t
  which certbot &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found certbot version: "
    p_t
    CERTBOT_V="$(certbot --version | cut -d' ' -f2)"
    echo -n "$CERTBOT_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which certbot)"
    return 1
  else
    ERROR="Certbot is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "certbot"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
