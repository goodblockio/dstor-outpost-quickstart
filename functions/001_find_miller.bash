#
# 001 - Find Miller
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for miller...";r_t
  which mlr &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found miller version: "
    p_t
    MILLER_V="$(mlr --version| cut -d' ' -f2)"
    echo -n "$MILLER_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which mlr)"
    return 1
  else
    ERROR="Miller is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "miller"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
