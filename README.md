# buat opnevpn
cd /usr/local/src
sudo wget https://git.io/vpn -O openvpn-install.sh
sudo chmod +x openvpn-install.sh
sudo ./openvpn-install.sh

# download file openvpn ke lokal/clinet
scp USER@IP_ADDRESS:/usr/local/src/NAMA_FILE.ovpn .
