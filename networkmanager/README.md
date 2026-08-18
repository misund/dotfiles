# NetworkManager hooks

System-level [NetworkManager dispatcher](https://networkmanager.dev/docs/api/latest/NetworkManager-dispatcher.html)
scripts. Unlike the rest of this repo, these are **not** managed with GNU Stow
(which only symlinks into `$HOME`) — they live in `/etc` and must be owned by
root, so they are installed imperatively.

## Install

```bash
./install.sh
```

This copies the hooks into `/etc/NetworkManager/dispatcher.d/` with root
ownership and mode `0755` (NetworkManager refuses to run dispatcher scripts that
are group/world-writable or not root-owned). It also deploys your local config
to `/etc/default/bluetooth-home-connect` (mode `0600`, root-only).

## Hooks

### `90-bluetooth-home`

Auto-connects Bluetooth device(s) when the machine joins the **home network**.
"Home" is identified by the default gateway (router) **MAC address**, so it
works for both Wi-Fi and Ethernet and ignores foreign networks — even ones that
reuse a generic `Wired connection` profile.

Configuration (router MAC allowlist and device list) is **not** stored in this
public repo — that would publish your router's MAC, which can be used to
geolocate your home via Wi-Fi location databases. Instead it lives in a local,
gitignored file that is deployed to `/etc/default/bluetooth-home-connect`.

On a new machine, just run the installer **while connected to your home
network** and it will auto-populate the config for you:

- It detects the current default gateway (router) MAC and asks you to confirm
  it as "home".
- It lists your known Bluetooth devices and lets you pick which to
  auto-connect (and trusts them so BlueZ will reconnect them).
- It writes `bluetooth-home-connect.conf` (gitignored) and deploys it.

```bash
./install.sh
```

To configure manually instead, copy the template and fill in real values before
running the installer (it will offer to keep your file):

```bash
cp bluetooth-home-connect.conf.example bluetooth-home-connect.conf
$EDITOR bluetooth-home-connect.conf
```

Config variables (see `bluetooth-home-connect.conf.example`):

- `HOME_GATEWAY_MACS` — allowlist of home router MAC addresses (lowercase).
- `BT_DEVICES` — Bluetooth device MACs to connect.

Find your home router's MAC while connected at home:

```bash
gw=$(ip route show default | awk '{print $3}' | head -n1)
ping -c1 "$gw" >/dev/null; ip neigh show "$gw" | awk '{print $5}'
```

The device(s) must already be paired and **trusted** (`bluetoothctl trust
<MAC>`) for connecting to work. The installer trusts any device you select.
