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

FILENAME=$1
CACHE_FILE=~/.cache/$FILENAME.tar.gz

if test -f "$CACHE_FILE"; then
    echo "$CACHE_FILE exists. Decompressing..."
    cd ~/.cache
    tar -xzf $FILENAME.tar.gz
    rm -f $FILENAME.tar.gz

    echo "Fixing timestamp...."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        find "$FILENAME" -type f -exec touch -a -d '-1 week' {} +
    else
        find "$FILENAME" -type f -exec touch -a -A-990000 {} +
    fi
    
    echo "Done"
else
    echo "$CACHE_FILE does not exist"
fi
