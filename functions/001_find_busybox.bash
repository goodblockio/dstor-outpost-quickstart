#
# 001 - Find Busybox
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for busybox...";r_t
  which busybox &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found busybox version: "
    p_t
    BUSYBOX_V="$(busybox | head -n1 | cut -f2 -d\ )"
    echo -n "$BUSYBOX_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which busybox)"
    return 1
  else
    ERROR="Busybox is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "busybox"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
