package Algorithm::Interval2Prefix;
use strict;

use vars qw($VERSION @ISA @EXPORT);

require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(&interval2prefix);

$VERSION = '0.1';

my %Step;  # cache

sub _step {
  my($i, $base) = @_;
  return $Step{$base}[$i] if exists $Step{$base}[$i];
  $Step{$base}[0] = 1;  # n**0 == 1
  return $Step{$base}[$i] = $Step{$base}[$i-1] * $base;
}

sub interval2prefix {
  my($lo, $hi, $base) = @_;
  $base ||= 10;  # default number base
  my @res;
  while ($lo <= $hi) {
    my $i = 0;
    while (($lo % _step($i+1, $base) == 0) and
	  (($lo + _step($i+1, $base) - 1 <= $hi))) {
      $i++;
    }
    push @res, $lo / _step($i, $base);
    $lo += _step($i, $base);
  }
  return @res;
}

1;

=head1 NAME

Algorithm::Interval2Prefix - Generate prefixes from intervals

=head1 SYNOPSIS

  use Algorithm::Interval2Prefix;
  my @prefixes = interval2prefix('33400','33599');

  print join(',', @prefixes); # prints "334,335"

=head1 DESCRIPTION

Taking an interval as input, this module will construct the smallest
set of prefixes, such that any number in the interval will match one
of the prefixes.

E.g. all numbers in the interval 39967000 to 39980999 would be matched
by the following set of prefixes:

  39967
  39968
  39969
  3997
  39980

This type of conversion is particularly useful when working with
telephony switching equipment, which usually determines call routing
based on number prefixes rather than ranges.

The algorithm is much dependent on the number base, which defaults to
10. Other number bases can be specified explicitly.

=head1 FUNCTIONS

=head2 C<interval2prefix()>

  my @p = interval2prefix($lo, $hi);
   or
  my @q = interval2prefix($lo, $hi, $base);

Yields an array of prefixes, covering the interval C<$lo> to C<$hi>,
using number base C<$base>.

C<$base> is optional, and defaults to 10.

=head1 EXPORT

C<&interval2prefix> is exported by default.

=head1 AUTHOR

Lars Thegler <lars@thegler.dk>

=head1 COPYRIGHT

Copyright (c) 2003 Lars Thegler. All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
