# otp-vpn – Anleitung

## Voraussetzungen

Folgende Tools müssen installiert sein:
- **oathtool** – zur Berechnung des TOTP-Codes
- **nmcli** – NetworkManager Command Line Interface

Installation unter Debian/Ubuntu:
```bash
sudo apt install oathtool network-manager
```

---

## Verzeichnisstruktur

```
~/.config/otp-manager/
└── account_IAFN.conf
```

---

## Konfigurationsdatei anlegen

```bash
mkdir -p ~/.config/otp-manager
nano ~/.config/otp-manager/account_IAFN.conf
```

Inhalt der Datei – eine Zeile pro Profil, Felder mit `|` getrennt:
```
IAFN|DEIN_TOTP_SECRET|FesterPasswortTeil|vpn-benutzername
```

| Feld | Bedeutung |
|---|---|
| `IAFN` | Name des NetworkManager-VPN-Profils |
| `DEIN_TOTP_SECRET` | Base32-Secret aus der TOTP-Konfiguration |
| `FesterPasswortTeil` | Fixer Bestandteil des Passworts |
| `vpn-benutzername` | VPN-Login-Name |

---

## VPN-Profil importieren

Das OVPN-Profil muss einmalig in den NetworkManager importiert werden:
```bash
nmcli connection import type openvpn file /pfad/zur/datei.ovpn
```

Anschließend das Profil umbenennen:
```bash
nmcli connection modify "Alter Name" connection.id IAFN
```

---

## Skript installieren

```bash
chmod +x launch_ovpn_profile.sh
sudo cp launch_ovpn_profile.sh ~/.local/bin/otp-vpn.sh
```

---

## Verwendung

**VPN verbinden:**
```bash
otp-vpn.sh connect
```

**VPN trennen:**
```bash
otp-vpn.sh disconnect
```

---

## Fehlermeldungen

| Meldung | Ursache |
|---|---|
| `VPN-Profil '...' nicht gefunden. Abbruch.` | Profil nicht im NetworkManager vorhanden → OVPN-Datei importieren |
| `VPN-Verbindung '...' ist bereits aktiv.` | Verbindung läuft schon, keine Aktion nötig |
| `VPN-Profil '...' ist nicht aktiv.` | Beim Trennen war keine Verbindung aktiv |
