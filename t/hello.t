#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Hello;

ok( Hello::my_sub() , 'ok');

done_testing
