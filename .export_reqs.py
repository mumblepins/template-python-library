#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import subprocess

import toml


def parse_toml():
    with open("pyproject.toml", "r", encoding="utf8") as fh:
        data = toml.load(fh)
    deps = data["tool"]["poetry"]["dependencies"]
    # deps.update(data["tool"]["poetry"]["group"]["dev"]["dependencies"])
    return deps


def poetry_export():
    r = subprocess.run(["bash", "-i", "-c", "poetry export --format requirements.txt --without-hashes"], stdout=subprocess.PIPE, check=True)
    return r.stdout.decode("utf-8")


if __name__ == "__main__":
    depends = parse_toml()
    preqs = poetry_export()
    with open("src/requirements.txt", "w", encoding="utf8") as f:
        for line in preqs.splitlines(True):
            if line.startswith(tuple(depends.keys())):
                f.write(line)
