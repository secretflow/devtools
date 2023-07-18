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
import os
import subprocess


def _run_shell_command_with_live_output(cmd, cwd, check=True):
    print(cmd)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=cwd)
    for line in p.stdout:
        print(line.decode("utf-8").rstrip())
    p.wait()
    status = p.poll()
    if check:
        assert status == 0


def _check_is_multiarch_dockerfile(file):
    with open(file, "r") as df:
        content = df.read()
        if "TARGETPLATFORM" in content:
            return True
        else:
            return False


COLOR_GREEN = "\033[92m"
COLOR_END = "\033[0m"


def main():
    parser = argparse.ArgumentParser(description="Publish SecretFlow docker images")

    parser.add_argument(
        "--name",
        metavar="name of docker image",
        type=str,
        help="name of docker image",
        required=True,
    )

    parser.add_argument(
        "--tag",
        metavar="tag of docker image, should be incremental",
        type=str,
        required=True,
    )

    args = parser.parse_args()

    dockerfile = os.path.join("dockerfiles", f"{args.name}.DockerFile")
    versioned_tag = f"secretflow/{args.name}:{args.tag}"
    latest_tag = f"secretflow/{args.name}:latest"

    print(f"{COLOR_GREEN}[1/4] Build docker image {args.name}{COLOR_END}")
    if _check_is_multiarch_dockerfile(dockerfile):
        print(f"{COLOR_GREEN}Creating buildx")
        _run_shell_command_with_live_output(
            [
                "docker",
                "buildx",
                "create",
                "--name",
                "sf-image-builder",
                "--platform",
                "linux/amd64,linux/arm64",
                "--use",
            ],
            ".",
            check=False,
        )
        # Build using buildx
        _run_shell_command_with_live_output(
            [
                "docker",
                "buildx",
                "build",
                "--platform",
                "linux/amd64,linux/arm64",
                "--no-cache",
                ".",
                "-f",
                dockerfile,
                "-t",
                versioned_tag,
            ],
            ".",
        )
        # Export multi-arch image
        _run_shell_command_with_live_output(
            [
                "docker",
                "buildx",
                "build",
                ".",
                "-f",
                dockerfile,
                "-t",
                versioned_tag,
                "--load",
            ],
            ".",
        )
    else:
        _run_shell_command_with_live_output(
            [
                "docker",
                "build",
                "--no-cache",
                ".",
                "-f",
                dockerfile,
                "-t",
                versioned_tag,
            ],
            ".",
        )
    print(f"{COLOR_GREEN}[2/4] Tag image with latest{COLOR_END}")
    _run_shell_command_with_live_output(
        ["docker", "tag", versioned_tag, latest_tag], "."
    )
    # print(f"{COLOR_GREEN}[3/4] Push versioned tag to registry{COLOR_END}")
    # _run_shell_command_with_live_output(["docker", "push", versioned_tag], ".")
    # print(f"{COLOR_GREEN}[4/4] Push latest tag to registry{COLOR_END}")
    # _run_shell_command_with_live_output(["docker", "push", latest_tag], ".")


if __name__ == "__main__":
    main()
