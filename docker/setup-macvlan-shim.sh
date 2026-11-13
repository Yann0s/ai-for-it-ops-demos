#!/bin/bash
# ──────────────────────────────────────────────────────────────
# Macvlan shim pour ubu1
# Par défaut, l'hôte ne peut pas joindre les conteneurs macvlan.
# Ce script crée une sous-interface macvlan sur l'hôte pour
# rétablir la connectivité hôte ↔ conteneurs Dockur.
#
# Exécuter UNE SEULE FOIS sur ubu1 après avoir lancé docker compose.
# ──────────────────────────────────────────────────────────────

HOST_IFACE="eno1"               # ← ADAPTER : interface physique (ip link show)
SHIM_IFACE="macvlan-host"
SHIM_IP="192.168.1.250"         # IP libre sur le LAN, hors ip_range Docker
VM_SUBNET="192.168.1.240/28"    # plage des conteneurs Dockur

set -e

echo "Création de l'interface shim $SHIM_IFACE sur $HOST_IFACE..."

sudo ip link add "$SHIM_IFACE" link "$HOST_IFACE" type macvlan mode bridge
sudo ip addr add "$SHIM_IP/32" dev "$SHIM_IFACE"
sudo ip link set "$SHIM_IFACE" up
sudo ip route add "$VM_SUBNET" dev "$SHIM_IFACE"

echo "✓ Interface shim active. ubu1 peut maintenant joindre les conteneurs."
echo "  Ping DC  : ping 192.168.1.241"
echo "  Ping Win11: ping 192.168.1.242"
echo "  Console DC web : http://192.168.1.241:8006"
echo "  RDP DC         : mstsc /v:192.168.1.241"
echo ""
echo "⚠ Ce setup n'est PAS persistant au reboot. Pour le rendre permanent :"
echo "   → ajouter dans /etc/network/interfaces ou un service systemd"
echo "   → ou relancer ce script après reboot"