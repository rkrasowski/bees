#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes  qw(tv_interval gettimeofday);



#my $data = "11100101110101111010100111010101\n";
				
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

my @inArray= (0,0,0,0,0,0,0,0,0,0,0,0);
my $inArray;
my @outArray= (0,0,0,0,0,0,0,0,0,0,0,0);
my $outArray;
my @timeBeeStart = (0,0,0,0,0,0,0,0,0,0,0,0);
my $timeBeeStart;
my $timeBeeFinish;
my $timeBeeDiff;
my @timeBeeDBIn;
my $timeBeeDBIn;
my @timeBeeDBOut;
my $timeBeeDBOut;



open FH, "test.txt" or die "Could not open file: $!";
my $data = join("",<FH>);
close FH;


my  $start = [gettimeofday];

my @dataArray = split (//,$data);
my $dataArray;





for ( my $i = 1;  $i<= 12; $i++)
	{
			counter($i);
		print "Elem number: $i\n";
	}
########################################## Subroutines ##############################

sub counter {

	my $channel = shift;
	my $firstElemArray = ($channel * 2) - 2;
        my $secondElemArray = ($channel *2) -1;	
	my $inoutElemArray = $channel -1;
	print "First $firstElemArray\n";
	print "Second $secondElemArray\n";
	print "InOutElem Array $inoutElemArray\n";

	# IN triggered:

	if ($dataArray[$firstElemArray] == 1 and $dataArray[$secondElemArray] == 0)
		{
			if ($inArray[$inoutElemArray] == 0)    					# Checking if channel IN is ative		
				{
					$timeBeeStart[$inoutElemArray] =	`date +%s%N | cut -b1-13`;
					$in = $in + 1;
					$inArray[$inoutElemArray] = 1;				# Desactivating IN channel
				}
		}


	# IN and OUT triggered direction OUT	

	if ($dataArray[$firstElemArray] == 1 and $dataArray[$secondElemArray] == 1 and $inArray[0] == 1)
		{

			if ($outArray[$inoutElemArray] == 0)						# Checking if channel OUT is active
				{
					$timeBeeFinish = `date +%s%N | cut -b1-13`;
					$timeBeeDiff = $timeBeeFinish - $timeBeeStart[$inoutElemArray];
					push (@timeBeeDBOut,$timeBeeDiff);
					$outArray[$inoutElemArray] = 1;
				}
		}	

	# OUT triggered

	if ($dataArray[$secondElemArray] == 1 and $dataArray[$firstElemArray] == 0) 
		{
			if ($outArray[$inoutElemArray] == 0)    					# Checking if channel OUT is ative		
				{
					$timeBeeStart[$inoutElemArray] =	`date +%s%N | cut -b1-13`;
					$out = $out + 1;
					$outArray[$inoutElemArray] = 1;				# Desactivating OUT channel
				}	
		}

	# OUT and IN triggered direction IN 
			
	if ($inArray[$inoutElemArray] == 0  and $dataArray[$firstElemArray] == 1 and $outArray[$inoutElemArray] == 1)

				{
					$timeBeeFinish = `date +%s%N | cut -b1-13`;
					$timeBeeDiff = $timeBeeFinish - $timeBeeStart[$inoutElemArray];
					push (@timeBeeDBIn,$timeBeeDiff);
					$inArray[$inoutElemArray] = 1;
				}
		



	# Reactivate channel 

	if ($dataArray[$firstElemArray] == 0  and $dataArray[$secondElemArray] ==0)
		{
			$inArray[$inoutElemArray] = 0;
			$outArray[$inoutElemArray] = 0;
		}

}


##################### Print  data ####################

foreach $inArray (@inArray)
	{
		print "InArray: $inArray\n";
	}

foreach $outArray(@outArray)
	{
		print "OutArray: $outArray\n";

	}

foreach $timeBeeDBIn(@timeBeeDBIn)
	{
		print "TimeBee IN: $timeBeeDBIn\n";
	}


foreach $timeBeeDBOut (@timeBeeDBOut)
	{
		print "TimeBee OUT: $timeBeeDBOut\n";
	}
#		for (my $i=1; $i <= $numOfChannels; $i++) 
#			{
   
			
#			}


my $finish = [gettimeofday];
my $elapsed = tv_interval($start,$finish);



print "Data IN: $in, OUT: $out\n";
print "Elapsed Time: $elapsed\n";

############################################## Subroutines #########################################################
