// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// A simple web-worker that echos back any data it receives.
onmessage = function(event) {
  postMessage(event.data);
};
