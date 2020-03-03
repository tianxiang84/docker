#!/bin/bash
exitFun(){
  echo 'Ending wine container...'
  exit 0
}
trap exitFun exit SIGTERM

echo 'Starting wine container...'
wineboot -u
winetricks vb6run
/bin/bash
#while true; do :; done
