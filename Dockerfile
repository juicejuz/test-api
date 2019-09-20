# Copyright 2019 OpenAdvice & Vodafone SM-4.0_TV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Stage 1 (Base Build)
FROM oavkdtv/centos-node:1.0.0 as base
WORKDIR /node
COPY package*.json ./
RUN mkdir api && chown -R node:node .
USER node
RUN npm config list \
  && npm ci --only=production \
  #  && npm ci \
  && npm cache clean --force
#ENV PATH /api/node_modules/.bin/$PATH
WORKDIR /node/api

## State 2 (Development)
## docker build -t davedb-api-dev --target dev .
## docker run -d -it --name davedb-dev --mount type=bind,source="$(pwd)"/,target=/node/app,readonly -p 3911:3911 davedb-api-dev
FROM base as dev
ENV NODE_ENV=development
EXPOSE 3911
ENV NODE_PORT=3911
WORKDIR /node
#RUN npm i --only=development
RUN npm i
WORKDIR /node/api
CMD ["node",  "app.js"]  
#CMD ["nodemon", "./bin/www", "--inspect=0.0.0.0:9229"]

## Stage 3 (Test)
## docker build -t davedb-api-test --target test .
## docker run -d -it --name davedb-dev --mount type=bind,source="$(pwd)"/,target=/node/app,readonly
## only unit testing should be made in CT's
FROM dev as test
ENV NODE_ENV=test
CMD ["npm", "test"]

## Stage 4 (security scan & audit)
## add as agg to build command: 
##    --build-arg MICROSCANNER_TOKEN=$MICROSCANNER .
# FROM test as audit
# RUN npm audit
# ARG MICROSCANNER_TOKEN
# https://github.com/aquasecurity/microscanner
# ADD https://get.aquasec.com/microscanner /
# RUN chmod +x /microscanner
# RUN yum install --no-cache ca-certificates && update-ca-certificates
# RUN /microscanner $MICROSCANNER_TOKEN --continue-on-failure

## Stage 5 (Pre-Production)
## docker build -t davedb-api-pp --target preprod .
FROM base as preprod
ENV NODE_ENV=preproduction
EXPOSE 3901
ENV NODE_PORT=3901
COPY --chown=node:node . . 
CMD ["npm", "preprod"]

## Stage 6 (Production)
## docker build -t davedb-api --target prod .
FROM base as prod
ARG CREATED_DATE=not-set
ARG SOURCE_COMMIT=not-set
LABEL org.opencontainers.image.authors=oavkdtv@gmail.com
LABEL org.opencontainers.image.created=$CREATED_DATE
LABEL org.opencontainers.image.revision=$SOURCE_COMMIT
LABEL org.opencontainers.image.title="D.A.V.E.-DB REST-API"
LABEL org.opencontainers.image.url=https://hub.docker.com/r/oavkdtv/centos-node
LABEL org.opencontainers.image.source=https://github.com/oavkdtv/davedb-api
LABEL org.opencontainers.image.licenses=Apache2.0
LABEL com.davedb.nodeversion=$NODE_VERSION
ENV NODE_ENV=production
EXPOSE 3900
ENV NODE_PORT=3900
## be sure curl is avalable in ct
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/healthz || exit 1
COPY --chown=node:node . .  
CMD ["node", "app.js"]