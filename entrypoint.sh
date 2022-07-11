#!/bin/sh

UUID=f9455340-8789-44bf-98ef-6cd15b82453b
WSPATH=/1ebad031-b5fd-4dd5-aa31-110fe1181e95


# Download and install xray
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray

# Remove temporary directory
rm -rf /tmp/xray

# xray new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
  "log": {
    "loglevel": "none"
  },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "VLESS",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "alterId": 0
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${WSPATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Run xray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json
