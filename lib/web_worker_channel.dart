// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:stream_channel/stream_channel.dart';

import 'src/js_interop.dart';
export 'src/js_interop.dart' show MessageEvent;

/// Returns a [StreamChannel] that communicates with a web worker at [url].
///
/// The provided [url] is expected to be pre-compiled as valid JavaScript
/// (either using DartDevC, Dart2JS, or written in JavaScript).
StreamChannel<Object> webWorkerChannel(String url) {
  return new _WorkerChannel(new Worker(url));
}

/// Returns a [StreamChannel] that communicates with the origin via postMessage.
StreamChannel<Object> originChannel() => new _SelfChannel(self);

/// Base class for both workers and the origin (`self`) context.
abstract class _PostMessageChannel extends StreamChannelMixin<Object> {
  @override
  final StreamController<Object> sink = new StreamController(sync: true);
  final _onMessage = new StreamController<Object>(sync: true);

  _PostMessageChannel() {
    final onMessage = Zone.current.bindUnaryCallback((Event e) {
      _onMessage.add((e as MessageEvent).data);
    });
    registerListener(onMessage);
    sink.stream.listen((message) {
      sendPostMessage(message);
    }, onDone: () {
      removeListener(onMessage);
      _onMessage.close();
    });
  }

  @override
  Stream<Object> get stream => _onMessage.stream;

  void removeListener(EventListener listener);
  void registerListener(EventListener listener);
  void sendPostMessage(Object message);
}

class _WorkerChannel extends _PostMessageChannel {
  final Worker _worker;

  _WorkerChannel(this._worker);

  @override
  void registerListener(EventListener listener) {
    _worker.addEventListener('message', listener);
  }

  @override
  void removeListener(EventListener listener) {
    _worker.removeEventListener('message', listener);
  }

  @override
  void sendPostMessage(Object message) {
    _worker.postMessage(message);
  }
}

class _SelfChannel extends _PostMessageChannel {
  final Self _self;

  _SelfChannel(this._self);

  @override
  void registerListener(EventListener listener) {
    _self.addEventListener('message', listener);
  }

  @override
  void removeListener(EventListener listener) {
    _self.removeEventListener('message', listener);
  }

  @override
  void sendPostMessage(Object message) {
    _self.postMessage(message);
  }
}
