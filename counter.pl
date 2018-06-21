#!/usr/bin/perl
use strict;
use warnings;

my $data = "0111001110101111010100111010101";

print "Data: $data\n";


my $in = 0;
my $out = 0;

my $numOfChannels = 12;

my $timeMs = `date +%s%N | cut -b1-13`;
print" $timeMs\n";

exit();

my @dataArray = split (//,$data);
my $dataArray;



while(1)
	{
		for (my $i=1; $i <= $numOfChannels; $i++) 
			{
   
				channelCheck($i);

			}

print "Data IN: $in, OUT: $out\n";
}
############################################## Subroutines #########################################################


sub channelCheck 
	{
		my $channelNumber = shift;
		
	print "Channel number $channelNumber\n\n";
		my $firstElemArray;
		my $secondElemArray;
		if ($channelNumber == 1)
			{
				$firstElemArray = 0;
				$secondElemArray = 1;
			}
		else
			{

				$firstElemArray = ($channelNumber * 2) - 2;
				$secondElemArray = ($channelNumber *2) - 1;
			print "First: $firstElemArray\nSecond: $secondElemArray\n\n";
			}

		
		print "Dat1 $dataArray[$firstElemArray]\nDat $dataArray[$secondElemArray]\n";


		if ($dataArray[$firstElemArray] == 1 and $dataArray[$secondElemArray] == 0)
			{
						
				$in = $in +1;
				print "Adding IN\n";
			}





		if ($dataArray[$secondElemArray] == 1 and $dataArray[$firstElemArray]  == 0)
			{
		
                                $out = $out +1;
				print "Adding OUT\n";
                        }


	}
