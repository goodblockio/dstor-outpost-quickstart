#
# 003 - Find IPv6
#

# Payload

function sequence() {
  i_t;bold;echo "Looking for IPv6...";r_t
  IP6="$(curl -sS6m 10 http://$ECHO_SERVER/address 2>&1 )"

  # Did it work?
  if [ $? -eq 0 ]; then
    i_t
    echo -n "Found IPv6 IP: "
    p_t
    echo "$IP6"
    # Is it valid?
    ip addr | egrep "$IP6" &> /dev/null
    if [ $? -eq 1 ]; then
      f_t
      echo "IPv6 test failed"
      i_t
      echo "External IPv6 IP does not match any local interfaces (NAT Maybe?)"
      return 0
    fi
    return 1
  else
    f_t
    echo "IPv6 test failed"
    i_t
    echo "Make sure your IPv6 is working and your DNS server correctly supports IPv6 lookups"
    echo "Failed test: curl -sS6m 10 http://$ECHO_SERVER/address"
    return 0
  fi

r_t
}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
