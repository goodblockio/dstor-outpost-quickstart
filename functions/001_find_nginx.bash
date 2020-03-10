#
# 001 - Find Nginx
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for nginx...";r_t
  which nginx &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found nginx version: "
    p_t
    NGINX_V="$(nginx -v 2>&1 |cut -d' ' -f3|cut -d'/' -f2)"
    echo -n "$NGINX_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which nginx)"
    return 1
  else
    ERROR="Nginx is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "nginx"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
