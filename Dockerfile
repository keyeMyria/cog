# Copyright 2018 Geobeyond Srl
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

FROM python:3.6-alpine

LABEL Author="francesco.bartoli@geobeyond.it"

WORKDIR /tmp

# COPY requirements.txt /tmp/requirements.txt
COPY Pipfile /tmp/Pipfile
COPY Pipfile.lock /tmp/Pipfile.lock
RUN apk --update add python py-pip openssl ca-certificates py-openssl wget bash linux-headers
RUN apk --update add --virtual build-dependencies libffi-dev openssl-dev python-dev py-pip build-base \
  && pip install --upgrade pip \
  && pip install --upgrade pipenv\
#  && pip install --upgrade -r /tmp/requirements.txt\
  && pipenv install --verbose --system --deploy\
  && apk del build-dependencies

COPY . /app
WORKDIR /app





CMD ["gunicorn", "-b", "0.0.0.0:3000", "--env", "DJANGO_SETTINGS_MODULE=cog.settings.production", "cog.wsgi", "--timeout 120"]

