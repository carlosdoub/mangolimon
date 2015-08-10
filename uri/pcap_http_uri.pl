use Net::TcpDumpLog;
use NetPacket::Ethernet;
use NetPacket::IP;
use NetPacket::TCP;

use strict;
use warnings;

open FILE, ">uri.txt" or die $!;

my $i = 0;
my $log = Net::TcpDumpLog->new(); 
$log->read("$ARGV[0]");
foreach my $index ($log->indexes) { 
	my $data = $log->data($index);

	my $eth_obj = NetPacket::Ethernet->decode($data);    
	next unless $eth_obj->{type} == NetPacket::Ethernet::ETH_TYPE_IP;

	my $ip_obj = NetPacket::IP->decode($eth_obj->{data});
	next unless $ip_obj->{proto} == NetPacket::IP::IP_PROTO_TCP;


	my @data = split /\r\n/, $ip_obj->{data};
	my @line;
	my $request=();
	my $host=();

	foreach (@data) {
		if(m/Host: /) {
			@line = split /Host: /,$_;
			$host = $line[1];
			chomp $host;
		}
		if(m/GET /) {
			@line = split /GET /,$_;
			my @L = split / /,$line[1];
			$request = $L[0];
			chomp $request;
			$i++;
		} 
		if(m/HEAD /) {
			@line = split /HEAD /,$_;
			my @L = split / /,$line[1];
			$request = $L[0];
			chomp $request;
			$i++;
		}
		if(m/POST /) {
			@line = split /POST /,$_;
			my @L = split / /,$line[1];
			$request = $L[0];
			chomp $request;
			$i++;
		}
		if(m/PUT /) {
			@line = split /PUT /,$_;
			my @L = split / /,$line[1];
			$request = $L[0];
			chomp $request;
			$i++;
		}
		if(m/DELETE /) {
			@line = split /DELETE /,$_;
			my @L = split / /,$line[1];
			$request = $L[0];
			chomp $request;
			$i++;
		}
	}

	if($host && $request) {
		print FILE $host.$request."\n";
	}

}

close FILE or warn $!;
print "Amount of packages on $ARGV[0]: $i";

