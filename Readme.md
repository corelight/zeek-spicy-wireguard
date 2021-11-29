# zeek-spicy-wireguard

This package provides a Spicy based Wireguard protocol analyzer
for Zeek.

You must install [Spicy](https://docs.zeek.org/projects/spicy/en/latest/)
to use this package.

This is a straightforward implementation following <https://www.wireguard.com/protocol/>

## Wireguard

### Wireguard Logs

```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	conn
#open	2021-11-24-18-10-11
#fields	ts	uid	id.orig_h	id.orig_p	id.resp_h	id.resp_p	proto	service	duration	orig_bytes	resp_bytes	conn_state	local_orig	local_resp	missed_bytes	history	orig_pkts	orig_ip_bytes	resp_pkts	resp_ip_bytes	tunnel_parents
#types	time	string	addr	port	addr	port	enum	string	interval	count	count	string	bool	bool	count	string	count	count	count	count	set[string]
1611583877.627931	CHhAvVGS1DHFjwGM9	188.166.170.114	45965	188.166.170.115	51194	udp	spicy_wireguard	35.595192	13516	14924	SF	-	-	0	Dd	90	16036	82	17220	-
#close	2021-11-24-18-10-11
```

```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	wireguard
#open	2021-11-24-18-10-11
#fields	ts	uid	id.orig_h	id.orig_p	id.resp_h	id.resp_p	established	initiations	responses
#types	time	string	addr	port	addr	port	bool	count	count
1611583877.627931	CHhAvVGS1DHFjwGM9	188.166.170.114	45965	188.166.170.115	51194	T	1	1
#close	2021-11-24-18-10-11
```

### Wireguard PCAP Source

- wireguard.pcap (self-made)

This package also detects...

## Tailscale

[Tailscale](https://tailscale.com/) is a VPN that modifies the Wireguard protocol
slightly by adding Tailscale discovery messages.  While the generic Wireguard protocol
analyzer in this repo will not support this, this protocol analyzer will.

Relevant code section: <https://github.com/tailscale/tailscale/blob/main/disco/disco.go#L32>

### Tailscale Logs

```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	conn
#open	2021-11-24-18-11-40
#fields	ts	uid	id.orig_h	id.orig_p	id.resp_h	id.resp_p	proto	service	duration	orig_bytes	resp_bytes	conn_state	local_orig	local_resp	missed_bytes	history	orig_pkts	orig_ip_bytes	resp_pkts	resp_ip_bytes	tunnel_parents
#types	time	string	addr	port	addr	port	enum	string	interval	count	count	string	bool	bool	count	string	count	count	count	count	set[string]
1623328901.893092	CHhAvVGS1DHFjwGM9	192.168.88.3	41641	18.196.71.179	41641	udp	spicy_tailscale	31.882638	5700	6322	SF	-	-	0	Dd	51	7128	56	7890	-
#close	2021-11-24-18-11-40
```

### Tailscale PCAP Source

- tailscale_linux.pcap (self-made)
