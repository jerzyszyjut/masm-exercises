#include <stdio.h>

extern "C" void minus_jeden(int** a);

int main()
{
	int k;
	int* wsk;
	wsk = &k;
	printf("\nProsze napisac liczbe: ");
	scanf_s("%d", &k);
	minus_jeden(&wsk);
	printf("\nWynik = %d\n", k);
	return 0;
}