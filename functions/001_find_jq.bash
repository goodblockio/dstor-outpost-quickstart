#
# 001 - Find Jq
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for jq...";r_t
  which jq &> /dev/null

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found jq version: "
    p_t
    JQ_V="$(jq --version)"
    echo -n "$JQ_V"
    i_t
    echo -n " path: "
    p_t
    echo "$(which jq)"
    return 1
  else
    ERROR="Jq is not found."
    f_t
    echo "$ERROR Install with:"
    i_t
    error_install_package "jq"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
