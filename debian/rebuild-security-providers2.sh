#!/bin/bash
# Rebuild the list of java security providers

for path in java-*-oracle; do
  secfile=/etc/${path}/security/java.security
  # check if this security file exists
  [ -f "$secfile" ] || continue

  sed -i '/^security\.provider\./d' "$secfile"

  count=0

  for provider in $(ls /etc/${path}/security/security.d)
  do
    count=$((count + 1))
    echo "security.provider.${count}=${provider#*-}" >> "$secfile"
  done

  if [ -d /etc/java/security/security.d ]; then
    for provider in $(ls /etc/java/security/security.d)
    do
      count=$((count + 1))
      echo "security.provider.${count}=${provider#*-}" >> "$secfile"
    done
  fi

done
