#
# 006 - Find Available Bandwidth
#

# Payload

function sequence() {
  i_t;bold;echo "Network Benchmarking 6 servers from speedtest.net...";r_t
  CLI=$SPEEDTEST
  TEMPFILE="$(mktemp)"
  TEMPRESU1="$(mktemp)"
  TEMPRESU2="$(mktemp)"
  SERVERS="$($CLI --list --exclude 20721 | head -n 7 | tail -n +2 | cut -d\) -f1)"

  $CLI --csv-header > $TEMPFILE

  for s in $SERVERS; do
    echo Testing Speedtest server $s
    $CLI --csv --single --server $s >> $TEMPFILE
  done

  # Numbers sanitized in miller as csv values
  cat $TEMPFILE | mlr --csv put '$Ping=int($Ping);$Download=int($Download/1024/1024); $Upload=int($Upload/1024/1024); $Distance=fmtnum($Distance,"%1.3f")' then cut -f 'Server ID',Sponsor,Distance,Ping,Upload,Download > $TEMPRESU1

  # Calculate column averages
  cat $TEMPRESU1 | awk 'BEGIN {FS = "," } ; NR>1{distsum+=$3; pingsum+=$4; downsum+=$5; upsum+=$6} END { print "0,Averages,"distsum/6","pingsum/6","downsum/6","upsum/6}' > $TEMPRESU2

  break_t

  # Pretty print for user
  cat $TEMPRESU1 | sed -e 's/Upload/Upload\/Mbps/; s/Download/Download\/Mbps/' | mlr --c2p cut -f 'Server ID',Sponsor,Distance,Ping,'Upload/Mbps','Download/Mbps'

  # Save for upload
  SPEEDTEST=$(cat $TEMPRESU1 | sed -e 's/Upload/Upload\/Mbps/; s/Download/Download\/Mbps/' | mlr --c2j cut -f 'Server ID',Sponsor,Distance,Ping,'Upload/Mbps','Download/Mbps')

  SPEEDTEST=$(echo "$SPEEDTEST" | sed -e '$!s/$/,/' | sed -e 's/^/\t/')

  UPAVG="$(cut -d',' -f6 $TEMPRESU2)"
  DOAVG="$(cut -d',' -f5 $TEMPRESU2)"
  PIAVG="$(cut -d',' -f4 $TEMPRESU2)"

  break_t

  echo -n "Estimated Upload Bandwidth: ";if [ $(echo $UPAVG'>='50 | bc -l) -eq "1" ]; then p_t;else f_t;fi
  printf "%0.3f Mbps\n" $UPAVG
  r_t
  echo -n "Estimated Download Bandwidth: ";if [ $(echo $DOAVG'>='100 | bc -l) -eq "1" ]; then p_t;else f_t;fi
  printf "%0.3f Mbps\n" $DOAVG
  r_t
  echo -n "Estimated Ping: ";if [ $(echo $PIAVG'<='50 | bc -l) -eq "1" ]; then p_t;else f_t;fi
  printf "%0.3f Ms\n" $PIAVG
  r_t

}

sequence

# Exception handler

#if [ $? -eq 0 ]; then
  # exit 255
#fi
