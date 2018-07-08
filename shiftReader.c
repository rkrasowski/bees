#include <wiringPi.h>
#include <stdio.h>

int bit;
int a;


int main (void)
	{	
		wiringPiSetup();
		pinMode (2, OUTPUT);
		pinMode (3, OUTPUT);
		pinMode (0, INPUT);


		digitalWrite (3,LOW);
		digitalWrite (3,HIGH);


		for (a = 1; a<24; a=a+1)

			{

				digitalWrite (2, HIGH);
				digitalWrite (2, LOW);
				bit = digitalRead (0);
				printf("%d", bit);


			}
		return 0;
	}
