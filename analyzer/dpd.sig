signature wireguard_packet {
  ip-proto == udp
  payload /^(\x01|\x02|\x03)\x00\x00\x00.{144}/
  enable "spicy_Wireguard"
}

signature tailscale_packet {
  ip-proto == udp
  payload /^\x54\x53\xf0\x9f\x92\xac/
  enable "spicy_Tailscale"
}
