#include <stdio.h>

extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64
	v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);

int main()
{
	__int64 wynik = suma_siedmiu_liczb(1, 1, 1, 5, 1, 1, 1);
	printf("\nSuma wynosi %I64d\n", wynik);

	return 0;
}
