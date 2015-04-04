#!/bin/bash

# Resource treshold
min_gold=75000
min_drops=75000
min_total=150000

# Get image
function getdata {
  ./screencap.sh /tmp/screen.png
  convert /tmp/screen.png -fill Black +opaque "#fffbcc" -fill White -opaque "#fffbcc" /tmp/out-gold.png
  convert /tmp/screen.png -fill Black +opaque "#ffe8fd" -fill White -opaque "#ffe8fd" /tmp/out-drops.png
  gold=`tesseract -psm 7 /tmp/out-gold.png stdout digits | tr -d " "`
  drops=`tesseract -psm 7 /tmp/out-drops.png stdout digits | tr -d " "`
}

function tap_next {
  adb shell input tap 1750 750
}

function found {
    echo This one is interesting
    for i in {1..5}
    do
      echo Ding!!
      mpg321 -q sound2.mp3
    done
}

gold="0"
drops="0"

while true
do
  echo Getting data...
  for i in {1..5}
  do
    getdata
    if [ "$gold" != "-" ] && [ "$drops" != "-"  ]; then
      break
    fi
    #sleep 1
  done

  if [ "$gold" == "-" ] || [ "$drops" == "-" ]; then
      echo reading failed after 5 tries
      continue
  fi

  echo Found: $gold $drops

  total=$(echo $(($gold + $drops)))

  if [ "$gold" -ge "$min_gold" ] && [ "$drops" -ge "$min_drops" ]
  then
    found
    break
  fi

  if [ "$total" -ge "$min_total" ]
  then
    found
    break
  fi

  echo Not enough resources...
  echo
  #sleep 1
  tap_next

done

#rm /tmp/screen.png /tmp/out*.png
