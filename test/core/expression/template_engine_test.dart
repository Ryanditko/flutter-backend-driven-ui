import 'package:flutter_backend_driven_ui/core/expression/expression_context.dart';
import 'package:flutter_backend_driven_ui/core/expression/template_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TemplateEngine.interpolate', () {
    test('replaces placeholder with existing variable', () {
      const ctx = ExpressionContext({'name': 'World'});
      expect(
        TemplateEngine.interpolate('Hello {{name}}!', ctx),
        'Hello World!',
      );
    });

    test('keeps placeholder when variable is missing', () {
      const ctx = ExpressionContext({});
      expect(
        TemplateEngine.interpolate('Hi {{missing}}', ctx),
        'Hi {{missing}}',
      );
    });

    test('interpolates nested path', () {
      const ctx = ExpressionContext({
        'user': {'name': 'Casey'},
      });
      expect(
        TemplateEngine.interpolate('{{user.name}}', ctx),
        'Casey',
      );
    });

    test('returns string unchanged when no placeholders', () {
      const ctx = ExpressionContext({'x': 1});
      expect(TemplateEngine.interpolate('plain', ctx), 'plain');
    });
  });

  group('TemplateEngine.evaluateVisibility', () {
    test('null means visible', () {
      const ctx = ExpressionContext({});
      expect(TemplateEngine.evaluateVisibility(null, ctx), isTrue);
    });

    test('bool true and false', () {
      const ctx = ExpressionContext({});
      expect(TemplateEngine.evaluateVisibility(true, ctx), isTrue);
      expect(TemplateEngine.evaluateVisibility(false, ctx), isFalse);
    });

    test('string with template uses truthy evaluation', () {
      final truthyCtx = ExpressionContext({'ok': true});
      final falsyCtx = ExpressionContext({'ok': false});
      expect(
        TemplateEngine.evaluateVisibility('{{ok}}', truthyCtx),
        isTrue,
      );
      expect(
        TemplateEngine.evaluateVisibility('{{ok}}', falsyCtx),
        isFalse,
      );
    });

    test('literal string "false" is not visible', () {
      const ctx = ExpressionContext({});
      expect(
        TemplateEngine.evaluateVisibility('false', ctx),
        isFalse,
      );
    });
  });
}
