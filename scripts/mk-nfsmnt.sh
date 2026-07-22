#!/bin/sh
# mk-nfsmnt.sh
# create a
# Usage: mk-mount.sh <name> <path>

if [ $# -ne 2 ]; then
	echo "usage: $0 <name> <path>"
	echo ""
	echo "name: the name of the folder under /mnt"
	echo "path: the full nfs string example.com:/path/to/volume"
	exit 0
fi

name="$1"
path="$2"

# Generate .mount file
cat >"mnt-${name}.mount" <<EOF
[Unit]
Description=Mount ${name}
After=network-online.target
Wants=network-online.target

[Mount]
What=${path}
Where=/mnt/${name}
Type=nfs
Options=defaults,_netdev

[Install]
WantedBy=multi-user.target
EOF

# Generate .automount file
cat >"mnt-${name}.automount" <<EOF
[Unit]
Description=Automount ${name}
After=network-online.target

[Automount]
Where=/mnt/${name}
TimeoutIdleSec=600

[Install]
WantedBy=multi-user.target
EOF

echo "Created mnt-${name}.mount and mnt-${name}.automount"
