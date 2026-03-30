/// Holds variable bindings that template expressions can reference.
///
/// Variables are a flat `String → dynamic` map. Nested access uses
/// dot-notation: `"user.name"` looks up `context['user']` and then, if
/// the result is a [Map], resolves `['name']` inside it.
class ExpressionContext {
  final Map<String, dynamic> _variables;

  const ExpressionContext([Map<String, dynamic>? variables])
      : _variables = variables ?? const {};

  ExpressionContext copyWith(Map<String, dynamic> overrides) {
    return ExpressionContext({..._variables, ...overrides});
  }

  dynamic resolve(String path) {
    final segments = path.split('.');
    dynamic current = _variables;

    for (final segment in segments) {
      if (current is Map<String, dynamic> && current.containsKey(segment)) {
        current = current[segment];
      } else {
        return null;
      }
    }

    return current;
  }

  bool evaluateTruthy(String expression) {
    final value = resolve(expression.trim());
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.isNotEmpty && value != 'false';
    return true;
  }

  Map<String, dynamic> get variables => Map.unmodifiable(_variables);

  bool get isEmpty => _variables.isEmpty;
}
