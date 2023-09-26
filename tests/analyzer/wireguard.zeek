# @TEST-EXEC: zeek -C -r ${TRACES}/wireguard.pcap %INPUT
# @TEST-EXEC: cat conn.log | zeek-cut -m -n local_orig local_resp >conn.log.filtered
# @TEST-EXEC: btest-diff conn.log.filtered
# @TEST-EXEC: btest-diff wireguard.log
# @TEST-EXEC: btest-diff .stdout

@load analyzer

event Wireguard::handshake_initiation(c: connection, is_orig: bool, sender_index: count, unencrypted_ephemeral: string, encrypted_static: string, encrypted_timestamp: string, mac1: string, mac2: string)
	{
	print "Handshake initiation", sender_index, mac2;
	}

event Wireguard::handshake_response(c: connection, is_orig: bool, sender_index: count, receiver_index: count, unencrypted_ephemeral: string, encrypted_nothing: string, mac1: string, mac2: string)
	{
	print "Handshake response", sender_index, receiver_index;
	}

event Wireguard::packet_cookie_reply(c: connection, is_orig: bool, receiver_index: count, nonce: string, encrypted_cookie: string)
	{
	print "packet_cookie_reply", receiver_index;
	}

event Wireguard::packet_data(c: connection, is_orig: bool, receiver_index: count, key_counter: count, encapsulated_packet_length: count)
	{
	print "packet_data", receiver_index, encapsulated_packet_length;
	}
