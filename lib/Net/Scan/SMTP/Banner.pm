package Net::Scan::SMTP::Banner;

use 5.008006;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
use Carp;
use IO::Socket;

our $VERSION = '0.02';
$VERSION = eval $VERSION;

__PACKAGE__->mk_accessors( qw(host port timeout debug));

$| = 1;

sub scan {

	my $self    = shift;
	my $host    = $self->host;
	my $port    = $self->port    || 25;
	my $timeout = $self->timeout || 8;
	my $debug   = $self->debug   || 0;

	my $maxlen  = 1024;

	my $connect = IO::Socket::INET->new(
		PeerAddr => $host,
		PeerPort => $port,
		Proto    => 'tcp',
		Timeout  => $timeout
	);

	if ($connect) {

		my $version;
		
		$SIG{ALRM} = \&timed_out;
		eval {
			alarm($timeout);
			$connect->recv($version,$maxlen);
			close $connect;
			alarm(0);
		};

		if ($version) {
			chomp $version;
			return $version;
		}
	} else {
		return "connection refused" if $debug;
	}
}

sub timed_out {
	croak "timeout while connecting to server";
}

1;
__END__

=head1 NAME

Net::Scan::SMTP::Banner - scan for banner message from a SMTP server

=head1 SYNOPSIS

  use Net::Scan::SMTP::Banner;

  my $host = $ARGV[0];

  my $scan = Net::Scan::SMTP::Banner->new({
    host    => $host,
    timeout => 5,
    debug   => 0 
  });

  my $results = $scan->scan;

  print "$host $results\n" if $results;

=head1 DESCRIPTION

This module permit to grab the banner message from a SMTP server.

=head1 METHODS

=head2 new

The constructor. Given a host returns a L<Net::Scan::SMTP::Banner> object:

  my $scan = Net::Scan::SMTP::Banner->new({
    host    => "127.0.0.1",
    port    => 25,
    timeout => 5,
    debug   => 1 
  });

Optionally, you can also specify :

=over 2

=item B<port>

Remote port. Default is 25 tcp;

=item B<timeout>

Default is 8 seconds;

=item B<debug>

Set to 1 enable debug. Debug displays "connection refused" when an SMTP server is unrecheable. Default is 0;

=back

=head2 scan 

Scan the target.

  $scan->scan;

=head1 SEE ALSO

Net::SMTP

nmap L<http://www.insecure.org/nmap/>

=head1 AUTHOR

Matteo Cantoni, E<lt>mcantoni@nothink.orgE<gt>

=head1 COPYRIGHT AND LICENSE

You may distribute this module under the terms of the Artistic license.
See Copying file in the source distribution archive.

Copyright (c) 2006, Matteo Cantoni

=cut
