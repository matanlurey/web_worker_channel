// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:js/js.dart';
import 'package:stream_channel/stream_channel.dart';

import 'src/js_interop.dart';
import 'src/js_interop_hack.dart';

/// Returns a [StreamChannel] that communicates with a web worker at [url].
///
/// The provided [url] is expected to be pre-compiled as valid JavaScript
/// (either using DartDevC, Dart2JS, or written in JavaScript).
StreamChannel<T> webWorkerChannel<T>(String url) {
  return new _PostMessageChannel(new JsWorker(url));
}

/// Return the current `window` as the origin channel for communication.
StreamChannel<T> originChannel<T>() {
  return new _PostMessageChannel<T>(selfAsWorker());
}

class _PostMessageChannel<T> extends StreamChannelMixin<T> {
  @override
  final StreamController<T> sink = new StreamController<T>(sync: true);

  _PostMessageChannel(JsWorker worker) {
    final onMessage = allowInterop(Zone.current.bindUnaryCallback((Object e) {
      final event = e as JsMessageEvent;
      _onMessage.add(event.data as T);
    }));
    worker.addEventListener('message', onMessage);
    sink.stream.listen((message) {
      // https://github.com/dart-lang/sdk/issues/32370
      worker.postMessage(message);
    }, onDone: () {
      worker.removeEventListener('message', onMessage);
      _onMessage.close();
    });
  }

  final StreamController<T> _onMessage = new StreamController<T>(sync: true);

  @override
  Stream<T> get stream => _onMessage.stream;
}
