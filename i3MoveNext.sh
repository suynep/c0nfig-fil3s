#!/bin/bash
#

MAX=5

wsNext=$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + $1))
if [ $wsNext -ge 1 ]; then 
  i3-msg workspace $wsNext &
else
  i3-msg workspace number "$MAX" &
fi

if [ $wsNext -le $MAX ]; then 
  i3-msg workspace $wsNext & 
else
  i3-msg workspace number "1" &
fi

if [ $wsNext == 0 ]; then
  i3-msg workspace number "$MAX" &
fi
