#use usw;   #stop to use usw; to make clear the Issue
use utf8;
use strict;
use warnings;
binmode \*STDIN,  ':encoding(UTF-8)';
binmode \*STDOUT, ':encoding(UTF-8)';
binmode \*STDERR, ':encoding(UTF-8)';

# "Wide character in print at $PATH/lib/perl5/site_perl/5.26.3/Test2/Formatter/TAP.pm line 156."
# for 6 times. so Test2::Formatter::TAP has some problem at line 156.

use Test::More 0.98;
use Encode qw(encode_utf8 decode_utf8);
use lib 'lib';

my @libs = qw(
    ASCII::Plain
    ASCII::で
    日本語::Plain
    日本語::で
);

note 'start to require';
eval "require $_" || warn $@ for @libs;             # there is no warnings;
note $_ for sort keys %INC;                         # it seems they succeed to be required;
note 'end to require';

#require_ok($_) for @libs;                        # last two fail, why?
#require_ok( encode_utf8 $_) for @libs;           # getting worse
require_ok($_) for map { _getPath($_) } @libs;    # pass

for (@libs) {
    my $class = new_ok($_);
    $class->セイ( ref $class, '::やー' );
}

done_testing;

sub _getPath {
    local $_ = shift;
    s!::!/!g;
    return "$_.pm";
}
