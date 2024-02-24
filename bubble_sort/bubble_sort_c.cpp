#include <iostream>

using namespace std;

extern "C" void bubblesort(int tabl[], int n);

int main()
{
	int tab[] = { 4, 3, 2, 1 };
	bubblesort(tab, 4);
	for (int i = 0; i < 4; i++) 
	{
		cout << tab[i] << " ";
	}
	return 0;
}