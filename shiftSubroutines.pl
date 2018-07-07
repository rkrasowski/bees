#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw(tv_interval gettimeofday);

my $reg = 24;



print "Start \n";

print " Sting pins in correct mode\n";
`gpio mode 0 in`;
`gpio mode 2 out`;
`gpio mode 3 out`;


while (1)
	{
		my $start = [gettimeofday];

		`gpio write 3 0`;
		#	select(undef,undef,undef,.1);
		`gpio write 3 1`;

		my @shiftArray;
		my $shiftarray;

		$shiftArray[0] = `gpio read 0`;
		chomp $shiftArray[0];
		
		for (my $i=1; $i <=$reg; $i++)
			{	
				`gpio write 2 1`;
			#	select(undef,undef,undef,.1);
				`gpio write 2 0`;
				$shiftArray[$i] = `gpio read 0`;
				chomp $shiftArray[$i];
			}


		my $finish = [gettimeofday];

		my $elapsed = tv_interval($start,$finish);

		print "@shiftArray Elapsed: $elapsed\r";

	}
