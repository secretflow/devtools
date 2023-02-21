#!/bin/bash

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

rm -rf ./external
rm -f compile_commands.json

ln -s bazel-out/../../../external .

# backup file
cp WORKSPACE WORKSPACE_bak
cp BUILD.bazel BUILD.bazel_bak
cp .gitignore .gitignore_bak

echo -e "\n
load(\"@bazel_tools//tools/build_defs/repo:git.bzl\", \"git_repository\") \n

git_repository(
    name = \"hedron_compile_commands\",
    commit = \"d7a28301d812aeafa36469343538dbc025cec196\",
    remote = \"https://github.com/hedronvision/bazel-compile-commands-extractor.git\",
)

load(\"@hedron_compile_commands//:workspace_setup.bzl\", \"hedron_compile_commands_setup\")

hedron_compile_commands_setup()
" >> WORKSPACE

echo -e "\n
load(\"@hedron_compile_commands//:refresh_compile_commands.bzl\", \"refresh_compile_commands\")

refresh_compile_commands(
    name = \"refresh_compile_commands\",
    exclude_external_sources = True,
    exclude_headers = \"external\",
)
" >> BUILD.bazel

bazel run :refresh_compile_commands

# restore from backup
cp WORKSPACE_bak WORKSPACE
cp BUILD.bazel_bak BUILD.bazel
cp .gitignore_bak .gitignore

rm -f WORKSPACE_bak
rm -f BUILD.bazel_bak
rm -f .gitignore_bak
