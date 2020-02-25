#
# 007 - Find Available Storage
#

# Payload

function sequence() {
  i_t;bold;echo "Finding storage partitions...";r_t
  DF=$(df -BG --output="avail,source,target" | tail -n+2 | sort -hr)
  PDATA=$(egrep -m1 'data$' <<< "$DF")
  if [ $? -ne 0 ]; then
    f_t
    echo "Error occured trying to auto detect the data partition.  Make sure that you have an empty partition of at least 2T in size, mounted, and the path ends in data"
    r_t
    exit 1
  fi

  PCACHE=$(egrep -m1 'cache$' <<< "$DF")
  if [ $? -ne 0 ]; then
    f_t
    echo "Error occured trying to auto detect the cache partition.  Make sure that you have an empty partition that is at least 20% of the data partiton size, mounted, and the path ends in cache"
    r_t
    exit 1
  fi

  # targets free space

  echo -n "Size of auto detected data partition: ";
  PDATA_SIZE=$(awk '{print $1;}' <<< "$PDATA" | sed -e 's/G$/\/100\*100/' | bc)

  if [ $PDATA_SIZE -ge 2000 ]; then
    p_t
    echo "$PDATA_SIZE"G
  else
    f_t
    echo "$PDATA_SIZE"G "< 2000G"
    r_t
    exit 1
  fi
  r_t

  echo -n "Size of auto detected cache partition: ";
  # Pull it and its prefix so we can do math
  PCACHE_SIZE=$(awk '{print $1}' <<< "$PCACHE" | sed -e 's/G$//')
  # divide partiton cache by 10 as a float, round up, and then multiply back
  # this is in to add some fuzzy logic around formatted partition sizes
  # before 599 would end up as 500 and if 600 was the cut off then it would fail
  # now if you are within 5G of your target, it will allow a pass

  PCACHE_SIZE=$(python -c "import sys; from math import ceil; print(ceil(float($PCACHE_SIZE)/10.0)*10)")

  PCACHE_MIN_SIZE=$(bc <<< "($PDATA_SIZE*.2)/100*100")

  if [ $PCACHE_SIZE -ge $PCACHE_MIN_SIZE ]; then
    p_t
    echo "$PCACHE_SIZE"G
  else
    f_t
    echo "$PCACHE_SIZE"G "<" "$PCACHE_MIN_SIZE"G
    r_t
    exit 1
  fi
  r_t

  # targets source
  PDATA_SOURCE=$(awk '{print $2;}' <<< "$PDATA")
  PCACHE_SOURCE=$(awk '{print $2;}' <<< "$PCACHE")

  egrep 'dev' &> /dev/null <<< "$PDATA_SOURCE"
  if [ $? -ne 0 ]; then
    f_t
    echo "Data partiton isn't on a device? $PDATA_SOURCE does not include dev"
    r_t
    exit 1
  fi

  egrep 'dev' &> /dev/null <<< "$PCACHE_SOURCE"
  if [ $? -ne 0 ]; then
    f_t
    echo "Cache partiton isn't on a device? $PCACHE_SOURCE does not include dev"
    r_t
    exit 1
  fi

  break_t
  # targets path
  PDATA_PATH=$(awk '{print $3;}' <<< "$PDATA")
  PCACHE_PATH=$(awk '{print $3;}' <<< "$PCACHE")

  # existing files in our path count
  PDATA_FCOUNT=$(ls -a $PDATA_PATH | wc -w)
  PCACHE_FCOUNT=$(ls -a $PCACHE_PATH | wc -w)

  if [ $PDATA_FCOUNT -gt 4 ]; then
    f_t
    echo "Data partition not empty"
    exit 1
    r_t
  else
    r_t
    echo -n "Path of auto detected data partiton: "
    p_t
    echo $PDATA_PATH
  fi

  if [ $PCACHE_FCOUNT -gt 4 ]; then
    f_t
    echo "Cache partition not empty"
    exit 1
    r_t
  else
    r_t
    echo -n "Path of auto detected cache partiton: "
    p_t
    echo $PCACHE_PATH
  fi
r_t
}

sequence

# Exception handler

#if [ $? -eq 0 ]; then
  # exit 255
#fi
