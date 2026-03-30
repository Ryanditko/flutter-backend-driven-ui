import 'dart:ui';

import 'package:flutter_backend_driven_ui/core/utils/color_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseHexColor', () {
    test('6-digit with # prefix becomes opaque RGB', () {
      expect(parseHexColor('#FF0000'), const Color(0xFFFF0000));
    });

    test('8-digit hex parses as ARGB', () {
      expect(parseHexColor('AABB0000'), const Color(0xAABB0000));
    });

    test('null returns null', () {
      expect(parseHexColor(null), isNull);
    });

    test('empty string returns null', () {
      expect(parseHexColor(''), isNull);
    });

    test('invalid length returns null', () {
      expect(parseHexColor('#FFF'), isNull);
      expect(parseHexColor('FF00'), isNull);
      expect(parseHexColor('#123456789'), isNull);
    });

    test('accepts leading hash', () {
      expect(parseHexColor('#00FF00'), const Color(0xFF00FF00));
    });

    test('accepts value without hash', () {
      expect(parseHexColor('0000FF'), const Color(0xFF0000FF));
    });
  });
}
