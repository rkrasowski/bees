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
		delay(1);
		digitalWrite (3,HIGH);
		
		bit = digitalRead(0);

		for (a = 0; a<24; a=a+1)

			{

				printf("%d",bit);
				digitalWrite (2, HIGH);
				delay(1);
				digitalWrite (2, LOW);
				delay(1);
				bit = digitalRead (0);

			}
		return 0;
	}
