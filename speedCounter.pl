#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes  qw(tv_interval gettimeofday);



#my $data = "11100101110101111010100111010101\n";
				
##########################  Config parameters #########################
my $in = 0;
my $out = 0;
my $numOfChannels = 6;

#######################################################################

# Create variables

my @timeArray;
my $timeArray;

for (my $j=1; $j <= $numOfChannels; $j++)
	{
		
		my $timeMs = `date +%s%N | cut -b1-13`;		#time in ms
		push @timeArray, $timeMs;
	}


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




while(1)
{
# Just for testing 

open FH, "test.txt" or die "Could not open file: $!";
my $data = join("",<FH>);
close FH;


my  $start = [gettimeofday];

my @dataArray = split (//,$data);;
my $dataArray;

print "Data outside @dataArray\n";


my $ref = \@dataArray;
for ( my $i = 1;  $i<= $numOfChannels; $i++)
	{
			counter($ref,$i);
			print "__________________________________\n";
	}
########################################## Subroutines ##############################
sub counter {
	my $refInside = shift;
	my $channel = shift;
	my $firstElemArray = ($channel * 2) - 2;
        my $secondElemArray = ($channel *2) -1;	
	my $inoutElemArray = $channel -1;
#	print "First $firstElemArray\n";
#	print "Second $secondElemArray\n";
#	print "InOutElem Array $inoutElemArray\n";
print "Channel number: $channel\n";

	# IN triggered : Bee getting from Outside to Inside, so it is gettin IN  (outside sensor in first):

	if (${$refInside}[$firstElemArray] == 1 and ${$refInside}[$secondElemArray] == 0)
		{
			#		print "In for channel $inoutElemArray triggered\n";
		
			if ($inArray[$inoutElemArray] == 0)    					# Checking if channel IN is ative		
				{
					$timeBeeStart[$inoutElemArray] =`date +%s%N | cut -b1-13`;
					$in = $in + 1;
					$inArray[$inoutElemArray] = 1;				# Desactivating IN channel
					#	print "Channel number $channel IN  blocked\n";
				}
				#	print "INarray: @inArray\n";
		}


	# IN and OUT sensor triggered direction: Getting inside	

	if (${$refInside}[$firstElemArray] == 1 and ${$refInside}[$secondElemArray] == 1 and $inArray[$inoutElemArray] == 1)
		{

			if ($outArray[$inoutElemArray] == 0)						# Checking if channel OUT is active
				{
					$timeBeeFinish = `date +%s%N | cut -b1-13`;
					$timeBeeDiff = $timeBeeFinish - $timeBeeStart[$inoutElemArray];
					push (@timeBeeDBOut,$timeBeeDiff);
					$outArray[$inoutElemArray] = 1;
				}
		}	

	# OUT triggered: Bee is getting from Inside to outside, so it is getting OUT (Inside sensor triggered first)

	if (${$refInside}[$secondElemArray] == 1 and ${$refInside}[$firstElemArray] == 0) 
		{
			#	print "Out in channel $channel is triggered\n";
			if ($outArray[$inoutElemArray] == 0)    					# Checking if channel OUT is ative		
				{
					$timeBeeStart[$inoutElemArray] =	`date +%s%N | cut -b1-13`;
					$out = $out + 1;
					$outArray[$inoutElemArray] = 1;				# Desactivating OUT channel
				}	
		}

	# OUT and IN triggered direction IN 
			
	if ($inArray[$inoutElemArray] == 0  and ${$refInside}[$firstElemArray] == 1 and $outArray[$inoutElemArray] == 1)

				{
					$timeBeeFinish = `date +%s%N | cut -b1-13`;
					$timeBeeDiff = $timeBeeFinish - $timeBeeStart[$inoutElemArray];
					push (@timeBeeDBIn,$timeBeeDiff);
					$inArray[$inoutElemArray] = 1;
				}
		



	# Reactivate channel 
#print "First element of dataArray: ${$refInside}[$firstElemArray]\n";
#print "Second elementod dataArray: ${$refInside}[$secondElemArray]\n";

	if (${$refInside}[$firstElemArray] == 0  and ${$refInside}[$secondElemArray] ==0)
		{
			$inArray[$inoutElemArray] = 0;
			$outArray[$inoutElemArray] = 0;
	#		print "Channel $channel is active again\n";
		}
}


##################### Print  data ####################

#foreach $inArray (@inArray)
#	{
#		print "InArray: $inArray\n";
#	}

#foreach $outArray(@outArray)
#	{
#		print "OutArray: $outArray\n";
#
#	}

foreach $timeBeeDBIn(@timeBeeDBIn)
	{
		print "TimeBee IN: $timeBeeDBIn\n";
	}


foreach $timeBeeDBOut (@timeBeeDBOut)
	{
		print "TimeBee OUT: $timeBeeDBOut\n";
	}

my $finish = [gettimeofday];
my $elapsed = tv_interval($start,$finish);


print "Data IN: $in, OUT: $out\n";
print "Elapsed Time: $elapsed\n";
print "\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n";

sleep(5);

}
############################################## Subroutines #########################################################
