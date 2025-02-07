# Install Xray
mkdir -p /var/log/xray /usr/share/xray /etc/xray

wget -O /usr/share/xray/geosite.dat https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
wget -O /usr/share/xray/geoip.dat https://github.com/v2fly/geoip/releases/latest/download/geoip.dat

mkdir -p /tmp/xray
cd /tmp/xray
wget -O xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip xray.zip
mv xray /usr/bin
chown opc:opc -R /var/log/xray /usr/share/xray /etc/xray  /usr/bin/xray
rm -rf /tmp/xray

temp_CapabilityBoundingSet="CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE"
temp_AmbientCapabilities="AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE"
temp_NoNewPrivileges="NoNewPrivileges=true"

cat << EOF > /etc/systemd/system/xray.service
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=opc
${temp_CapabilityBoundingSet}
${temp_AmbientCapabilities}
${temp_NoNewPrivileges}
ExecStart=/usr/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

xray_uuid=$(xray uuid)
xray_shortid=$(openssl rand -hex 8)
xray_key=$(xray x25519)
xray_private_key=$(echo "$xray_key" | grep 'Private key' | cut -d ' ' -f 3)
xray_public_key=$(echo "$xray_key" | grep 'Public key' | cut -d ' ' -f 3)

cat << EOF > /etc/xray/config.json
{
    "log": {
        "loglevel": "warning",
        "access": "/var/log/xray/access.log",
        "error": "/var/log/xray/error.log"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 22090,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "${xray_uuid}",
                        "flow": "xtls-rprx-vision",
                        "email": "reality@monkeyray.net"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "show": false,
                    "dest": "swcdn.apple.com:443",
                    "minClientVer": "1.8.4",
                    "fingerprint": "chrome",
                    "serverNames": ["swcdn.apple.com"],
                    "privateKey": "${xray_private_key}",
                    "shortIds": ["${xray_shortid}"]
                }
            },
            "sniffing": {
                "enabled": true,
                "destOverride": ["http", "tls", "quic"],
                "routeOnly": true
            }
        }
    ],
    "outbounds": [
        {
            "tag": "direct", 
            "protocol": "freedom"
        }, 
        {
            "tag": "blocked", 
            "protocol": "blackhole", 
            "settings": { }
        }
    ],
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "rules": [
            {
                "type": "field",
                "outboundTag": "block",
                "protocol": ["bittorrent"]
            },
            {
                "type": "field",
                "ip": ["geoip:private"],
                "outboundTag": "block"
            }
        ]
    },
    "policy": {
        "levels": {
            "0": {
                "handshake": 2,
                "connIdle": 120
            }
        }
    }
}
EOF

echo "#####################################"
echo "xray uuid = ${xray_uuid}"
echo "xray private key = ${xray_private_key}"
echo "xray public key = ${xray_public_key}"
echo "xray shortid = ${xray_shortid}"
echo "#####################################"

systemctl start xray
systemctl status xray
systemctl enable xray
