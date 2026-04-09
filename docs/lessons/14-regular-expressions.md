# Lesson 14 — Regular Expressions

> **Goal:** Learn the pattern-matching language used by `grep`, `sed`, `awk`, and many other tools.

---

## What are Regular Expressions?

A **regular expression** (regex) is a pattern that describes a set of strings. Instead of searching for an exact word, you describe *what the text looks like*.

Examples of what regex can match:

- Any line starting with "ERROR"
- An email address
- A date in YYYY-MM-DD format
- Any word followed by a number

---

## Basic vs Extended Regex

Linux tools support two flavors:

| Flavor | Used By | How to Enable |
| ------ | ------- | ------------- |
| Basic (BRE) | `grep`, `sed` | Default |
| Extended (ERE) | `grep -E`, `sed -E`, `awk` | Add `-E` flag |

The main difference: in BRE you must escape `()`, `{}`, `+`, and `|` with backslashes. ERE uses them directly. This lesson uses ERE (extended) since it is easier to read.

---

## Literal Characters

Most characters match themselves:

```bash
# Match lines containing "ERROR"
grep "ERROR" practice/sample.log

# Match lines containing "hello"
echo -e "hello\nworld\nhello world" | grep "hello"
```

---

## Anchors — Where to Match

Anchors do not match characters. They match *positions*.

| Anchor | Meaning | Example | Matches |
| ------ | ------- | ------- | ------- |
| `^` | Start of line | `^ERROR` | Lines starting with ERROR |
| `$` | End of line | `done$` | Lines ending with done |
| `\b` | Word boundary | `\bcat\b` | "cat" but not "category" |

```bash
# Lines that START with INFO
grep "^INFO" practice/sample.log

# Lines that END with "found"
grep "found$" practice/sample.log

# Empty lines
grep "^$" practice/sample.log

# Non-empty lines
grep -v "^$" practice/sample.log
```

---

## Character Classes — What to Match

### The Dot (`.`)

`.` matches **any single character** except newline:

```bash
# h followed by any char followed by t
echo -e "hat\nhot\nhit\nhurt" | grep -E "h.t"
# hat, hot, hit
```

### Square Brackets (`[]`)

Match **one character** from a set:

```bash
# Match a, e, i, o, or u
echo -e "bat\nbet\nbit\nbut\nbyt" | grep -E "b[aeiou]t"
# bat, bet, bit, but

# Match a range
echo -e "a1\nb2\nc3\nd4" | grep -E "[a-c]"

# Match digits
echo -e "abc\n123\ndef\n456" | grep -E "[0-9]"

# Match uppercase letters
echo -e "Hello\nhello\nHELLO" | grep -E "[A-Z]"
```

### Negated Character Classes (`[^]`)

Match any character **NOT** in the set:

```bash
# Lines NOT starting with a digit
echo -e "1abc\nabc\n2def\ndef" | grep -E "^[^0-9]"

# Characters that are not vowels (-o prints only the matched parts, not the whole line)
echo "hello" | grep -oE "[^aeiou]"
```

### POSIX Character Classes

Named classes that work across locales:

| Class | Matches | Equivalent |
| ----- | ------- | ---------- |
| `[:alpha:]` | Letters | `[a-zA-Z]` |
| `[:digit:]` | Digits | `[0-9]` |
| `[:alnum:]` | Letters and digits | `[a-zA-Z0-9]` |
| `[:space:]` | Whitespace | `[ \t\n\r]` |
| `[:upper:]` | Uppercase letters | `[A-Z]` |
| `[:lower:]` | Lowercase letters | `[a-z]` |
| `[:punct:]` | Punctuation | |

```bash
# Match lines containing digits
grep "[[:digit:]]" /etc/passwd

# Match lines starting with a letter
grep "^[[:alpha:]]" practice/sample.log
```

---

## Quantifiers — How Many to Match

Quantifiers control how many times the preceding element must appear:

| Quantifier | Meaning | Example | Matches |
| ---------- | ------- | ------- | ------- |
| `*` | 0 or more | `ab*c` | ac, abc, abbc, abbbc |
| `+` | 1 or more | `ab+c` | abc, abbc, abbbc (not ac) |
| `?` | 0 or 1 | `colou?r` | color, colour |
| `{n}` | Exactly n | `a{3}` | aaa |
| `{n,}` | n or more | `a{2,}` | aa, aaa, aaaa |
| `{n,m}` | Between n and m | `a{2,4}` | aa, aaa, aaaa |

```bash
# Words with double letters
echo -e "book\nbat\nfeel\nfed" | grep -E "(.)\1"

# One or more digits
echo -e "abc\na1b\na123b" | grep -E "[0-9]+"

# Optional 's' for plural
echo -e "cat\ncats\ndog\ndogs" | grep -E "cats?"

# Exactly 3 digits
echo -e "12\n123\n1234" | grep -E "^[0-9]{3}$"

# Between 2 and 4 digits
echo -e "1\n12\n123\n1234\n12345" | grep -E "^[0-9]{2,4}$"
```

---

## Alternation (`|`) — OR

Match **this** or **that**:

```bash
# Lines with ERROR or WARN
grep -E "ERROR|WARN" practice/sample.log

# Match cat or dog
echo -e "I have a cat\nI have a dog\nI have a fish" | grep -E "cat|dog"
```

---

## Grouping (`()`)

Parentheses group parts of a pattern:

```bash
# Match "gray" or "grey"
echo -e "gray\ngrey\ngreen" | grep -E "gr(a|e)y"

# Repeat a group
echo -e "abab\nabcabc\nab" | grep -E "(ab){2}"
```

---

## Escape Special Characters (`\`)

To match a literal special character, escape it with `\`:

```bash
# Match a literal dot (not "any character")
echo -e "file.txt\nfiletxt" | grep -E "file\.txt"

# Match a literal dollar sign
echo -e "price: \$10\nprice: 10" | grep -E '\$[0-9]+'

# Match square brackets
echo "[WARNING] test" | grep -E '\[WARNING\]'
```

Special characters that need escaping: `. * + ? | ( ) [ ] { } ^ $ \`

---

## Using Regex with `grep`

You already know basic `grep` flags from Lesson 04. Here is a complete reference for using `grep` with regex:

| Flag | Meaning |
| ---- | ------- |
| `-E` | Use extended regex (ERE) — enables `+`, `\|`, `()`, `{}` without escaping |
| `-o` | Print only the matched text, not the entire line |
| `-i` | Case-insensitive matching |
| `-c` | Print a count of matching lines instead of the lines themselves |
| `-n` | Prefix each match with its line number |
| `-v` | Invert — show lines that do NOT match |
| `-q` | Quiet — produce no output, just set the exit code (useful in scripts) |
| `-w` | Match whole words only |
| `-r` | Search recursively in directories |

```bash
# -E for extended regex
grep -E "pattern" file

# -i for case insensitive
grep -Ei "error|warn" practice/sample.log

# -o to show only the matching part (not the whole line)
echo "My email is user@example.com" | grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
# Output: user@example.com  (without -o it would show the entire line)

# -c to count matches
grep -Ec "ERROR" practice/sample.log

# -n to show line numbers
grep -En "ERROR|WARN" practice/sample.log

# -v to invert (show non-matching lines)
grep -Ev "^#|^$" /etc/passwd    # Skip comments and blank lines

# -q for silent checks in scripts (exit code 0 = found, 1 = not found)
if grep -qE "ERROR" practice/sample.log; then
    echo "Errors found!"
fi

# -w to match whole words only
echo -e "cat\ncategory\nconcatenate" | grep -w "cat"
# Output: cat  (not category or concatenate)
```

---

## Using Regex with `sed`

```bash
# Replace digits with X (-E = extended regex; g = global, replace all on each line)
echo "Phone: 123-456-7890" | sed -E 's/[0-9]/X/g'

# Remove everything in parentheses
# \( and \) match literal parentheses; [^)]* = any chars except )
echo "Hello (world) today" | sed -E 's/\([^)]*\)//g'

# Extract text between quotes
# .* = anything before the first quote; \1 = the captured group inside ()
echo 'He said "hello" to her' | sed -E 's/.*"(.*)".*/ \1/'

# Back-references — swap two words
# \1 and \2 refer to the first and second captured groups
echo "hello world" | sed -E 's/(hello) (world)/\2 \1/'
```

---

## Using Regex with `awk`

```bash
# Match lines where field 7 matches a pattern
# -F: = colon field separator; ~ = regex match operator
awk -F: '$7 ~ /bash/' /etc/passwd

# Match lines where field 1 starts with "s" (^ = start of string)
awk -F: '$1 ~ /^s/' /etc/passwd

# Negate a match (!~ = does NOT match)
awk -F: '$7 !~ /nologin/' /etc/passwd
```

---

## Common Regex Patterns

| What | Pattern |
| ---- | ------- |
| Email address | `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}` |
| IP address (simple) | `[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}` |
| Date (YYYY-MM-DD) | `[0-9]{4}-[0-9]{2}-[0-9]{2}` |
| Blank line | `^$` |
| Leading whitespace | `^[[:space:]]+` |
| Whole number | `^[0-9]+$` |
| Comment line (# style) | `^[[:space:]]*#` |

---

## Exercises

1. Use `grep -E` (`-E` = extended regex) to find all lines in `/etc/passwd` that end with `/bin/bash`.
2. Match all lines in `practice/sample.log` that start with either `INFO` or `ERROR`.
3. Use `sed -E` to mask all digits in `practice/sample.log` by replacing them with `#`.
4. Write a regex that matches a simple date format like `03/15/2026` or `12/31/1999` and test it with `grep -E`.
5. Use `awk` to print lines from `/etc/passwd` where the username (field 1) is exactly 4 characters long.

---

## Challenge

Create a script `~/practice/validate.sh` that reads lines from stdin and classifies each line as:

- "EMAIL" if it looks like an email address
- "IP" if it looks like an IP address
- "DATE" if it matches YYYY-MM-DD format
- "OTHER" otherwise

Test it with:

```bash
echo -e "user@example.com\n192.168.1.1\n2026-03-13\nhello world" | ~/practice/validate.sh
```

<!-- markdownlint-disable MD033 -->
<details>
<summary>💡 Solution</summary>

```bash
cat > ~/practice/validate.sh << 'SCRIPT'
#!/bin/bash

while IFS= read -r line; do
    if echo "$line" | grep -qE '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; then
        echo "EMAIL: $line"
    elif echo "$line" | grep -qE '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'; then
        echo "IP:    $line"
    elif echo "$line" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
        echo "DATE:  $line"
    else
        echo "OTHER: $line"
    fi
done
SCRIPT

chmod +x ~/practice/validate.sh
echo -e "user@example.com\n192.168.1.1\n2026-03-13\nhello world" | ~/practice/validate.sh
```

</details>
<!-- markdownlint-enable MD033 -->

---

**[← Lesson 13](13-text-processing.md)** | **[Lesson 15 →](15-shell-customization.md)**
