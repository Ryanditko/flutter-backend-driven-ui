import 'package:flutter/material.dart';
import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/parser/component_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ComponentRegistry', () {
    test('register and getBuilder returns the builder', () {
      final registry = ComponentRegistry();
      Widget buildBox(
        ComponentNode node,
        BuildContext context,
        Widget Function(ComponentNode) buildChildren,
      ) {
        return const SizedBox();
      }

      registry.register('box', buildBox);
      expect(registry.getBuilder('box'), same(buildBox));
    });

    test('getBuilder for unknown type returns null', () {
      final registry = ComponentRegistry();
      expect(registry.getBuilder('missing'), isNull);
    });

    test('hasBuilder is true after register and false for unknown', () {
      final registry = ComponentRegistry();
      expect(registry.hasBuilder('x'), isFalse);
      registry.register(
        'x',
        (node, context, buildChildren) => const SizedBox(),
      );
      expect(registry.hasBuilder('x'), isTrue);
      expect(registry.hasBuilder('y'), isFalse);
    });
  });
}
