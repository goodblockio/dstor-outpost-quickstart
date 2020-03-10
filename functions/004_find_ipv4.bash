#
# 004 - Find IPv4
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for IPv4...";r_t
  IP4="$(curl -sS4m 10 http://$ECHO_SERVER/address 2>&1 )"

  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found IPv4 IP: "
    p_t
    echo "$IP4"
    # Is it valid?
    ip addr | egrep "$IP4" &> /dev/null
    if [ $? -eq 1 ]; then
      f_t
      echo "External IPv4 IP does not match any local interfaces (NAT Maybe?)"
      echo "This isn't a problem, nodes can't serve Outpost traffic from behind a NAT router"
      i_t
      return 0
    fi
    return 1
  else
    ERROR="IPv4 test failed: $IP4"
    f_t
    echo "$ERROR"
    i_t
    echo "This isn't a problem, this node just can't serve IPv4 requests"
    echo "Failed test: curl -sS4m 10 http://$ECHO_SERVER/address"
    return 0
  fi
r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  IP4=""
  # exit 255
fi
