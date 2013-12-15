# For the latest version and changelog information, see
# https://github.com/joostvunderink/irssi-scripts

use strict;
use warnings;
use Irssi;
use Irssi::Irc;

our $VERSION = "1.0";

our %IRSSI = (
    authors     => "Joost Vunderink (Garion)",
    contact     => 'joost@vunderink.net',
    name        => "Upside down away reasons",
    description => "Turns your /away reasons upside down",
    license     => "Public domain",
    url         => "http://www.garion.org/irssi/",
    changed     => "2013-12-15 11:33:15+0100",
);

sub cmd_udaway {
    my ($args, $server, $item) = @_;

    if (length($args)) {
        my $ud = turn_upside_down($args);
        $server->command("/AWAY $ud");
    } else {
        $server->command("/AWAY");
    }
}

# Thanks to JohnPC for this upside down mapping!
my %updown = (
    ' ' => ' ',
    '!' => "\x{00a1}",
    '"' => "\x{201e}",
    '#' => '#',
    '$' => '$',
    '%' => '%',
    '&' => "\x{214b}",
    "'" => "\x{0375}",
    '(' => ')',
    ')' => '(',
    '*' => '*',
    '+' => '+',
    ',' => "\x{2018}",
    '-' => '-',
    '.' => "\x{02d9}",
    '/' => '/',
    '0' => '0',
    '1' => '1',
    '2' => '',
    '3' => '',
    '4' => '',
    '5' => "\x{1515}",
    '6' => '9',
    '7' => '',
    '8' => '8',
    '9' => '6',
    ':' => ':',
    ';' => "\x{22c5}\x{0315}",
    '<' => '>',
    '=' => '=',
    '>' => '<',
    '?' => "\x{00bf}",
    '@' => '@',
    'A' => "\x{13cc}",
    'B' => "\x{03f4}",
    'C' => "\x{0186}",
    'D' => 'p',
    'E' => "\x{018e}",
    'F' => "\x{2132}",
    'G' => "\x{2141}",
    'H' => 'H',
    'I' => 'I',
    'J' => "\x{017f}\x{0332}",
    'K' => "\x{029e}",
    'L' => "\x{2142}",
    'M' => "\x{019c}",
    'N' => 'N',
    'O' => 'O',
    'P' => 'd',
    'Q' => "\x{053e}",
    'R' => "\x{0222}",
    'S' => 'S',
    'T' => "\x{22a5}",
    'U' => "\x{144e}",
    'V' => "\x{039b}",
    'W' => 'M',
    'X' => 'X',
    'Y' => "\x{2144}",
    'Z' => 'Z',
    '[' => ']',
    '\\' => '\\',
    ']' => '[',
    '^' => "\x{203f}",
    '_' => "\x{203e}",
    '`' => "\x{0020}\x{0316}",
    'a' => "\x{0250}",
    'b' => 'q',
    'c' => "\x{0254}",
    'd' => 'p',
    'e' => "\x{01dd}",
    'f' => "\x{025f}",
    'g' => "\x{0253}",
    'h' => "\x{0265}",
    'i' => "\x{0131}\x{0323}",
    'j' => "\x{017f}\x{0323}",
    'k' => "\x{029e}",
    'l' => "\x{01ae}",
    'm' => "\x{026f}",
    'n' => 'u',
    'o' => 'o',
    'p' => 'd',
    'q' => 'b',
    'r' => "\x{0279}",
    's' => 's',
    't' => "\x{0287}",
    'u' => 'n',
    'v' => "\x{028c}",
    'w' => "\x{028d}",
    'x' => 'x',
    'y' => "\x{028e}",
    'z' => 'z',
    '{' => '}',
    '|' => '|',
    '}' => '{',
    '~' => "\x{223c}",
);
my $missing = "\x{fffd}"; # replacement character

sub turn_upside_down ($) {
    my ($str) = @_;

    my $turned = '';
    my $tlength = 0;

    for my $char ( $str =~ /(\X)/g ) {
        if ( exists $updown{$char} ) {
            my $t = $updown{$char};
            $t = $missing if !length($t);
            $turned = $t . $turned;
            $tlength++;
        } elsif ( $char eq "\t" ) {
            my $tablen = 8 - $tlength % 8;
            $turned = " " x $tablen . $turned;
            $tlength += $tablen;
        } elsif ( ord($char) >= 32 ) {
            ### other chars copied literally
            $turned = $char . $turned;
            $tlength++;
        }
    }
    return $turned . "  ";
}

Irssi::command_bind('udaway', 'cmd_udaway');

Irssi::print("Use /udaway <reason> to set yourself away, and /udaway to return.");

