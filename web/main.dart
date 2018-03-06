// Copyright 2018, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:web_worker_channel/web_worker_channel.dart';

void main() {
  webWorkerChannel<String>('worker.dart.js')
      ..stream.listen((e) => print('Received: $e'))
      ..sink.add('1')
      ..sink.add('2')
      ..sink.add('3');
}
