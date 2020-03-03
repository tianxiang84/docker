#!/bin/bash
exitFunc(){
        echo 'Existing'
	ls
        exit 0
}

trap exitFunc SIGTERM
#trap 'echo 'Exiting'' SIGTERM
while true; do :; done
