import 'expression_context.dart';

/// Resolves `{{variable}}` placeholders inside a string using the
/// given [ExpressionContext].
///
/// Unresolved placeholders are left as-is so the user can spot
/// missing bindings in the preview.
class TemplateEngine {
  static final _pattern = RegExp(r'\{\{(.+?)\}\}');

  const TemplateEngine._();

  static String interpolate(String template, ExpressionContext context) {
    if (!template.contains('{{')) return template;

    return template.replaceAllMapped(_pattern, (match) {
      final expression = match.group(1)!.trim();
      final value = context.resolve(expression);
      return value?.toString() ?? match.group(0)!;
    });
  }

  /// Returns `true` when [value] is a template expression that
  /// the context evaluates as truthy, or when [value] is the literal
  /// boolean `true`, or when [value] is `null` (default visible).
  static bool evaluateVisibility(dynamic value, ExpressionContext context) {
    if (value == null) return true;
    if (value is bool) return value;
    if (value is String) {
      final match = _pattern.firstMatch(value);
      if (match != null) {
        return context.evaluateTruthy(match.group(1)!);
      }
      return value.toLowerCase() != 'false';
    }
    return true;
  }
}
