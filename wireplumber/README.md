# Wireplumber listener
Lua script with a bash wrapper that subscribes to default sink events for a wireplumber session.
Intended to be used as a systemd unit to signal i3blocks when default sink properties are modified.

## Dependencies
- Wireplumber 0.5+
- i3blocks (optional if all you want is the ability to subscribe to events)

## Systemd Unit Config

```
[Unit]
Description=Wireplumber default sink event listener
BindsTo=wireplumber.service
After=wireplumber.service
StartLimitIntervalSec=30
StartLimitBurst=5

[Service]
Type=simple
ExecStartPre=/bin/sleep 2
ExecStart=%h/path/to/script
ExecStartPost=-/usr/bin/pkill
ExecStopPost=-/usr/bin/pkill
Restart=on-failure
RestartSec=2

[Install]
WantedBy=wireplumber.service
```
## Known race condition
Since the service binds to wireplumber itself, systemd's wireplumber unit may report ready and
start the listener service before your audio backend is ready.
This will likely cause the listener spawned by wpexec to fail or not correctly identify sink objects.
The arbitrary sleep before exec was the clumsy way of addressing this issue.

