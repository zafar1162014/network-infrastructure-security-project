# Network Infrastructure Security Project

This repository documents a complete set of networking and security exercises, including written analysis, reproducible commands, and screenshot evidence.

## Questions and Answers

### Q1. What is this project about?

This project demonstrates practical understanding of:

1. Security principles and threat-aware reasoning
2. Binary logic and low-level operations
3. Data protection techniques (MD5 collision exercise and AES mode behavior)
4. Network traffic and firewall policy design

### Q2. What is included in the repository?

The repository is organized into four folders:

1. `security-principles`
   Contains scenario-based answers for core security principles.
2. `binary-system`
   Contains ASCII/hex conversion, De Morgan verification, parity logic, and bit-count tasks.
3. `data-protection`
   Contains MD5 collision workflow, AES ECB/CBC experiments, scripts, generated outputs, and screenshots.
4. `network-firewall`
   Contains Docker network setup, packet-capture observations, firewall rules, and validation evidence.

### Q3. How do I review the work quickly?

1. Start with the written answers:
   - `security-principles/answers.md`
   - `binary-system/q2_1_ascii_hex.md`
   - `binary-system/q2_2_demorgan.md`
   - `binary-system/q2_3_bit_parity.md`
   - `binary-system/q2_4_bit_count.md`
   - `data-protection/answers.md`
   - `network-firewall/answers.md`
2. Then review scripts used for reproduction:
   - `data-protection/commands.sh`
   - `network-firewall/firewall_rules.sh`
3. Finally, check screenshot evidence under:
   - `data-protection/screenshots`
   - `network-firewall/screenshots`

### Q4. How can I reproduce key parts of the project?

From the project root:

```bash
cd data-protection
bash commands.sh

cd ../network-firewall
docker compose up -d
# apply firewall rules when inside the router container or with appropriate privileges
```

Notes:

1. Some commands require Docker.
2. Firewall commands require elevated privileges.
3. Output files and screenshots are already included for verification.

### Q5. What does this project show from a skills perspective?

It shows ability to:

1. Explain security concepts using real-world scenarios
2. Work confidently with binary and bit-level logic
3. Demonstrate cryptographic weaknesses and encryption mode differences
4. Design and validate stateless and stateful firewall behavior

## Repository Notes

The repository excludes local-only clutter such as macOS metadata and archive files through `.gitignore`.
