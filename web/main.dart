// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:stream_channel/stream_channel.dart';
import 'package:web_worker_channel/web_worker_channel.dart';

void main() {
  final channel = originChannel();
  print('??? $channel');

  document.getElementById('jsWorker').onClick.listen((_) {
    print('Starting worker.js...');
    _useChannel(webWorkerChannel('worker.js'));
  });
  document.getElementById('dartWorker').onClick.listen((_) {
    print('Starting worker.dart.js...');
    _useChannel(webWorkerChannel('worker.dart.js'));
  });
}

void _useChannel(StreamChannel<Object> channel) {
  channel
    ..stream.listen((e) => print('Received: $e'))
    ..sink.add('1')
    ..sink.add('2')
    ..sink.add('3');
}
