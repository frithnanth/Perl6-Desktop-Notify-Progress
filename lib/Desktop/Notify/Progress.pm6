use v6.c;

use Desktop::Notify;

class Desktop::Notify::Progress:ver<0.0.1>:auth<cpan:FRITH> does Iterator {
  has IO::Handle $!fh;
  has Int $!size;
  has Desktop::Notify $!notify;
  has NotifyNotification $!n;

  multi submethod TWEAK(Str :$filename!, Str :$title?, Int :$timeout? = 0) {
    X::AdHoc.new(payload => 'File not found').throw if ! $filename.IO.e;
    $!fh = $filename.IO.open;
    $!size = $!fh.IO.s;
    $!notify = Desktop::Notify.new(app-name => $title // $filename);
    $!n = $!notify.new-notification: :summary($title // $filename), :body(self.perc), :icon('info'), :$timeout
  }
  multi submethod TWEAK(IO::Handle :$fh!, Str :$title!, Int :$timeout? = 0) {
    X::AdHoc.new(payload => 'File not opened').throw if ! $fh.opened;
    $!fh = $fh;
    $!size = $!fh.IO.s;
    $!notify = Desktop::Notify.new(app-name => $title);
    $!n = $!notify.new-notification: :summary($title), :body(self.perc), :icon('info'), :$timeout
  }
  method perc(--> Str) {
    ($!fh.tell / $!size * 100).fmt: '%6.2f%%';
  }
  method iterator { self }
  method pull-one {
    with $!notify {
      .update: $!n, .app-name, self.perc, 'info';
      .show: $!n
    }
    $!fh.get // IterationEnd
  }
}

=begin pod

=head1 NAME

Desktop::Notify::Progress - Show the progress of file processing in a notification popup

=head1 SYNOPSIS

=begin code :lang<perl6>

use Desktop::Notify::Progress;

my $p := Progress.new: :filename('BigDataFile');
for $p -> $line {
  painfully-process($line);
}

=end code

=begin code :lang<perl6>

use Desktop::Notify::Progress;

my $fh = 'BigDataFile'.IO.open;
my $p := Progress.new: :$fh, :title('Long data processing'), :timeout(2);
for $p -> $line {
  painfully-process($line);
}

=end code

=head1 DESCRIPTION

Desktop::Notify::Progress is a small class that provides a way to show the progress of file processing using libnotify

=head2 new(Str :$filename!, Str :$title?, Int :$timeout? = 0)
=head2 new(IO::Handle :$fh!, :$title!, Int :$timeout? = 0)

Creates a B<Desktop::Notify::Progress> object.

The first form takes one mandatory argument: B<filename>, which will be used as the notification title.
Optionally one can pass an additional string which will be used as the notification title: B<title>.
Another optional parameter B<timeout>, the number of seconds the notification will last until disappearing. By default the notification will not disappear until explicitly closed.

The second form requires both an opened file handler B<fh> and the notification B<title>. An optional B<timeout> can be specified.

=head2 Usage

A Desktop::Notify::Progress object has an B<Iterable> role, so it can be used to read a file line by line.
When initialized the object will read the file size, so it will be able to update the computation progress as a
percentage in the notification window.

=head1 Prerequisites

This module requires the libnotify library to be installed. Please follow the
instructions below based on your platform:

=head2 Debian Linux

=begin code
sudo apt-get install libnotify4
=end code

=head1 Installation

To install it using zef (a module management tool):

=begin code
$ zef install Desktop::Notify::Progress
=end code

This will install the Desktop::Notify module if not yet present.

=head1 Testing

To run the tests:

=begin code
$ prove -e "perl6 -Ilib"
=end code

=head1 AUTHOR

Fernando Santagata <nando.santagata@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
