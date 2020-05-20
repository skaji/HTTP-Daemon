use strict;
use warnings;
use Test::More;
use IO::Socket::IP;
use Socket ();

my $server = IO::Socket::IP->new(
    LocalHost => '::',
    LocalPort => 8334,
    ReuseAddr => 1,
    Listen => 30,
    Proto => 'tcp',
) or die "server: $!";

my @inet6;
for my $line (`/sbin/ifconfig | grep inet6`) {
    if ($line =~ /inet6\s+(\S+)/) {
        push @inet6, $1;
    }
}

system "netstat -an >&2";

my $addr6 = Socket::inet_ntop Socket::AF_INET6, Socket::IN6ADDR_LOOPBACK;
my $addr4 = Socket::inet_ntop Socket::AF_INET, Socket::INADDR_LOOPBACK;
for my $host ('::', '::1', $addr6, '0.0.0.0', '127.0.0.1', $addr4, @inet6) {
    my $client = IO::Socket::IP->new(
        PeerHost => $host,
        PeerPort => 8334,
        Timeout => 2,
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
