/*
 * Copyright 2019 OpenAdvice & Vodafone SM-4.0_ TV
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// const winston = require('winston');
const express = require('express');
const config = require('config');
const app = express();

// require('./startup/logging')();
require('./startup/cors')(app);
require('./startup/routes')(app);
// require('./startup/db')(); // turned off for ci tests
require('./startup/config')();
// require('./startup/validation')();

const port = process.env.NODE_PORT || config.get('port');
const server = app.listen(port, () =>
  console.log(`Listening on port ${port}...`)
);

module.exports = server;
