#include <stdio.h>

extern "C" int szukaj_max(int a, int b, int c, int d);

int main()
{
	int a, b, c, d, wynik;
	printf("\nProsz� poda� cztery liczby ca�kowite ze znakiem: ");
	scanf_s("%d %d %d %d", &a, &b, &c, &d);
	wynik = szukaj_max(a, b, c, d);
	printf("\nSpo�r�d podanych liczb %d, %d, %d, %d, liczba %d jest najwi�ksza\n", a, b, c, d, wynik);
	return 0;
}