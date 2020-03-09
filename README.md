# dStor Outpost Quickstart Install (v0.0.3-develop22)

*Note: This is a work in progress undergoing continuous, rapid development.* 


## Table of Contents

- [Requirements](#Requirements)
- [Usage](#usage)
- [Notes](#notes)
- [Support](#support)
- [Contributing](#contributing)
- [License](#license)

## Requirements

### Processor
Intel i3 dual core @ 2Ghz or better. (Operators may be able to use a lesser system, but it is not supported.)

### OS
Ubuntu Linux version 18.04 LTS or later LTS version.

### Memory
8Gb Ram.  More is better.

### Network
IPv6 is _required_. NAT-ed IPv4 is acceptable for basic needs. A public IPv4 address assigned to a local interface is needed if you want to resolve IPv4 requests for dStor too.  Resolving IPv4 requests for dStor is optional but may lead to more data service.

### Storage
Partitions must be empty and mounted somewhere that is reboot proof.  XFS is recommended, however ZFS, EXT4 and other file systems should be ok.

#### Data Partition
2 TiB in size (or more) and the mount point's final subpath must end in `data`.

Example: `/mnt/dstor/outpost-data` OR `/data`

#### Cache Partition
The cache partition must be 20% in size of the data partition (or more) and its mount point final subpath must end in `cache`.

Example: `/mnt/dstor/outpost-cache` OR `/cache`



## Usage

### Quickstart
```
# Format and mount your /data and /cache partitions somewhere ( don't forget fstab! )

sudo apt install jq curl nginx miller certbot uuid-runtime busybox net-tools build-essential python3-certbot-nginx
sudo snap install go --classic

sudo systemctl stop nginx
sudo systemctl disable nginx

# Create your service user on your data partition and then use apparmor to allow the folder as a home folder
# Add the parent home folder to app armor ( "/data" in this case )
sudo dpkg-reconfigure apparmor

sudo groupadd dstor-outpost

# dstor only needs sudo access during the install and can be safely removed later
sudo useradd -d /data/dstor-outpost -g dstor-outpost -G sudo -m -s /bin/bash dstor-outpost

# Set the dstor-outpost users password to something temp and exp
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1

sudo passwd dstor-outpost && sudo passwd -x 1 dstor-outpost

sudo -i -u dstor-outpost
git clone https://github.com/goodblockio/dstor-outpost-quickstart.git --depth 1
cd dstor-outpost-quickstart
./start_here
```


## Notes

### Ubuntu 18.04.4/20.04 does not have a default mapping for Python
Ubuntu is currently moving from Python 2 to Python 3 as its default Python installation.  With Ubuntu 20.04, the environment shell script can't find "python" because it hasn't been mapped to a default Python 3.  To fix this run:
```
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
```


## Support

Please [open an issue](https://github.com/goodblockio/dstor-outpost-quickstart/issues/new) for support.

## Contributing

Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/goodblockio/dstor-outpost-quickstart/compare/).

## License

Except where underlying software is open source, this proprietary software is the property of Horn of the Moon LLC, a Washington State limited liability company DBA GoodBlock. It is only licensed for usage by express written agreements.


-----
(c) dStor 2020 ON2GK4DIMFXGSZJOGIYDEMBNGAZS2MBZEAYDKORTGE5DIMZOGI3TGOJYGQ======

