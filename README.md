# OpenVPN Setup & Client Configuration
## Install OpenVPN di VPS
```bash
cd /usr/local/src
# Download script installer OpenVPN
sudo wget https://git.io/vpn -O openvpn-install.sh

sudo chmod +x openvpn-install.sh

sudo ./openvpn-install.sh
```

**Instruksi di installer:**

* Pilih port (default: 1194 UDP)
* Pilih protokol UDP/TCP
* Masukkan nama user/client, installer akan membuat file `.ovpn`

---

## Download file konfigurasi `.ovpn` ke komputer lokal
```bash
scp USER@IP_VPS:/usr/local/src/NAMA_FILE.ovpn /Download
```
