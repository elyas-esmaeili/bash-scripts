#!/bin/bash
# organize my images and videos 

SRC=$1
DST=$2

# function definition - start

copy() {
    FILENAME=$1
    TO=$2
    if [ ! -d "$TO" ]; then
       mkdir -p "$TO"
    fi
    cp $FILENAME "$TO"
}

organize () {
   local NAME=$1
   if  [ -f "$NAME" ]; then
       MODDATE=`date +"%Y" -r $NAME`
       LNAME=${NAME,,}

       if [[ $LNAME =~ .*\.(jpg|jpeg|jpg)$ ]]; then
           copy $NAME "$DST/$MODDATE/photos"
       elif [[ $LNAME =~ .*\.(mov|wmv|mkv|mpeg|3gp|avi|mp4)$ ]]; then
           copy $NAME "$DST/$MODDATE/videos"
       fi

   else
       for UNKNOWN in $(ls $NAME)
       do
           organize "$NAME/$UNKNOWN"
       done
   fi
}

# function definition - end

# script - start 
if [ ! -d "$DST" ]; then
    mkdir -p "$DST"
fi

organize $SRC
# script - end
