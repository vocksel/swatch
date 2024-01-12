#!/usr/bin/env python3

from argparse import ArgumentParser
import subprocess
from pathlib import Path

parser = ArgumentParser()
parser.add_argument("--target", choices=["prod", "dev"], required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--watch", action="store_true")

TARGET_TO_PROJECT_FILE_MAP = {
    "prod": Path("plugin/default.project.json"),
    "dev": Path("plugin/dev.project.json"),
}


def main():
    args = parser.parse_args()
    project_file = TARGET_TO_PROJECT_FILE_MAP[args.target]

    command = ["rojo", "build", project_file, "-o", args.output]
    if args.watch:
        print("Watching for changes...")
        command.append("--watch")

    subprocess.run(command)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
