#include <stdio.h>

extern float nowy_exp(float x);

int main()
{
	float wynik = nowy_exp(3.0);
	printf("%f", wynik);
	return 0;
}
