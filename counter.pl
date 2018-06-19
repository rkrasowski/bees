#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes  qw(tv_interval gettimeofday);



my $data = "01100101110101111010100111010101\n";

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



# Getting data



my  $start = [gettimeofday];


my @dataArray = split (//,$data);
my $dataArray;


	
		for (my $i=1; $i <= $numOfChannels; $i++) 
			{
   
				channelCheck($i);

			}


my   $finish = [gettimeofday];

my $elapsed = tv_interval($start,$finish);



print "Data IN: $in, OUT: $out\n";
print "Elapsed Time: $elapsed\n";

############################################## Subroutines #########################################################


sub channelCheck 
	{
		my $channelNumber = shift;
		
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
			}

		

	# Case of new IN 

		if ($dataArray[$firstElemArray] == 1 and $dataArray[$secondElemArray] == 0)
			{
						
				


				my $timeCheckMs = `date +%s%N | cut -b1-13`;
				$nextTime = $timeArray[$channelNumber -1];
				

				if ($timeCheckMs > $nextTime)
					{ 		
				
						$in = $in +1;
						$nextTime = $timeCheckMs + $delay;
						$timeArray[$channelNumber -1] = "$nextTime\n";
					}

			}


	# cASE OF new OUT 


		if ($dataArray[$secondElemArray] == 1 and $dataArray[$firstElemArray]  == 0)
			{
		
			  my $timeCheckMs = `date +%s%N | cut -b1-13`;
                                $nextTime = $timeArray[$channelNumber -1];


                                if ($timeCheckMs > $nextTime)
                                        {

                                                $out = $out +1;
                                                $nextTime = $timeCheckMs + $delay;
                                                $timeArray[$channelNumber -1] = "$nextTime\n";
                                        }
 


                       }

	}
