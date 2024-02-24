#include <stdio.h>

extern float srednia_harm(float* tablica, unsigned int n);

int main()
{
	float tablica[] = { 0.5f, 0.25f, 0.125f };
	unsigned int n = 3;

	float wynik = srednia_harm(tablica, n);
	printf("%f", wynik);

	return 0;
}
