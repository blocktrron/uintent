#!/usr/bin/env python3

import sys

def load_checksum_file(path):
    with open(path, 'r') as checksum_file:
        content_lines = checksum_file.readlines()

    checksums = [{'sha256': line[:64], 'filename': line[66:]} for line in content_lines]
    return checksums
    


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print(f"Usage: {sys.argv[0]} checksum-file type filename")
        sys.exit(1)

    checksums = load_checksum_file(sys.argv[1])

    for checksum in checksums:
        if sys.argv[3] in checksum['filename']:
            print(checksum[sys.argv[2]])
            sys.exit(0)
