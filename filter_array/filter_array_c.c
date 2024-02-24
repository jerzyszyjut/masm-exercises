#include <stdio.h>

extern int* tablica_nieparzystych(int tablica[], unsigned int* n);

int main()
{
	int tab[] = { 2, 2, 4, 2, 6, 8, 2 };
	int znalezione_nieparzyste = 7;
	int* tab2 = tablica_nieparzystych(tab, &znalezione_nieparzyste);

	printf_s("Znalezione liczby nieparzyste: %d\nTe liczby to:\n", znalezione_nieparzyste);
	for (int i = 0; i < znalezione_nieparzyste; i++)
	{
		printf_s("%d, ", tab2[i]);
	}
	return 0;
}
