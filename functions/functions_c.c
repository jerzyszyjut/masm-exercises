#include <stdio.h>
#define rozmiar_tab1 10

typedef int MIESZ32;

float miesz2float(MIESZ32 p);

void call_miesz2float()
{
	float wynik = miesz2float(0b111000000); // wynik = 1.0 + 0.5 + 0.25 = 1.75
	
	printf("%f", wynik);

	return;
}

float pomnoz32(float a);

void call_pomnoz32()
{
	float wynik = pomnoz32(2.5); // wynik = 80
	
	printf("%f", wynik);

	return;
}

float float_razy_float(float a, float b);

void call_float_razy_float()
{
	float wynik = float_razy_float(1.5f, 3.6f); // wynik = 5.4

	printf("%f", wynik);

	return;
}

double plus_jeden_double(double a);

void call_plus_jeden_double()
{
	printf("%f", plus_jeden_double(1.5)); // wynik = 2.5

	return;
}


int roznica(int* odjemna, int** odjemnik);

void call_roznica()
{
	int a, b, * wsk, wynik;
	wsk = &b;
	a = 21;
	b = 25;
	wynik = roznica(&a, &wsk); 

	printf("%d", wynik); // wynik = -4

	return;
}

int* kopia_tablicy(int tab1[], unsigned int n);

void call_kopia_tablicy()
{
	int tab[rozmiar_tab1] = { 1, 2, 3, 4, 5, 5, 6, 7, 8, 8 };

	int* wynik = kopia_tablicy(tab, rozmiar_tab1);

	for (int i = 0; i < rozmiar_tab1; i++)
	{
		printf("%d ", wynik[i]); // wynik = 0, 2, 0, 4, 0, 0, 6, 0, 8, 8
	}

	return;
}

char* komunikat(char* tekst);

void call_komunikat()
{
	char* tekst1 = "To jest moj tekst.";
	int dlugosc = 18;
	char* tekst2 = komunikat(tekst1);
	for (int i = 0; i < (dlugosc + 5); i++) {
		printf("%c", tekst2[i]); // wynik = To jest moj tekst.B³¹d.
	}
	
	return;
}

int* szukaj_elem_min(int tablica[], int n);

void call_szukaj_elem_min()
{
	int* wsk, pomiary[] = { 6, 2, 89, -20, -4, 2 , 0};
	wsk = szukaj_elem_min(pomiary, 7); // wynik = wskaŸnik na -20
	printf("%d", *wsk);

	return;
}

void szyfruj(char* tekst);

void call_szyfruj()
{
	char tekst[] = "tajny tekscik do zaszyfrowania";
	szyfruj(tekst);

	for (int i = 0; i < 30; i++) {
		printf("%c", tekst[i]);
	}

	return;
}

int main()
{
	call_szyfruj();

	return 0;
}