use strict;
use warnings;
use Test::More;
use IO::Socket::IP;

my $server = IO::Socket::IP->new(
    LocalHost => '::',
    LocalPort => 8334,
    ReuseAddr => 1,
    Listen => 20,
    Proto => 'tcp',
) or die "server: $!";

system "netstat -an >&2";

for my $host ('::', '::1', '0.0.0.0', '127.0.0.1') {
    my $client = IO::Socket::IP->new(
        PeerHost => $host,
        PeerPort => 8334,
    );
    if ($client) {
        diag "$host OK";
        close $client;
    } else {
        diag "$host NG, $!";
    }
}
pass;

done_testing;
