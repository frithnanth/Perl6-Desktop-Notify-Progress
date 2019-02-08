[![Build Status](https://travis-ci.org/frithnanth/Perl6-Desktop-Notify-Progress.svg?branch=master)](https://travis-ci.org/frithnanth/Perl6-Desktop-Notify-Progress)

NAME
====

Desktop::Notify::Progress - Show the progress of file processing in a notification popup

SYNOPSIS
========

```perl6
use Desktop::Notify::Progress;

my $p := Progress.new: :filename('BigDataFile');
for $p -> $line {
  painfully-process($line);
}
```

```perl6
use Desktop::Notify::Progress;

my $fh = 'BigDataFile'.IO.open;
my $p := Progress.new: :$fh, :title('Long data processing'), :timeout(2);
for $p -> $line {
  painfully-process($line);
}
```

DESCRIPTION
===========

Desktop::Notify::Progress is a small class that provides a way to show the progress of file processing using libnotify

new(Str :$filename!, Str :$title?, Int :$timeout? = 0)
------------------------------------------------------

new(IO::Handle :$fh!, :$title!, Int :$timeout? = 0)
---------------------------------------------------

Creates a **Desktop::Notify::Progress** object.

The first form takes one mandatory argument: **filename**, which will be used as the notification title. Optionally one can pass an additional string which will be used as the notification title: **title**. Another optional parameter **timeout**, the number of seconds the notification will last until disappearing. By default the notification will not disappear until explicitly closed.

The second form requires both an opened file handler **fh** and the notification **title**. An optional **timeout** can be specified.

Usage
-----

A Desktop::Notify::Progress object has an **Iterable** role, so it can be used to read a file line by line. When initialized the object will read the file size, so it will be able to update the computation progress as a percentage in the notification window.

Prerequisites
=============

This module requires the libnotify library to be installed. Please follow the instructions below based on your platform:

Debian Linux
------------

    sudo apt-get install libnotify4

Installation
============

To install it using zef (a module management tool):

    $ zef install Desktop::Notify::Progress

This will install the Desktop::Notify module if not yet present.

Testing
=======

To run the tests:

    $ prove -e "perl6 -Ilib"

AUTHOR
======

Fernando Santagata <nando.santagata@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

