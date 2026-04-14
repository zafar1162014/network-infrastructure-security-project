# Bit Parity (4-bit)

## Question

Implement and explain a 4-bit parity function.

```c
int bitParity4bit(int x)
{
    x ^= (x >> 2);
    x ^= (x >> 1);
    return x & 1;
}
```

## Solution

Goal:

- Return `0` when the number of 1-bits is even.
- Return `1` when the number of 1-bits is odd.

Operation count:

- Total operations = 5 (`>>`, `^`, `>>`, `^`, `&`), within an 8-op limit.

Example input used: `x = 0x6` (binary `0110`)

Step-by-step:

1. Start: `x = 0110`
2. `x >> 2 = 0001`
3. `x ^= (x >> 2)` -> `0110 ^ 0001 = 0111`
4. `x >> 1 = 0011`
5. `x ^= (x >> 1)` -> `0111 ^ 0011 = 0100`
6. `x & 1` -> `0100 & 0001 = 0000`

Result: parity is `0` (even parity).

## Manual Check

Bits in `0110` are `0, 1, 1, 0`.

- Number of 1-bits = 2
- 2 is even
- Output = 0

## Function

```c
int bitParity4bit(int x)
{
    x ^= (x >> 2);
    x ^= (x >> 1);
    return x & 1;
}
```
