// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JS()
library web_worker_chnanel.src.js_interop_hack;

import 'package:js/js.dart';

import 'js_interop.dart';

@JS('postMessage')
external dynamic get postMessage;

/// Using `postMessage()` through Dart2JS currently causes runtime failures.
///
/// We create our "own" `postMessage()` that Dart2JS won't know about.
JsWorker selfAsWorker() {
  return new _SelfWorker(postMessage: postMessage);
}

@JS()
@anonymous
abstract class _SelfWorker implements JsWorker {
  external factory _SelfWorker({dynamic postMessage});
}
