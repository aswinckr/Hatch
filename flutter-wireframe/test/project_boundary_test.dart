import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('workshop project is standalone and contains no design resources', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    expect(pubspec, contains('name: hatch_wireframe'));
    expect(pubspec, isNot(contains('path: ../flutter-ui')));
    expect(pubspec, isNot(contains('assets/')));
    expect(pubspec, isNot(contains('fonts:')));
    expect(File('design.md').existsSync(), isFalse);
    expect(Directory('assets').existsSync(), isFalse);
    expect(Directory('lib/core/design').existsSync(), isFalse);
    expect(Directory('skill').existsSync(), isFalse);
  });
}
