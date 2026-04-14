#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT_DIR="$SCRIPT_DIR/input"
OUT_MD5_DIR="$SCRIPT_DIR/output/md5"
OUT_AES_DIR="$SCRIPT_DIR/output/aes"
TOOLS_DIR="$SCRIPT_DIR/tools"
MD5COLLGEN="$TOOLS_DIR/md5collgen"

mkdir -p "$INPUT_DIR" "$OUT_MD5_DIR" "$OUT_AES_DIR" "$TOOLS_DIR"

# Q3.1: Create exactly 64-byte prefix file
python3 -c "print('A' * 64, end='')" > "$OUT_MD5_DIR/prefix.txt"
wc -c "$OUT_MD5_DIR/prefix.txt"

# Q3.1: Generate collision files and verify same MD5
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
	docker run --rm --platform linux/amd64 -v "$SCRIPT_DIR":/work -w /work ubuntu:22.04 bash -lc "chmod +x tools/md5collgen && tools/md5collgen -p output/md5/prefix.txt -o output/md5/out1.bin output/md5/out2.bin"
else
	if [[ "$(uname -s)" == "Linux" ]] && [[ -x "$MD5COLLGEN" ]]; then
		"$MD5COLLGEN" -p "$OUT_MD5_DIR/prefix.txt" -o "$OUT_MD5_DIR/out1.bin" "$OUT_MD5_DIR/out2.bin"
	else
		echo "md5collgen requires Docker on macOS. Start Docker Desktop, then rerun this script."
		exit 1
	fi
fi
md5sum "$OUT_MD5_DIR/out1.bin" "$OUT_MD5_DIR/out2.bin"

# Q3.1: Find all differing bytes
xxd "$OUT_MD5_DIR/out1.bin" > "$OUT_MD5_DIR/out1.hex"
xxd "$OUT_MD5_DIR/out2.bin" > "$OUT_MD5_DIR/out2.hex"
diff "$OUT_MD5_DIR/out1.hex" "$OUT_MD5_DIR/out2.hex" || true

# Q3.3: Key and IV used for this run
KEY_1="31323331323331323331323331323331"
IV_1="33323133323133323133323133323133"

# AES-128-ECB encryption/decryption (no IV)
openssl enc -aes-128-ecb -e -in "$INPUT_DIR/original.bmp" -out "$OUT_AES_DIR/ecb_encrypted.bin" -K "$KEY_1" -nosalt
openssl enc -aes-128-ecb -d -in "$OUT_AES_DIR/ecb_encrypted.bin" -out "$OUT_AES_DIR/ecb_decrypted.bmp" -K "$KEY_1" -nosalt

# AES-128-CBC encryption/decryption (requires IV)
openssl enc -aes-128-cbc -e -in "$INPUT_DIR/original.bmp" -out "$OUT_AES_DIR/cbc_encrypted.bin" -K "$KEY_1" -iv "$IV_1" -nosalt
openssl enc -aes-128-cbc -d -in "$OUT_AES_DIR/cbc_encrypted.bin" -out "$OUT_AES_DIR/cbc_decrypted.bmp" -K "$KEY_1" -iv "$IV_1" -nosalt

# Make encrypted outputs viewable as BMP by preserving original 54-byte header
head -c 54 "$INPUT_DIR/original.bmp" > "$OUT_AES_DIR/ecb_visual.bmp"
tail -c +55 "$OUT_AES_DIR/ecb_encrypted.bin" >> "$OUT_AES_DIR/ecb_visual.bmp"

head -c 54 "$INPUT_DIR/original.bmp" > "$OUT_AES_DIR/cbc_visual.bmp"
tail -c +55 "$OUT_AES_DIR/cbc_encrypted.bin" >> "$OUT_AES_DIR/cbc_visual.bmp"
