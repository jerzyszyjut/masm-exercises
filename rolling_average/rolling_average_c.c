#include <stdio.h>

float progowanie_sredniej_kroczacej(float* tablica, unsigned int k, unsigned int m);

int main()
{
	float tablica[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 5.0, 9.0, 10.0, 100.0};
	unsigned int k = 10, m = 2;
	float tablica[] = { 1, 2, 3, 1, 2, 1, 7, 8, 9 };
	float wynik = progowanie_sredniej_kroczacej(tablica, k, m);
	printf("%f", wynik);

	return 0;
}
