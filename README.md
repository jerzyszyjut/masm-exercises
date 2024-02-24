# masm-exercises
This repository contains the exercises that I have done during the course of Computer Architecture at Gdansk University of Technology. All of the exercises gave me a lot of fun and knowledge about the assembly language.

The exercises are written in MASM and are designed to be run on Windows in Visual Studio. Most of them are for x86 mode, some are for x64 mode. The exercises are divided into folders, each of which contains a separate exercise. Each exercise contains a description of the task, the code written in MASM, and a C code that uses the function written in MASM.

I also wrote a few programs in 16-bit mode, I will add them to repository when I will find them.

## Setup
For all exercises you need to turn on MASM by 'Solution Explorer' -> 'Build customizations' -> check 'masm' -> 'OK'. 

For exercises that are written only in MASM, without C code, you need to add `libcmt.lib` to the linker. You can do this by 'Solution Explorer' -> 'Properties' -> 'Linker' -> 'Command Line' -> 'Additional Options' -> add `libcmt.lib` -> 'OK'.

## Table of contents
- [Functions made before the exam](./functions/functions.md)
    - miesz2float - converts 32-bit fixed-point number to a floating-point number
    - pomnoz32 - multiplies a floating-point number by 32 without using FPU
    - float_razy_float - multiplies two floating-point numbers
    - plus_jeden_double - adds 1 to a double-precision floating-point number without using FPU
    - roznica - subtracts two integers
    - kopia_tablicy - creates a copy of an array
    - komunikat - creates a copy of a string with an additional message at the end
    - szukaj_elem_min - finds the smallest element in an array
    - szyfruj - encrypts a string
- [20 numbers of series](./20_numbers_of_series/20_numbers_of_serie.md)
- [Add two ASCII numbers](./ascii_add/ascii_add.md)
- [Bubble sort](./bubble_sort/bubble_sort.md)
- [Divide XMM arrays](./divide_xmm/divide_xmm.md)
- [Euler's number exponents](./euler_exponent/euler_exponent.md)
- [Filter out uneven numbers](./filter_array/filter_array.md)
- [Find the maximum value in an array](./find_max/find_max.md)
- [Fixed-point to floating-point conversion](./fixed_to_floating/fixed_to_floating.md)
- [Float times float without FPU](./float_times_float/float_times_float.md)
- [Harmonic mean](./harmonic_mean/harmonic_mean.md)
- [Matrix multiplication](./matrix_multiplication/matrix_multiplication.md)
- [Max of four](./max_of_four/max_of_four.md)
- [Minus one](./minus_one/minus_one.md)
- [Single neuron](./neuron/neuron.md)
- [Read and write in 13 symbols system](./read_write_13_system/read_write_13_system.md)
- [Calculate square of a numbers recursively](./recursive_square/recursive_square.md)
- [Rolling average](./rolling_average/rolling_average.md)
- [SSE operations](./sse_operations/sse_operations.md)
- [Sum of numbers after `call` instruction](./sum_numbers_after_call_instruction/sum_numbers_after_call_instruction.md)
- [Sum of seven numbers](./sum_of_seven/sum_of_seven.md)
- [UTF-8 to UTF-16 conversion](./utf_8_to_utf_16/utf_8_to_utf_16.md)
- [Write EAX contents in many number systems](./write_eax/write_eax.md)
- [Write ten Euler exponents to the console](./write_ten_euler_exponents/write_ten_euler_exponents.md)
