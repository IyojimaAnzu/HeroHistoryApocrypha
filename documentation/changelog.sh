#!/bin/bash
# script for recording to changelog with timestamp and doing text to speech
tail changelog.txt
echo -n "> "
while IFS=  read -r; do
  # TODO figure out how to put in prompt character echo "> "
  line=$REPLY
  echo $(date +%Y/%m/%d\ %H:%M:%S) $line >> changelog.txt
  tail changelog.txt
  echo -n "> "
  echo $line |espeak-ng -ven+f4 -w /tmp/out.wav; aplay -q /tmp/out.wav 
done
