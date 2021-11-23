import 'package:flutter_test/flutter_test.dart';

import 'package:th_logger/th_logger.dart';

void main() {
  test('adds one to input values', () {
    THLogger().d("debug message");
    THLogger().e("error message");
    THLogger().i("info message");
    THLogger().v("debug message");
    THLogger().wtf("wtf message");
  });
}
