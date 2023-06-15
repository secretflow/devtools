#! /bin/bash

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

# Copyright 2022 The StableHLO Authors.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BASE_BRANCH="$(git merge-base HEAD origin/main)"

echo "Gathering changed files..."
CHANGED_FILES=$(git diff $BASE_BRANCH HEAD --name-only --diff-filter=d | grep '.*\.h\|.*\.cc' | xargs)
if [[ -z "$CHANGED_FILES" ]]; then
  echo "No files to format."
  exit 0
fi

echo "Running clang-format validate..."
echo "  Files: $CHANGED_FILES"
clang-format --style=file --dry-run --Werror $CHANGED_FILES
