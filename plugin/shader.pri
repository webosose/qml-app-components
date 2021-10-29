# @@@LICENSE
#
#      Copyright (c) 2021 LG Electronics, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# LICENSE@@@

versionAtLeast(QT_VERSION, 6.0.0) {
    FILES = $$system($$PWD/shaderconversion.sh 6 \"$$PWD/Shaders\" \"$$shadowed($$PWD/Shaders)\")
} else {
    FILES = $$system($$PWD/shaderconversion.sh 5 \"$$PWD/Shaders\" \"$$shadowed($$PWD/Shaders)\")
}

SHADER_FILES = $$FILES
