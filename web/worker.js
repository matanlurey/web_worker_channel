// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// A pure JS-implementation of a simple echo-based web worker.
//
// This allows validating what the "worker.dart.js" behavior should be.
(function() {
  console.log('Loaded worker.js...');
  addEventListener('message', function(e) {
     postMessage(e.data);
  });
})();
