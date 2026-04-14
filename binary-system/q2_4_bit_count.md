# Bit Count (4-bit)

## Question

Implement and explain a function that counts how many 1-bits are in a 4-bit value.

## Function

```c
int bitCount4bit(int x)
{
    int mask = 0x5;
    int halfSum = (x & mask) + ((x >> 1) & mask);
    int mask2 = 0x3;
    return (halfSum & mask2) + ((halfSum >> 2) & mask2);
}
```

## Solution

This function counts how many 1 bits are in a 4-bit value.

Operation count: 8 operations total.

1. x & mask
2. x >> 1
3. (x >> 1) & mask
4. add for halfSum
5. halfSum & mask2
6. halfSum >> 2
7. (halfSum >> 2) & mask2
8. final add

Example input used: `x = 0x6` (binary `0110`)

Step-by-step verification:

1. mask = 0101
2. x & mask = 0110 & 0101 = 0100
3. x >> 1 = 0011
4. (x >> 1) & mask = 0011 & 0101 = 0001
5. halfSum = 0100 + 0001 = 0101
6. mask2 = 0011
7. halfSum & mask2 = 0101 & 0011 = 0001
8. halfSum >> 2 = 0001
9. (halfSum >> 2) & mask2 = 0001 & 0011 = 0001
10. result = 0001 + 0001 = 0010

Result: bit count = 2.

## Python Verification

```python
x1 = 0x6

# Same logic as the C function
mask = 0x5
half_sum = (x1 & mask) + ((x1 >> 1) & mask)
mask2 = 0x3
result = (half_sum & mask2) + ((half_sum >> 2) & mask2)

# Reference check
reference = bin(x1).count("1")

print(f"x = {x1:04b}")
print("bitCount4bit result =", result)
print("reference count     =", reference)
print("match?", result == reference)
```
