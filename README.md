This is a simple script for openwrt to disable and reenable leds.
Test on a TP-LINK Archer C7 with 19.07.7:
```shell
# cat /etc/openwrt_release
DISTRIB_ID='OpenWrt'
DISTRIB_RELEASE='19.07.7'
DISTRIB_REVISION='r11306-c4a6851c72'
DISTRIB_TARGET='ath79/generic'
DISTRIB_ARCH='mips_24kc'
DISTRIB_DESCRIPTION='OpenWrt 19.07.7 r11306-c4a6851c72'
DISTRIB_TAINTS=''
```

Howto:
Create a file with the leds that you want to control, a sample can be found with the filename led_list.cfg
Put the file in a directory that you want to use with the script ledcontrol.sh and edit the CONFIG and OUTPUT parameters in the shell script. OUTPUT is used to store the led states in files ad disable to be used when you hit restore.
Then you can create a crontab entry to:
Disable the leds:
ledcontrol.sh disable
To enable the leds (restore the state):
ledcontrol.sh restore

In V21 "tp-link:" was removed from the led sys urls.

Crontab:
```shell
# crontab -l
0 19 * * * /root/ledcontrol.sh disable
0 6 * * * /root/ledcontrol.sh restore
```

TODO / Known Issues
- Had to check LAN ports name as they won't be enabled when you set the trigger state (probably triggers only when port state changes). There might be other cases like this, that I don't know of yet. So the script will enable them back via setting brightness.
