# De Morgan's Law

## Question

Verify the identity below for 4-bit values:

`~(x & y) == (~x) | (~y)`

## Solution Inputs

Use two example test pairs:

- x1 = 6 (0110)
- x2 = 4 (0100)
- y1 = 6 (0110)
- y2 = 1 (0001)

For 4-bit logic, I only take the complement inside 4 bits.

## Calculation Table

| x (bin) | y (bin) | x & y | ~(x & y) | ~x   | ~y   | (~x) \| (~y) | Result |
| ------- | ------- | ----- | -------- | ---- | ---- | ------------ | ------ |
| 0110    | 0110    | 0110  | 1001     | 1001 | 1001 | 1001         | Equal  |
| 0100    | 0001    | 0000  | 1111     | 1011 | 1110 | 1111         | Equal  |

### Row 1 Detailed Steps

1. x = 0110, y = 0110
2. x & y = 0110 & 0110 = 0110
3. ~(x & y) = ~0110 = 1001 (4-bit complement)
4. ~x = ~0110 = 1001
5. ~y = ~0110 = 1001
6. (~x) | (~y) = 1001 | 1001 = 1001
7. So the law holds for this row.

### Row 2 Detailed Steps

1. x = 0100, y = 0001
2. x & y = 0100 & 0001 = 0000
3. ~(x & y) = ~0000 = 1111 (4-bit complement)
4. ~x = ~0100 = 1011
5. ~y = ~0001 = 1110
6. (~x) | (~y) = 1011 | 1110 = 1111
7. So the law holds for this row too.

## Python Verification

```python
def nibble_bin(n):
    return format(n & 0xF, "04b")

rows = [(0x6, 0x6), (0x4, 0x1)]

for i, (x, y) in enumerate(rows, start=1):
    x_and_y = x & y
    left = (~x_and_y) & 0xF
    not_x = (~x) & 0xF
    not_y = (~y) & 0xF
    right = (not_x | not_y) & 0xF
    print(f"Row {i}")
    print("x=", nibble_bin(x), "y=", nibble_bin(y))
    print("x&y=", nibble_bin(x_and_y))
    print("~(x&y)=", nibble_bin(left))
    print("~x=", nibble_bin(not_x), "~y=", nibble_bin(not_y))
    print("(~x)|(~y)=", nibble_bin(right), "equal?", left == right)
    print()
```
