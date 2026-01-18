# #!/bin/bash
# #
# 
# MAX=5
# 
# wsNext=$(( $( i3-msg -t get_workspaces | jq '.[] | select(.focused).num' ) + $1))
# 
# if [ $wsNext -ge 1 ]; then 
#   i3-msg move container to workspace $wsNext
#   i3-msg workspace $wsNext
# else
#   i3-msg move container to workspace number "$MAX"
#   i3-msg workspace number "$MAX"
# fi
# 
# if [ $wsNext -le $MAX ]; then 
#   i3-msg move container to workspace $wsNext
#   i3-msg workspace $wsNext
# else
#   i3-msg move container to workspace number "1"
#   i3-msg workspace number "1"
# fi
# 
# if [ $wsNext == 0 ]; then
#   i3-msg move container to workspace number "$MAX"
#   i3-msg workspace number "$MAX"
# fi
# 
# if [ $wsNext == $MAX+1 ]; then
#   i3-msg move container to workspace number "1"
#   i3-msg workspace number "1"
# fi

#!/bin/bash

MAX=5
DELTA=${1:-0}

current=$(i3-msg -t get_workspaces | jq '.[] | select(.focused).num')
wsNext=$(( current + DELTA ))

# wrap-around logic
if [ "$wsNext" -lt 1 ]; then
  wsNext=$MAX
elif [ "$wsNext" -gt "$MAX" ]; then
  wsNext=1
fi

i3-msg move container to workspace number "$wsNext"
i3-msg workspace number "$wsNext"

