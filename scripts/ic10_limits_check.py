#!/usr/bin/env python3
"""Validate IC10 source files against in-game limits."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

MAX_LINES = 128
MAX_BYTES = 4096
MAX_CHARS = 52


def gather_paths(argv: list[str]) -> list[Path]:
    """Return the list of .ic10 files to validate."""
    if argv:
        return [Path(arg) for arg in argv if arg.endswith(".ic10")]

    try:
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only"],
            check=True,
            capture_output=True,
            text=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return []

    paths: list[Path] = []
    for line in result.stdout.splitlines():
        line = line.strip()
        if line.endswith(".ic10"):
            path = Path(line)
            if path.exists():
                paths.append(path)
    return paths


def check_file(path: Path) -> list[str]:
    """Return a list of violations for a single IC10 file."""
    errors: list[str] = []
    try:
        data = path.read_bytes()
    except OSError as exc:
        errors.append(f"{path}: unable to read file ({exc})")
        return errors

    size = len(data)
    if size > MAX_BYTES:
        errors.append(f"{path}: byte count {size} > {MAX_BYTES}")

    text = data.decode("utf-8", errors="replace")
    lines = text.splitlines()
    if len(lines) > MAX_LINES:
        errors.append(f"{path}: line count {len(lines)} > {MAX_LINES}")

    for idx, line in enumerate(lines, start=1):
        if len(line) > MAX_CHARS:
            errors.append(f"{path}:{idx}: line length {len(line)} > {MAX_CHARS}")
    return errors


def main(argv: list[str]) -> int:
    paths = gather_paths(argv)
    if not paths:
        return 0

    violations: list[str] = []
    for path in paths:
        violations.extend(check_file(path))

    if violations:
        print("IC10 compliance errors:", file=sys.stderr)
        print("\n".join(violations), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

