#
# 005 - Test Open Ports
#

# Payload

function portTest() {
  FLAGS=$1
  RESULT=$2
  URL=$3
  TEST="$(curl $FLAGS $URL 2> /dev/null)"

  if [[ $TEST != $RESULT ]]; then
    C=0
    while [[ $TEST != $RESULT && $C < 2 ]]; do
      TEST="$(curl $FLAGS $URL 2> /dev/null)"
      ((C++))
    done
  fi
  echo "$TEST"
}

# portResponse IP, PORT, TESTUUID, SUBJECT
function portResponse() {
  local IP=$1
  local PORT=$2
  local TESTUUID=$3
  local SUBJECT=$4

  echo -n "$IP $PORT: "

  if [[ $SUBJECT == $TESTUUID ]]; then
    p_t
    echo "PASS"
  else
    f_t
    if [[ $SUBJECT == *"i/o timeout"* ]]; then
      echo "FAIL (Firewalled?)"
    else
      echo "FAIL (Result: $SUBJECT Needed: $TESTUUID)"
    fi
  fi
  r_t
}

function sequence() {
  i_t;bold;echo "Testing Open Ports..."
  i_t;echo "Sudo may ask for a password to start busybox httpd on privledged ports. It is normal if some of these fail.";r_t

  PROBLEM_PROCESSES=$(sudo netstat -lnp | egrep '\:(80|443|4001)')

  if [ $? -eq 0 ]; then
    f_t;echo "Processes blocking opening ports.  Please stop the following processes and try again"
    echo "$PROBLEM_PROCESSES"
    r_t
    return 0
  fi

  i_t;echo -n "Opening ports: ";p_t;echo "80,443,4001/tcp"
  cd /tmp
  cd $(mktemp -d)
  echo $TESTUUID > index.html
  i_t;echo -n "Looking for uuid: ";p_t;echo $TESTUUID
  f_t
  sudo -b bash -c 'busybox httpd -p 80 && busybox httpd -p 443 && busybox httpd -p 4001'
  r_t

  while [ $(pidof busybox | wc -w) -ne 3 ]; do sleep 0.1; done

  break_t

  if [[ $IP4 != "" ]]; then
    IP4P80=$(portTest "-4sm 2" $TESTUUID "http://$IP4:80/")
    IP4P443=$(portTest "-4sm 2" $TESTUUID "http://$IP4:443/")
    IP4P4001=$(portTest "-4sm 2" $TESTUUID  "http://$IP4:4001/")
    EIP4P80=$(portTest "-4sm 10" $TESTUUID "http://$ECHO_SERVER/uuid/80")
    EIP4P443=$(portTest "-4sm 10" $TESTUUID "http://$ECHO_SERVER/uuid/443")
    EIP4P4001=$(portTest "-4sm 10" $TESTUUID "http://$ECHO_SERVER/uuid/4001")
  fi

  IP6P80=$(portTest "-6sm 2" $TESTUUID "http://[$IP6]:80/")
  IP6P443=$(portTest "-6sm 2" $TESTUUID "http://[$IP6]:443/")
  IP6P4001=$(portTest "-6sm 2" $TESTUUID "http://[$IP6]:4001/")
  EIP6P80=$(portTest "-6sm 10" $TESTUUID "http://$ECHO_SERVER/uuid/80")
  EIP6P443=$(portTest "-6sm 10" $TESTUUID "http://$ECHO_SERVER/uuid/443")
  EIP6P4001=$(portTest "-6sm 10" $TESTUUID "http://$ECHO_SERVER/uuid/4001")

  if [[ $IP4 != "" ]]; then
    portResponse "$IP4" "Local 80" "$TESTUUID" "$IP4P80"
    portResponse "$IP4" "Local 443" "$TESTUUID" "$IP4P443"
    portResponse "$IP4" "Local 4001" "$TESTUUID" "$IP4P4001"
    portResponse "$IP4" "Remote 80" "$TESTUUID" "$EIP4P80"
    portResponse "$IP4" "Remote 443" "$TESTUUID" "$EIP4P443"
    portResponse "$IP4" "Remote 4001" "$TESTUUID" "$EIP4P4001"
    break_t
  fi

  portResponse "$IP6" "Local 80" "$TESTUUID" "$IP6P80"
  portResponse "$IP6" "Local 443" "$TESTUUID" "$IP6P443"
  portResponse "$IP6" "Local 4001" "$TESTUUID" "$IP6P4001"
  portResponse "$IP6" "Remote 80" "$TESTUUID" "$EIP6P80"
  portResponse "$IP6" "Remote 443" "$TESTUUID" "$EIP6P443"
  portResponse "$IP6" "Remote 4001" "$TESTUUID" "$EIP6P4001"

  sudo killall -w busybox
  break_t

  if [[ $IP4 != "" ]]; then
    i_t;echo -n "$IP4 world accessible for ports 80,443,4001/tcp: "
    if [ "$EIP4P80" = $TESTUUID ] && [ "$EIP4P443" = $TESTUUID ] && [ "$EIP4P4001" = $TESTUUID ]; then
      p_t
      echo "PASS"
      r_t
    else
      f_t
      echo "FAIL"
      r_t
    fi
  fi

  i_t;echo -n "$IP6 world accessible for ports 80,443,4001/tcp: "

  if [ "$EIP6P80" == $TESTUUID ] && [ $EIP6P443 == $TESTUUID ] && [ $EIP6P4001 == $TESTUUID ]; then
    p_t
    echo "PASS"
    r_t
    return 1
  else
    f_t
    echo "FAIL"
    r_t
    return 0
  fi

}

sequence

# Exception handler

if [ $? -eq 0 ]; then
  exit 255
fi
