// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Based on the MDN "Using Web Workers" (https://goo.gl/Qno5wC).
@JS()
library web_worker_channel.src.js;

import 'package:js/js.dart';

/// Base browser interface for events.
///
/// https://developer.mozilla.org/en-US/docs/Web/API/Event
@JS('Event')
abstract class Event {}

/// Function signature for a callback that provides an [Event].
typedef EventListener = void Function(Event);

/// Base browser interface for a target that dispatches events.
abstract class EventTarget {
  /// Adds the specified [listener] for the event [type].
  ///
  /// TODO: Ideally type as `addEventListener<T extends Event>`.
  external void addEventListener(String type, EventListener listener);

  /// Removes the specified [listener] for the event [type].
  ///
  /// TODO: Ideally type as `removeEventListener<T extends Event>`.
  external void removeEventListener(String type, EventListener listener);
}

/// Browser interface for a `'message'` event that provides [data].
///
/// https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent
@JS('MessageEvent')
abstract class MessageEvent extends Event {
  /// The data sent by the message emitter.
  Object get data;
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
abstract class Worker extends Object with EventTarget, HasPostMessage {
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
abstract class Self extends Object with EventTarget, HasPostMessage {}

/// Window object (or window context in a web worker).
@JS()
external Self get self;
