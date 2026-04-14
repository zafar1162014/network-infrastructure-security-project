# Data Protection

## Q3.1 MD5 Collision

### Required Commands

```bash
python3 -c "print('A' * 64, end='')" > output/md5/prefix.txt
wc -c output/md5/prefix.txt
./tools/md5collgen -p output/md5/prefix.txt -o output/md5/out1.bin output/md5/out2.bin
md5sum output/md5/out1.bin output/md5/out2.bin
xxd output/md5/out1.bin > output/md5/out1.hex
xxd output/md5/out2.bin > output/md5/out2.hex
diff output/md5/out1.hex output/md5/out2.hex
```

### Results

- Prefix file length check:
  - `wc -c output/md5/prefix.txt` -> `64 output/md5/prefix.txt`
- MD5 output of out1.bin:
  - bcdbdc98aa2c90cd258c5883fb36daab output/md5/out1.bin
- MD5 output of out2.bin:
  - bcdbdc98aa2c90cd258c5883fb36daab output/md5/out2.bin
- Are the generated 128-byte blocks completely different?
  - No. They are not completely different byte-for-byte.
  - Only a few specific byte positions differ, while many bytes stay the same.
  - The collision works because the changed bytes are chosen so the final MD5 digest stays identical.
- Differing byte offsets:
  - 84
  - 110
  - 111
  - 124
  - 148
  - 174
  - 188
  - These offsets match the positions reported by `cmp -l output/md5/out1.bin output/md5/out2.bin`.
- Screenshot references:
  - screenshots/01_prefix_64bytes.png
  - screenshots/02_md5collgen_run.png
  - screenshots/03_same_md5_hash.png
  - screenshots/04_byte_diff.png

## Q3.2 Collision Abuse Scenario

### Attack Explanation

I’d explain the attack like this:

1. The attacker prepares two files that begin the same way: one harmless-looking and one malicious.
2. Using md5collgen, they create collision blocks so both files end up with the same MD5 hash.
3. They submit the harmless version for approval.
4. The authority signs or records the MD5 for that harmless file.
5. Later, the attacker replaces it with the malicious twin.
6. Since the MD5 is still the same, a basic MD5 check treats it as valid.

### Why MD5 Verification Fails

- MD5 is broken for collisions, so two different inputs can end up with the same digest.
- If the checker only looks at MD5, it cannot tell which version it received.
- That is why the malicious file can pass as if it were the approved one.

## Q3.3 AES ECB/CBC on BMP

### Commands

### Values

- KEY_1 used:
  - KEY_1=31323331323331323331323331323331
- IV_1 used:
  - IV_1=33323133323133323133323133323133

### Encryption and Decryption Commands

```bash
openssl enc -aes-128-ecb -e -in input/original.bmp -out output/aes/ecb_encrypted.bin -K "$KEY_1" -nosalt
openssl enc -aes-128-cbc -e -in input/original.bmp -out output/aes/cbc_encrypted.bin -K "$KEY_1" -iv "$IV_1" -nosalt
openssl enc -aes-128-ecb -d -in output/aes/ecb_encrypted.bin -out output/aes/ecb_decrypted.bmp -K "$KEY_1" -nosalt
openssl enc -aes-128-cbc -d -in output/aes/cbc_encrypted.bin -out output/aes/cbc_decrypted.bmp -K "$KEY_1" -iv "$IV_1" -nosalt
head -c 54 input/original.bmp > output/aes/ecb_visual.bmp && tail -c +55 output/aes/ecb_encrypted.bin >> output/aes/ecb_visual.bmp
head -c 54 input/original.bmp > output/aes/cbc_visual.bmp && tail -c +55 output/aes/cbc_encrypted.bin >> output/aes/cbc_visual.bmp
```

### Visual Observations

- ECB encrypted image:
  - ECB keeps identical blocks identical, so parts of the picture can still be recognised.
  - In output/aes/ecb_visual.bmp, some of the original pattern usually remains visible.
- CBC encrypted image:
  - CBC mixes each block with the previous one, so repeated patterns are hidden much better.
  - output/aes/cbc_visual.bmp looks much more random and does not reveal the image as clearly.

### Verification

The decrypted ECB and CBC files should match the original BMP when the commands are run with the correct key and IV.

- Decryption verification:
  - `cmp -s input/original.bmp output/aes/ecb_decrypted.bmp` -> ECB_DECRYPT_MATCH=YES
  - `cmp -s input/original.bmp output/aes/cbc_decrypted.bmp` -> CBC_DECRYPT_MATCH=YES

### Screenshot References

- screenshots/05_ecb_visual.png
- screenshots/06_cbc_visual.png
- screenshots/07_decryption_check.png
