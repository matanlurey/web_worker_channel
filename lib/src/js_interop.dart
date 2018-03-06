// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Based on the MDN "Using Web Workers" (https://goo.gl/Qno5wC).
@JS()
library web_worker_channel.src.js;

import 'package:js/js.dart';

/// https://developer.mozilla.org/en-US/docs/Web/API/Event
@JS('Event')
abstract class JsEvent {}

/// Function signature for [JsEventTarget] methods.
typedef JsEventListener = void Function(JsEvent);

/// https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
@JS('EventTarget')
abstract class JsEventTarget {
  /// Adds the specified [listener] for the event [type].
  external void addEventListener(String type, JsEventListener listener);

  /// Removes the specified [listener] for the event [type].
  external void removeEventListener(String type, JsEventListener listener);
}

/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
@JS('MessageEvent')
abstract class JsMessageEvent extends JsEvent {
  /// The data sent by the message emitter.
  Object get data;
}

/// https://developer.mozilla.org/en-US/docs/Web/API/Worker
@JS('Worker')
abstract class JsWorker extends JsEventTarget {
  /// Creates a [JsWorker].
  ///
  /// [url]: Represents the URL of the script the worker will execute.
  external factory JsWorker(String url);

  /// Object to deliver to the worker.
  ///
  /// This may be any value or JavaScript object handled by the structural
  /// clone algorithm, which includes cyclical references.
  external void postMessage(Object message);

  /// Immediately terminates the worker.
  external void terminate();
}