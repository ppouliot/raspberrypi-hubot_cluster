#!/bin/bash

  # Disable APIPA addresses on ethpiX and eth0
  # This being moved to ansible
  # echo -e "# ClusterHAT\ndenyinterfaces eth0 ethpi1 ethpi2 ethpi3 ethpi4" >> /etc/dhcpcd.conf

  # Ensure we're going to do a text boot
   systemctl set-default multi-user.target

  # Enable Cluster HAT init
  sed -i "s#^exit 0#/sbin/clusterhat init\nexit 0#" /etc/rc.local

  # Enable uart
  lua - enable_uart 1 /boot/config.txt <<EOF > /boot/config.txt.bak
  local key=assert(arg[1])
  local value=assert(arg[2])
  local fn=assert(arg[3])
  local file=assert(io.open(fn))
  local made_change=false
  for line in file:lines() do
    if line:match("^#?%s*"..key.."=.*$") then
      line=key.."="..value
      made_change=true
    end
    print(line)
  end
  if not made_change then
    print(key.."="..value)
  end
EOF
  mv /boot/config.txt.bak /boot/config.txt

  # Enable I2C (used for I/O expander on Cluster HAT v2.x)
  lua - dtparam=i2c_arm on /boot/config.txt <<EOF > /boot/config.txt.bak
  local key=assert(arg[1])
  local value=assert(arg[2])
  local fn=assert(arg[3])
  local file=assert(io.open(fn))
  local made_change=false
  for line in file:lines() do
    if line:match("^#?%s*"..key.."=.*$") then
      line=key.."="..value
      made_change=true
    end
    print(line)
  end
  if not made_change then
    print(key.."="..value)
  end
EOF
  mv /boot/config.txt.bak /boot/config.txt
  if [ -f /etc/modprobe.d/raspi-blacklist.conf ];then
   sed /etc/modprobe.d/raspi-blacklist.conf -i -e "s/^\(blacklist[[:space:]]*i2c[-_]bcm2708\)/#\1/"
  fi
  sed /etc/modules -i -e "s/^#[[:space:]]*\(i2c[-_]dev\)/\1/"

  if ! grep -q "^i2c[-_]dev" /etc/modules; then
   printf "i2c-dev\n" >> /etc/modules
  fi

  # Change the hostname to "controller"
  sed -i "s#^127.0.1.1.*#127.0.1.1\tcontroller#g" /etc/hosts
  echo "controller" > /etc/hostname

  # Extract files
  #(tar --exclude=.git -zcC ../files/ -f - .) | ( tar -zxC /)

  # Copy network config files
  cp -f /$CONFIGDIR/interfaces.c /etc/network/interfaces

  # Disable the auto filesystem resize
  sed -i 's/ quiet init=.*$//' /boot/cmdline.txt

  # Setup config.txt file
  C=`grep -c "dtoverlay=dwc2" /boot/config.txt`
  if [ $C -eq 0  ];then
   echo -e "# Load overlay to allow USB Gadget devices\n#dtoverlay=dwc2" >> /boot/config.txt
  fi

  PARTUUID=`sed "s/.*PARTUUID=\(.*\) rootfstype.*/\1/" /boot/cmdline.txt`

   apt-get -y autoremove --purge
   apt-get clean
