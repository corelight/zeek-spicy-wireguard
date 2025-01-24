# @TEST-EXEC: zeek -C -r ${TRACES}/tailscale_linux.pcap %INPUT
# @TEST-EXEC: zeek-cut -m -n local_orig local_resp ip_proto < conn.log > conn.log.filtered
# @TEST-EXEC: btest-diff conn.log.filtered
# @TEST-EXEC: btest-diff .stdout
#
# @TEST-DOC: Test Tailscale analyzer with sample trace.

@load analyzer

event Wireguard::packet_data(c: connection, is_orig: bool, receiver_index: count, key_counter: count, encapsulated_packet_length: count)
	{
	print "packet_data", receiver_index, encapsulated_packet_length;
	}

event Wireguard::tailscale_discovery_message(c: connection, is_orig: bool, senderDiscoPub: string)
	{
	print "discovery_message", senderDiscoPub;
	}
