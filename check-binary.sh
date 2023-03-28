#!/usr/bin/bash
#
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
#

set -e
set -o pipefail

# Install pwntools if pwn is absent
if ! [ -x "$(command -v pwn)" ]; then
    pip install pwntools
fi

GREEN='\033[92m'
RED='\033[0;31m'
NC='\033[0m'

STATUS=0

function CheckBinaryDependency() {   
    if grep -q "$2" <<<"$1"; then
        echo -e "${RED} Should not depend on $2${NC}"
        exit 1
    else
        echo -e "${GREEN} $2 check pass${NC}"
    fi
}

function CheckBinarySafety() {
    if grep -Eq "$2" <<<"$1"; then
        echo -e "${GREEN} $3 check pass${NC}"
    else
        echo -e "${RED} $3 check fail${NC}"
        exit 1
    fi
}

echo "Check binary dependencies..."

# Check ldd dependencies
DEPS=$(ldd $1 | awk '/ => / { print $1 }')

CheckBinaryDependency "$DEPS" "libstdc++"
CheckBinaryDependency "$DEPS" "libgcc"

echo "Check binary safety options..."

CHECK_STATUS=$(pwn checksec $1 2>&1)

CheckBinarySafety "$CHECK_STATUS" "RELRO:\s*Full\sRELRO" "relro"
CheckBinarySafety "$CHECK_STATUS" "Stack:\s*Canary\sfound" "canary"
CheckBinarySafety "$CHECK_STATUS" "NX:\s*NX\senabled" "NX"
CheckBinarySafety "$CHECK_STATUS" "PIE:\s*PIE\senabled" "pie"
CheckBinarySafety "$CHECK_STATUS" "FORTIFY:\s*Enabled" "FORTIFY"
