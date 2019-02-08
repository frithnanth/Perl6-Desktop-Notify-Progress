#!/usr/bin/env perl6

use Test;
use lib 'lib';
use Desktop::Notify::Progress;

constant AUTHOR = ?%*ENV<TEST_AUTHOR>;

my $p := Desktop::Notify::Progress.new: :filename($*PROGRAM-NAME), :timeout(1);
isa-ok $p, 'Desktop::Notify::Progress', 'simple initialization';
does-ok $p, Iterator, 'does Iterator';
throws-like
  { my $fp := Desktop::Notify::Progress.new: :filename('nonexistent') },
  X::AdHoc,
  'throws when fed a nonexistent file';
my $fh = $*PROGRAM-NAME.IO.open;
my $fp := Desktop::Notify::Progress.new: :$fh, :title($*PROGRAM-NAME);
isa-ok $p, 'Desktop::Notify::Progress', 'initialization from a file handler';
throws-like
  { my IO::Handle $fh .= new; my $fp := Desktop::Notify::Progress.new: :$fh, :title('nonexistent') },
  X::AdHoc,
  'throws when fed an unopened IO::Handle';

if AUTHOR {
  for $p -> $l {
    $l.say;
    sleep .1;
  }
  # Does it show on screen? :-)
}else{
  skip 'process a file and show the progress', 1;
}


done-testing;
