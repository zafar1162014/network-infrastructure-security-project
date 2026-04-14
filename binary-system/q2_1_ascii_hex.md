# ASCII and Hexadecimal

## Question

Convert a sample text string into ASCII decimal and hexadecimal values.

## Solution

Sample input used:

`network`

Step-by-step conversion:

1. Split into characters: n, e, t, w, o, r, k
2. Convert each character to ASCII decimal.
3. Convert each decimal value to hexadecimal.

## Result Table

| Character | Decimal | Hex |
| --------- | ------: | --: |
| n         |     110 |  6E |
| e         |     101 |  65 |
| t         |     116 |  74 |
| w         |     119 |  77 |
| o         |     111 |  6F |
| r         |     114 |  72 |
| k         |     107 |  6B |

Hex output:

`6E 65 74 77 6F 72 6B`

## Python Verification

```python
text = "network"

print("Character | Decimal | Hex")
print("--------- | ------- | ---")
hex_values = []

for ch in text:
    dec = ord(ch)
    hx = format(dec, "02X")
    hex_values.append(hx)
    print(f"{ch} | {dec} | {hx}")

print("\nHex output:", " ".join(hex_values))
```
