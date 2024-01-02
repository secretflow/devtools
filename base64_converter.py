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
        "--str",
        type=str,
        required=False
    )

    parser.add_argument(
        "--in_file",
        type=str,
        required=False
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

    args = parser.parse_args()

    if args.in_file:
        with open(args.in_file, 'rb') as f:
            content = f.read()
    else:
        content = args.str

    if args.encode:
        result = base64.b64encode(content)
    else:
        result = base64.b64decode(content)

    with open(args.out_file, "wb+") as f:
        f.write(result)


if __name__ == "__main__":
    main()
