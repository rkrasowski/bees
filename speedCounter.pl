#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes  qw(tv_interval gettimeofday);


				
##########################  Config parameters #########################
my $in = 0;
my $out = 0;
my $numOfChannels = 6;
my $delay = 10;
#######################################################################

# Create variables

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

my $time2Send = `date +%s` + $delay; 			# Calculate time for next send


while(1)
	{
		# Just for testing 
		open FH, "test.txt" or die "Could not open file: $!";
		my $data = join("",<FH>);
		close FH;
		#end just for testing

		my  $start = [gettimeofday];

		my @dataArray = split (//,$data);;
		my $dataArray;

		print "Data outside @dataArray";


		my $ref = \@dataArray;
		for (my $i = 1;  $i<= $numOfChannels; $i++)
			{
				counter($ref,$i);
				#	print "__________________________________\n";
			}
			print "Time to send: $time2Send\n";
			my $timeNow = `date +%s`;
			print "Time now $timeNow\n";
		if (`date +%s` >= $time2Send)
			{
				$time2Send = `date +%s` + $delay;
				sendDB();;
			}

		#Start just for testing
		my $finish = [gettimeofday];
		my $elapsed = tv_interval($start,$finish);

		print  "In: $in\nOut:$out\n";
		print "Elapsed time: $elapsed\n";
		sleep(2);
		#Finish just for testing
	}
########################################## Subroutines ##############################
sub counter {
	my $refInside = shift;
	my $channel = shift;
	my $firstElemArray = ($channel * 2) - 2;
        my $secondElemArray = ($channel *2) -1;	
	my $inoutElemArray = $channel -1;
	#print 	"First $firstElemArray\n";
	#	print "Second $secondElemArray\n";
	#	print "InOutElem Array $inoutElemArray\n";
	#print "Channel number: $channel\n";

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
					push (@timeBeeDBIn,$timeBeeDiff);
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

	# OUT and IN triggered direction OUT: bee is getting  OUTSIDE
			
	if ($inArray[$inoutElemArray] == 0  and ${$refInside}[$firstElemArray] == 1 and $outArray[$inoutElemArray] == 1)

				{
					$timeBeeFinish = `date +%s%N | cut -b1-13`;
					$timeBeeDiff = $timeBeeFinish - $timeBeeStart[$inoutElemArray];
					push (@timeBeeDBOut,$timeBeeDiff);
					$inArray[$inoutElemArray] = 1;
				}
		
	# Reactivate channels

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
		print "Time for bee to get Inside: $timeBeeDBIn\n";
	}


#foreach $timeBeeDBOut (@timeBeeDBOut)
#	{
#		print "Time for bee to get Outside: $timeBeeDBOut\n";
	#

sub sendDB
	{
		print "Data sent to DB\n";
	}

############################################## Subroutines #########################################################
