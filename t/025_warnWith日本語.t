use Test::More 0.98 tests => 3;
use Encode qw(is_utf8 encode_utf8 decode_utf8);
use lib 'lib';

local $SIG{__WARN__} = sub {
    use utf8;
    $_[0] =~ /(.+) at (.+) line (\d+)\.$/;
    return pass("plain text '$1' was warned at $2 line $3.") unless is_utf8($1);
    my ( $str, $path, $line ) = ( $1, $2, $3 );
    if ( $_[0] =~ qr/^宣言/ ) {
        BAIL_OUT "code is broken" if $_[0] =~ /^\x{5BA3}\x{8A00}\x{3042}\x{308A}$/;

        pass encode_utf8 "decoded text '$str' was warned at $path line $line.";

        # This line has no warning but mojibake
        # It's ok if this line was
        pass "decoded text '" . encode_utf8($str) . "' was warned at $path line $line.";

       # or
       #pass encode_utf8 "decoded text '$str' was warned at " . decode_utf8($path) . " line $line.";
       # why?
    } else {
        my $encoded = encode_utf8 $_[0];
        fail "it's an unexpected warning: $encoded";
    }
};

no utf8;    # Of course it defaults no, but declare it explicitly
use strict;
use warnings;

my $ascii = 'no utf8';
my $plain = '宣言なし';

subtest 'Before use utf8' => \&plainTest;

subtest 'Inside of utf8' => sub {
    plan tests => 5;
    use utf8;
    my $decoded = '宣言あり';
    eval { warn $ascii }   and pass("$ascii is an ASCII");
    eval { warn $decoded } and pass("pass to warn with decoded strings");
};

subtest 'after use utf8' => \&plainTest;

done_testing;

sub plainTest {
    plan tests => 4;
    eval { warn $ascii } and pass("$ascii is an ASCII");
    eval { warn $plain } and pass("$plain is a plain");
}
