# This is a script to mount a folder into a running container
# Ref: https://jpetazzo.github.io/2015/01/13/docker-mount-dynamic-volumes/
# Requirement: nsenter installed (ns stands for name space)
# Example usage: ./mountNewDir.sh container_name path
#!/bin/sh

set -e
CONTAINER=$1
HOSTPATH=$2
CONTPATH=$HOSTPATH
REALPATH=$(readlink --canonicalize $HOSTPATH)
FILESYS=$(df -P $REALPATH | tail -n 1 | awk '{print $6}')
#echo $REALPATH
#echo $FILESYS

while read DEV MOUNT JUNK
do [ $MOUNT = $FILESYS ] && break
done </proc/mounts
[ $MOUNT = $FILESYS ] # Sanity check!

while read A B C SUBROOT MOUNT JUNK
do [ $MOUNT = $FILESYS ] && break
done < /proc/self/mountinfo
[ $MOUNT = $FILESYS ] # Moar sanity check!

SUBPATH=$(echo $REALPATH | sed s,^$FILESYS,,)
DEVDEC=$(printf "%d %d" $(stat --format "0x%t 0x%T" $DEV))
#echo $SUBPATH
#cho $DEV
#echo $(stat --format "0x%t 0x%T" $DEV)
#echo $DEVDEC

docker-enter $CONTAINER sh -c \
	     "[ -b $DEV ] || mknod --mode 0600 $DEV b $DEVDEC"
docker-enter $CONTAINER mkdir /tmpmnt
docker-enter $CONTAINER mount $DEV /tmpmnt
docker-enter $CONTAINER mkdir -p $CONTPATH
docker-enter $CONTAINER mount -o bind /tmpmnt/$SUBROOT/$SUBPATH $CONTPATH
docker-enter $CONTAINER umount /tmpmnt
docker-enter $CONTAINER rmdir /tmpmnt
docker-enter $CONTAINER atom -a $CONTPATH # add the folder to atom
