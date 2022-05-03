module Wireguard;

export {
	redef enum Log::ID += { LOG };

	global log_policy: Log::PolicyHook;

	## The record type which contains the fields of the Wireguard log.
	## Wireguard purposefully contains only very limited information. As such, the only
	## things that we record in the log are wireguard handshakes - since the frequency of handshakes
	## (as well as the successes of them) might be of some interest
	type Info: record {
		### Time the first packet was encountered
		ts:             time            &log &default=network_time();
		### Unique ID for the connection
		uid:            string          &log;
		## The connection's 4-tuple of endpoint addresses/ports
		id:             conn_id         &log;
		### 32 bit identifier chosen by the sender. Not logged.
		sender_index:   count           &optional;
		### Set to true if we think that a handshake was succesfully performed.
		### Please note that this flag is a bit speculative and should not be 100% relied on.
		established:    bool            &log &default=F;
		## Number of handshake initiation packets encountered during the connection
		initiations:    count           &log &default=0;
		## Number of handshake response packets we have encountered during the connection
		responses:      count           &log &default=0;
	};

	## Event that can be handled to access the Wireguard
	## record as it is sent on to the logging framework.
	global log_wireguard: event(rec: Info);

	## Event raised for the wireguard handshake_initiation packet
	global Wireguard::handshake_initiation: event(c: connection, is_orig: bool, sender_index: count, unencrypted_ephemeral: string, encrypted_static: string, encrypted_timestamp: string, mac1: string, mac2: string);

	## Event raised for the wireguard handshake_response packet
	global Wireguard::handshake_response: event(c: connection, is_orig: bool, sender_index: count, receiver_index: count, unencrypted_ephemeral: string, encrypted_nothing: string, mac1: string, mac2: string);

	## Event raised for the wireguard packet_cookie_reply packet
	global Wireguard::packet_cookie_reply:event(c: connection, is_orig: bool, receiver_index: count, nonce: string, encrypted_cookie: string);

	## Event raised for the wireguard packet_data packet
	global Wireguard::packet_data: event(c: connection, is_orig: bool, receiver_index: count, key_counter: count, encapsulated_packet_length: count);

	## Event raised for the Tailscale discovery packet
	global Wireguard::tailscale_discovery_message: event(c: connection, is_orig: bool, senderDiscoPub: string);

@ifdef ( Conn::register_removal_hook )
	## Wireguard finalization hook; wireguard information is logged in it
	global finalize_wireguard: Conn::RemovalHook;
@endif
}

redef record connection += {
	wireguard: Info &optional;
};

function set_session(c: connection)
	{
	if ( ! c?$wireguard )
		{
		c$wireguard = Info($uid=c$uid, $id=c$id);
@ifdef ( Conn::register_removal_hook )
		Conn::register_removal_hook(c, finalize_wireguard);
@endif
		}
	}

event zeek_init() &priority=5
	{
	Log::create_stream(Wireguard::LOG, [$columns=Info, $ev=log_wireguard, $path="wireguard", $policy=log_policy]);
	}

event Wireguard::handshake_initiation(c: connection, is_orig: bool, sender_index: count, unencrypted_ephemeral: string, encrypted_static: string, encrypted_timestamp: string, mac1: string, mac2: string)
	{
	set_session(c);
	c$wireguard$initiations += 1;
	c$wireguard$sender_index = sender_index;
	}

event Wireguard::handshake_response(c: connection, is_orig: bool, sender_index: count, receiver_index: count, unencrypted_ephemeral: string, encrypted_nothing: string, mac1: string, mac2: string)
	{
	set_session(c);
	c$wireguard$responses += 1;
	if ( c$wireguard?$sender_index && c$wireguard$sender_index == receiver_index )
		c$wireguard$established = T;
	}

@ifdef ( Conn::register_removal_hook )
hook finalize_wireguard(c: connection)
@else
event connection_state_remove(c: connection)
@endif
	{
	if (c?$wireguard)
		{
		Log::write(LOG, c$wireguard);
		}
	}
