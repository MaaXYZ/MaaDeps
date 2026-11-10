#!/usr/bin/env python3
"""下载 MaaDeps CI 产物并解包到指定目录。

用法:
  GH_TOKEN=xxx python fetch_ci_artifact.py <run_id> [--repo Poplar477a/MaaDeps]
      [--target x64-windows] [--out <目录>] [--debug]

产物名: tarball-<target> / logs-<target>，内为 tarball/*.tar.xz。
"""
import argparse
import json
import os
import sys
import tarfile
import urllib.parse
import urllib.request
import zipfile
from pathlib import Path, PurePosixPath

API = "https://api.github.com"
MAX_DOWNLOAD_BYTES = 512 * 1024 * 1024
MAX_EXTRACTED_BYTES = 4 * 1024 * 1024 * 1024
MAX_MEMBERS = 200_000


class SafeRedirectHandler(urllib.request.HTTPRedirectHandler):
    """跨主机重定向时移除 Authorization，避免令牌泄露给下载 CDN。"""

    def redirect_request(self, req, fp, code, msg, headers, newurl):
        new_req = super().redirect_request(req, fp, code, msg, headers, newurl)
        if new_req is None:
            return None
        if urllib.parse.urlsplit(newurl).hostname != urllib.parse.urlsplit(req.full_url).hostname:
            new_req.remove_header("Authorization")
        return new_req


def api_get(url):
    req = urllib.request.Request(url, headers={
        "Authorization": "Bearer " + os.environ["GH_TOKEN"],
        "Accept": "application/vnd.github+json",
    })
    with urllib.request.urlopen(req) as r:
        return json.load(r)


def download(url, dst: Path):
    req = urllib.request.Request(url, headers={
        "Authorization": "Bearer " + os.environ["GH_TOKEN"],
        "Accept": "application/vnd.github+json",
    })
    opener = urllib.request.build_opener(SafeRedirectHandler)
    written = 0
    with opener.open(req) as r, open(dst, "wb") as f:
        while True:
            chunk = r.read(1024 * 1024)
            if not chunk:
                break
            written += len(chunk)
            if written > MAX_DOWNLOAD_BYTES:
                raise RuntimeError(f"artifact exceeds {MAX_DOWNLOAD_BYTES} bytes")
            f.write(chunk)


def _safe_target(dest: Path, member_name: str) -> Path:
    rel = PurePosixPath(member_name)
    if rel.is_absolute() or ".." in rel.parts:
        raise RuntimeError(f"unsafe archive member: {member_name}")
    target = (dest / rel).resolve()
    if dest.resolve() not in target.parents and target != dest.resolve():
        raise RuntimeError(f"archive member escapes output dir: {member_name}")
    return target


def safe_extract_tar(tar: tarfile.TarFile, dest: Path):
    total = 0
    members = tar.getmembers()
    if len(members) > MAX_MEMBERS:
        raise RuntimeError(f"archive has too many members: {len(members)}")
    for member in members:
        _safe_target(dest, member.name)
        if member.issym() or member.islnk():
            raise RuntimeError(f"archive contains links: {member.name}")
        total += max(member.size, 0)
        if total > MAX_EXTRACTED_BYTES:
            raise RuntimeError(f"archive expands beyond {MAX_EXTRACTED_BYTES} bytes")
    tar.extractall(dest, filter="data")


def safe_extract_zip(zf: zipfile.ZipFile, dest: Path):
    total = 0
    infos = zf.infolist()
    if len(infos) > MAX_MEMBERS:
        raise RuntimeError(f"archive has too many members: {len(infos)}")
    for info in infos:
        _safe_target(dest, info.filename)
        total += max(info.file_size, 0)
        if total > MAX_EXTRACTED_BYTES:
            raise RuntimeError(f"archive expands beyond {MAX_EXTRACTED_BYTES} bytes")
    zf.extractall(dest)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("run_id", type=int)
    ap.add_argument("--repo", default="Poplar477a/MaaDeps")
    ap.add_argument("--target", default="x64-windows")
    ap.add_argument("--out", default="openvino-pack/ci")
    ap.add_argument("--debug", action="store_true", help="also download debug tarball")
    args = ap.parse_args()

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    arts = api_get(f"{API}/repos/{args.repo}/actions/runs/{args.run_id}/artifacts?per_page=100")
    wanted = [f"tarball-{args.target}"]
    if args.debug:
        wanted.append(f"dbg-tarball-{args.target}")

    found = {a["name"]: a for a in arts.get("artifacts", []) if a["name"] in wanted}
    if not found:
        print("available artifacts:", [a["name"] for a in arts.get("artifacts", [])], file=sys.stderr)
        sys.exit(1)

    for name, art in found.items():
        zpath = out / f"{name}.zip"
        print("downloading", name)
        download(art["archive_download_url"], zpath)
        with zipfile.ZipFile(zpath) as z:
            safe_extract_zip(z, out / name)
        zpath.unlink()
        for tar_path in (out / name).rglob("*.tar.xz"):
            print("extracting", tar_path.name)
            with tarfile.open(tar_path) as t:
                safe_extract_tar(t, out)
        print("ok:", out / name)


if __name__ == "__main__":
    main()
