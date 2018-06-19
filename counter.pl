#!/usr/bin/perl
use strict;
use warnings;

my $data = "0110001110101111010100111010101\n";

print "Data: $data\n";

##########################  Config parameters #########################
my $in = 0;
my $out = 0;
my $numOfChannels = 12;
my $delay = 11111; 		#delay ms
#######################################################################

# Create starting time array 

my @timeArray;
my $timeArray;

for (my $j=1; $j <= $numOfChannels; $j++)
	{
		
		my $timeMs = `date +%s%N | cut -b1-13`;		#time in ms
		push @timeArray, $timeMs;
	}

print @timeArray;



my @dataArray = split (//,$data);
my $dataArray;



channelCheck(2);

                        

print "Data IN: $in, OUT: $out\n";

print @timeArray;

exit();


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
		my $timeCheckMs;
		my $nextTime;
		my $timeMs;
		
	# Finding array element number 

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

	# Case of new IN 

		if ($dataArray[$firstElemArray] == 1 and $dataArray[$secondElemArray] == 0)
			{
						
				


				my $timeCheckMs = `date +%s%N | cut -b1-13`;
				$nextTime = $timeArray[$channelNumber -1];
                                print "NextTime is $nextTime\n";
				

				if ($timeCheckMs > $nextTime)
					{ 		
				
						$in = $in +1;
						print "Adding IN\n";
						$nextTime = $timeCheckMs + $delay;
						print "NewNext Time: $nextTime\n";
						$timeArray[$channelNumber -1] = "$nextTime\n";
					}

			}


	# cASE OF NEW out 


		if ($dataArray[$secondElemArray] == 1 and $dataArray[$firstElemArray]  == 0)
			{
		
			  my $timeCheckMs = `date +%s%N | cut -b1-13`;
                                $nextTime = $timeArray[$channelNumber -1];
                                print "NextTime is $nextTime\n";


                                if ($timeCheckMs > $nextTime)
                                        {

                                                $out = $out +1;
                                                print "Adding OUT\n";
                                                $nextTime = $timeCheckMs + $delay;
                                                print "NewNext Time: $nextTime\n";
                                                $timeArray[$channelNumber -1] = "$nextTime\n";
                                        }
 


                       }


	}
