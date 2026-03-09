#!/usr/bin/env python3
import shutil
import sys
import time
from pathlib import Path


def copy_pdbs(source_root: Path, stash_root: Path):
    for pdb in source_root.glob("**/*.pdb"):
        if not pdb.is_file():
            continue
        relative_path = pdb.relative_to(source_root)
        target = stash_root / relative_path
        if target.exists() and target.stat().st_mtime_ns >= pdb.stat().st_mtime_ns:
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(pdb, target)


def main():
    once = len(sys.argv) == 4 and sys.argv[3] == "--once"
    if len(sys.argv) not in (3, 4) or (len(sys.argv) == 4 and not once):
        raise SystemExit("usage: stash_vcpkg_pdbs.py <source_root> <stash_root> [--once]")

    source_root = Path(sys.argv[1]).resolve()
    stash_root = Path(sys.argv[2]).resolve()
    stash_root.mkdir(parents=True, exist_ok=True)

    while True:
        copy_pdbs(source_root, stash_root)
        if once:
            return
        time.sleep(1)


if __name__ == "__main__":
    main()
