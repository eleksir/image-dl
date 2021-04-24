use 5.018;
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use lib qw(./vendor_perl/lib/perl5);
use URI::URL;
use LWP::Simple qw(mirror);
use Coro::LWP;

open (my $ch, '<', './config') || die "No config.\n";
my $savedir = readline $ch;
close $ch;
chomp $savedir;
$savedir = (split (/\s*=\s*/, $savedir, 2))[1];

my $app = sub {
	my $env = shift;

	my $msg = "Your Opinion is very important for us, please stand by.\n";
	my $status = '404';
	my $content = 'text/plain';

	if ($env->{PATH_INFO} eq "/image_dl") {
		my $str = $env->{HTTP_URL};

		unless (defined $str) {
			$msg = "No url http header supplied.\n";
			return [ '400', [ 'Content-Type' => $content, 'Content-Length' => length ($msg) ], [ $msg ], ];
		}

		unless ((substr ($str, 0, 7) eq 'http://') || (substr ($str, 0, 8) eq 'https://')) {
			$msg = "Incorrect URL\n";
			return [ '400', [ 'Content-Type' => $content, 'Content-Length' => length ($msg) ], [ $msg ], ];
		}

		unless (-d $savedir) {
			mkdir ($savedir) or do {
				$msg = "Unable to make $savedir: $!\n";
				return [ '500', [ 'Content-Type' => $content, 'Content-Length' => length ($msg) ], [ $msg ], ];
			}
		}

		my $fname = $str;
		$fname =~ s/[^\w!., -#]/_/xmsg;

		if (lc ($str) =~ /\.(gif|jpe?g|png|webm|mp4)$/xms) {
			my $savepath = sprintf '%s/%s', $savedir, $fname;

			unless (-f $savepath) {
				my $urlobj = url $str;
				mirror ($urlobj->as_string, $savepath);
			}
		}

		$msg = "Done\n";
		$status = '200';
	}


	return [
		$status,
		[ 'Content-Type' => $content, 'Content-Length' => length ($msg) ],
		[ $msg ],
	];
};


__END__

# vim: ft=perl noet ai ts=4 sw=4 sts=4:
