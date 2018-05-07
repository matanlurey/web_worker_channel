// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Based on the MDN "Using Web Workers" (https://goo.gl/Qno5wC).
@JS()
library web_worker_channel.src.js;

import 'dart:html' show Event;
import 'package:js/js.dart';

export 'dart:html' show Event, MessageEvent;
export 'package:js/js.dart' show allowInterop;

/// Function signature for a callback that provides an [Event].
typedef EventListener = void Function(Event);

/// Base browser interface for a target that dispatches events.
abstract class EventTarget {
  /// Adds the specified [listener] for the event [type].
  ///
  /// TODO: Ideally type as `addEventListener<T extends Event>`.
  void addEventListener(String type, EventListener listener);

  /// Removes the specified [listener] for the event [type].
  ///
  /// TODO: Ideally type as `removeEventListener<T extends Event>`.
  void removeEventListener(String type, EventListener listener);
}

/// Dart interface for any class that provides a `postMessage` API.
@JS()
@anonymous
abstract class HasPostMessage {
  /// Object to deliver to another listener.
  ///
  /// This may be any value or JavaScript object handled by the structural
  /// clone algorithm, which includes cyclical references.
  external void postMessage(Object message);
}

/// https://developer.mozilla.org/en-US/docs/Web/API/Worker
@JS('Worker')
abstract class Worker implements EventTarget, HasPostMessage {
  /// Creates a [Worker].
  ///
  /// [url]: Represents the URL of the script the worker will execute.
  external factory Worker(String url);

  /// Object to deliver to the worker.
  ///
  /// This may be any value or JavaScript object handled by the structural
  /// clone algorithm, which includes cyclical references.
  @override
  external void postMessage(Object message);

  /// Immediately terminates the worker.
  external void terminate();
}

/// Window object (or window context in a web worker).
@JS()
@anonymous
abstract class Self implements EventTarget, HasPostMessage {
  @override
  external void addEventListener(String type, EventListener listener);

  @override
  external void removeEventListener(String type, EventListener listener);

  @override
  external void postMessage(Object message);
}

/// Window object (or window context in a web worker).
@JS()
external Self get self;
