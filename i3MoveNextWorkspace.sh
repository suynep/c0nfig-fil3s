#!/bin/bash

wsNext=$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + $1))

if [ $wsNext -ge 1 ]; then 
  i3-msg move container to workspace $wsNext
  i3-msg workspace $wsNext
else
  i3-msg move container to workspace number "4"
  i3-msg workspace number "4"
fi

if [ $wsNext -le 4 ]; then 
  i3-msg move container to workspace $wsNext
  i3-msg workspace $wsNext
else
  i3-msg move container to workspace number "1"
  i3-msg workspace number "1"
fi

if [ $wsNext == 0 ]; then
  i3-msg move container to workspace number "4"
  i3-msg workspace number "4"
fi

if [ $wsNext == 5 ]; then
  i3-msg move container to workspace number "1"
  i3-msg workspace number "1"
fi
