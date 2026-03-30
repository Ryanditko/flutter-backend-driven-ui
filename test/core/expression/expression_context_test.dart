import 'package:flutter_backend_driven_ui/core/expression/expression_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpressionContext.resolve', () {
    test('resolves simple path', () {
      const ctx = ExpressionContext({'name': 'Ada'});
      expect(ctx.resolve('name'), 'Ada');
    });

    test('resolves dot-path for nested maps', () {
      const ctx = ExpressionContext({
        'user': {'name': 'Bob', 'age': 30},
      });
      expect(ctx.resolve('user.name'), 'Bob');
      expect(ctx.resolve('user.age'), 30);
    });

    test('returns null for missing path', () {
      const ctx = ExpressionContext({'a': 1});
      expect(ctx.resolve('missing'), isNull);
      expect(ctx.resolve('user.name'), isNull);
    });
  });

  group('ExpressionContext.evaluateTruthy', () {
    test('true for bool true', () {
      const ctx = ExpressionContext({'flag': true});
      expect(ctx.evaluateTruthy('flag'), isTrue);
    });

    test('false for bool false', () {
      const ctx = ExpressionContext({'flag': false});
      expect(ctx.evaluateTruthy('flag'), isFalse);
    });

    test('true for non-zero num', () {
      const ctx = ExpressionContext({'n': 7});
      expect(ctx.evaluateTruthy('n'), isTrue);
    });

    test('true for non-empty string', () {
      const ctx = ExpressionContext({'s': 'hello'});
      expect(ctx.evaluateTruthy('s'), isTrue);
    });

    test('false for null binding', () {
      const ctx = ExpressionContext({});
      expect(ctx.evaluateTruthy('x'), isFalse);
    });

    test('false for zero', () {
      const ctx = ExpressionContext({'n': 0});
      expect(ctx.evaluateTruthy('n'), isFalse);
    });

    test('false for empty string', () {
      const ctx = ExpressionContext({'s': ''});
      expect(ctx.evaluateTruthy('s'), isFalse);
    });

    test('false for string "false"', () {
      const ctx = ExpressionContext({'s': 'false'});
      expect(ctx.evaluateTruthy('s'), isFalse);
    });

    test('trims expression before resolve', () {
      const ctx = ExpressionContext({'k': true});
      expect(ctx.evaluateTruthy('  k  '), isTrue);
    });
  });

  group('ExpressionContext accessors', () {
    test('isEmpty reflects map', () {
      expect(const ExpressionContext().isEmpty, isTrue);
      expect(const ExpressionContext({'a': 1}).isEmpty, isFalse);
    });

    test('variables is unmodifiable snapshot', () {
      const ctx = ExpressionContext({'a': 1});
      final v = ctx.variables;
      expect(v, {'a': 1});
      expect(() => v['b'] = 2, throwsA(isA<UnsupportedError>()));
    });
  });

  group('ExpressionContext.copyWith', () {
    test('merges overrides on top of existing bindings', () {
      const base = ExpressionContext({'a': 1, 'b': 2});
      final merged = base.copyWith({'b': 20, 'c': 3});
      expect(merged.resolve('a'), 1);
      expect(merged.resolve('b'), 20);
      expect(merged.resolve('c'), 3);
    });
  });
}
