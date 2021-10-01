#!/bin/bash

nordvpn_c_result=$(nordvpn c)

# Discord notification settings
# Set discord_notif_enabled to false to disable discord notifications
discord_notif_enabled=true
discord_webhook=https://discord.com/api/webhooks/INSERT_WEBHOOK_HERE

# sends discord message using webhook
# params: $1 = discord message
function discord_notif () {
  curl -sS \
    -H "Content-Type: application/json" \
    -d "{\"username\": \"$discord_username\", \"content\": \"$1\"}" \
    $discord_webhook

  echo "$1"
}

nordvpn_status=$(nordvpn status)

# nordvpn could not connect... reboot host
if ! grep -e "Status: Connected" <<< "$nordvpn_status"; then
  if [ "$discord_notif_enabled" = true ]; then
    discord_notif "NordVPN reconnect failed... Please reboot host!"
  fi
else
  if [ "$discord_notif_enabled" = true ]; then
    discord_notif "NordVPN reconnect successful"
  fi
fi
