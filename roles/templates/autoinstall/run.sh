#!/bin/bash
PS3='Select Environment: '
options=("Local VM" "Other")
select opt in "${options[@]}"
do
  case "$opt" in
    "Local VM")
      echo "Is this thing on?"
      DISK=sda
      PORT=22
      HOST=192.168.122.153
      break
      ;;
    "Other")
      DISK=vda
      PORT=2222
      echo -n "HOST: "
      read HOST
      break
      ;;
    *) echo Invalid;;
  esac
done
echo DISK="$DISK", PORT="$PORT", HOST="$HOST"
HOST_ROOT="root@$HOST"
PUBKEY=$(cat ~/.ssh/id_rsa.pub)
# copy your public key, so can ssh without a password later on
ssh -tt -p "$PORT" "$HOST_ROOT" "mkdir -m 700 ~/.ssh; echo $PUBKEY > ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys"
# copy install scripts from ./root folder
scp -P "$PORT" ./root/* "$HOST_ROOT:/root"
# run the install script remotely
ssh -tt -p "$PORT" "$HOST_ROOT" "./install.sh $DISK"
