#!/bin/sh

#configure led device path
LEDDIR=/sys/devices/platform/leds/leds
CONFIG=/root/led_list.cfg
OUTPUT=/root/leds/

if [ ! -f $CONFIG ]; then
    echo "Configuration file not found!"
    echo "Please check $CONFIG"
    exit 1
fi


if [ $# -eq 0 ]
  then echo "There should be an argument! Possible arguments are: restore disable"
  echo "exiting..."
  exit 1
elif [ $# -gt 1 ]
  then echo "There should be only one argument! Possible arguments are: -restore -disable"
  exit 1
fi

disable () {
  echo "Deleting old files!"
  /bin/rm $OUTPUT/*.out
  echo "Creating new backup files!"
  for led in $(cat $CONFIG); do
    TRIGGER=$(cat $LEDDIR/$led/trigger | /usr/bin/awk -F "]" '{print $1}' | /usr/bin/awk -F "[" '{print $2}')
    if [ $TRIGGER == "none" ]
      then
        if [ $(cat $LEDDIR/$led/brightness) -gt 0 ]
          then cat $LEDDIR/$led/brightness > $OUTPUT/${led}_brightness.out
          echo 0 > $LEDDIR/$led/brightness
        fi
    else
      echo $TRIGGER > $OUTPUT/${led}_trigger.out
      LEDNAME=$(echo $led | /usr/bin/awk -F ":" '{print $3}')
      LANINNAME=$(echo $LEDNAME | /bin/grep -c lan)
      if [ $LANINNAME -gt 0 ]
        then cat $LEDDIR/$led/brightness > $OUTPUT/${led}_brightness.out
      fi
    fi

    echo "Disabling LED $led !"
    echo "none" > $LEDDIR/$led/trigger
  done
}

restore () {
  echo "restoring!"
  for led in $(cat $CONFIG); do
    if [ -f $OUTPUT/${led}_brightness.out ]
      then cat $OUTPUT/${led}_brightness.out > $LEDDIR/$led/brightness
    fi
    if [ -f $OUTPUT/${led}_trigger.out ]
      then cat $OUTPUT/${led}_trigger.out > $LEDDIR/$led/trigger
    fi
  done
}

if [ $1 == "disable" ]
  then echo "disabling leds, saving configuration..."
  disable
elif [ $1 == "restore" ]
  then echo "restoring led configration, enabling leds"
  restore
else
  echo "Sorry I don't know that option!"
  exit 1
fi
