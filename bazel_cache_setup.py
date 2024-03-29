#! /usr/bin/env python3

# Copyright 2023 Ant Group Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import base64

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--in_file",
        type=str,
        required=True
    )

    parser.add_argument(
        "--out_file",
        type=str,
        required=True
    )

    parser.add_argument(
        "--encode",
        action='store_true'
    )
    
    parser.add_argument(
        "--min_download",
        action='store_true'
    )

    args = parser.parse_args()

    with open(args.in_file, 'rb') as f:
        content = f.read()

    print(f"Input {len(content)} bytes")

    if args.encode:
        result = base64.b64encode(content)
    else:
        result = base64.b64decode(content)

    if len(result) == 0:
        print("Empty file, skip")
        return

    with open(args.out_file, "wb+") as f:
        f.write(result)
        print(f"Wrote {len(result)} bytes into {args.out_file}")

    with open('.bazelrc', 'a') as f:
        f.write("build --experimental_remote_cache_compression\n")
        f.write("build --remote_cache=https://storage.googleapis.com/secretflow\n")
        f.write(f"build --google_credentials={args.out_file}\n")
        if args.min_download:
            f.write("build --remote_download_minimal\n")
        print(".bazelrc updated")


if __name__ == "__main__":
    main()
