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

FROM oavkdtv/centos-node:1.0.0
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
WORKDIR /node
COPY package*.json ./
RUN mkdir api && chown -R node:node .
USER node
RUN npm config list \
  && npm ci --only=production \
  && npm cache clean --force
WORKDIR /node/api
EXPOSE 3900
ENV NODE_PORT=3900
COPY --chown=node:node . .  
CMD ["node", "app.js"]
