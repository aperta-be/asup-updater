---
layout: default
title: Markdown Style Guide
nav_order: 7
---

# Markdown Style Guide

This document describes the markdown rules and conventions used in ASUP documentation.

## Rules Overview

We use markdownlint to enforce consistent markdown formatting. Here's what each rule ensures:

### Headers

- `MD001`: Headers must increment by one level at a time
- `MD002`: First header must be a top-level header (h1)
- `MD003`: Headers must use ATX style (`#` syntax)
- `MD025`: Only one top-level header per document
- `MD041`: First content must be a top-level header

### Lists

- `MD004`: Unordered lists must use dashes (`-`)
- `MD005`: List indentation must be consistent
- `MD006`: Unordered lists must start at the beginning of the line
- `MD007`: Unordered list indentation must be 2 spaces
- `MD029`: Ordered lists must use "1." or sequential numbers
- `MD030`: List markers must be followed by a single space
- `MD032`: Lists must be surrounded by blank lines

### Spacing

- `MD009`: No trailing spaces except for line breaks (2 spaces)
- `MD010`: No hard tabs (use spaces)
- `MD012`: No multiple consecutive blank lines
- `MD018`-`MD021`: Spaces around header markers
- `MD022`: Headers must be surrounded by blank lines
- `MD023`: Headers must start at the beginning of the line
- `MD027`: No multiple spaces after blockquote marker
- `MD028`: No blank lines within blockquote
- `MD031`: Fenced code blocks must be surrounded by blank lines

### Content

- `MD011`: No reversed links (`[text](url)` not `(url)[text]`)
- `MD013`: Line length limit (120 characters, excluding code and tables)
- `MD014`: Dollar signs used before commands with output
- `MD024`: No duplicate headers (within siblings)
- `MD026`: No punctuation at end of headers
- `MD033`: No inline HTML (except `<br>`, `<details>`, `<summary>`)
- `MD034`: No bare URLs
- `MD035`: Horizontal rules must use three hyphens (`---`)
- `MD036`: No emphasis used instead of headers
- `MD037`: No spaces inside emphasis markers
- `MD038`: No spaces inside code span markers
- `MD039`: No spaces inside link markers
- `MD040`: Fenced code blocks must have a language specified
- `MD042`: No empty links
- `MD044`: Proper names must be capitalized
- `MD045`: Images must have alt text
- `MD047`: Files must end with a single newline character

### Code Blocks

- `MD046`: Code blocks must use fenced style (backticks)
- `MD048`: Code fence style must use backticks

### Emphasis

- `MD049`: Emphasis style must use underscores
- `MD050`: Strong emphasis style must use asterisks

## Examples

### Headers

```markdown
# Top-level Header

## Second-level Header

### Third-level Header
```

### Lists

```markdown
- First item
- Second item
  - Nested item
  - Another nested item
- Third item

1. First ordered item
2. Second ordered item
   1. Nested ordered item
   2. Another nested item
3. Third ordered item
```

### Code Blocks

```markdown
```php
echo "Hello, world!";
```
```

### Links and Images

```markdown
[Link text](https://example.com)
![Alt text](image.png "Optional title")
```

### Emphasis

```markdown
This is _emphasized_ text.
This is **strong** text.
```

## Best Practices

1. **Headers**: Use sentence case for headers
2. **Lists**: Keep list items parallel in structure
3. **Code**: Always specify the language for code blocks
4. **Links**: Use descriptive link text
5. **Images**: Always provide meaningful alt text
6. **Emphasis**: Use emphasis sparingly and consistently

## Automated Checking

Our CI pipeline automatically checks markdown files using these rules. You can run the checks locally:

```bash
npm install -g markdownlint-cli
markdownlint '**/*.md'
```

## Additional Resources

- [Markdownlint Rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- [GitHub Markdown Guide](https://guides.github.com/features/mastering-markdown/)
- [CommonMark Spec](https://spec.commonmark.org/)