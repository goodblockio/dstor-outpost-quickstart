#
# 001 - Find Egrep
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for egrep...";r_t
  which egrep &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found egrep version: "
    p_t
    EGREP_V="$(egrep -V | head -n1 | cut -d\  -f4-)"
    echo -n "$EGREP_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which egrep)"
    return 1
  else
    ERROR="Egrep is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "grep"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
