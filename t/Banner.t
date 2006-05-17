use Test::More tests => 1;
BEGIN { use_ok('Net::Scan::SMTP::Banner') };

my $host = "127.0.0.1";

my $scan = Net::Scan::SMTP::Banner->new({
	host    => $host,
	timeout => 5,
	debug   => 1
});

my $results = $scan->scan;

print "$host $results\n" if $results;

exit(0);
