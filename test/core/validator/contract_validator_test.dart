import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_backend_driven_ui/core/validator/contract_validator.dart';
import 'package:flutter_test/flutter_test.dart';

ScreenContract _validContract() {
  return ScreenContract(
    schemaVersion: '1.0',
    screen: Screen(
      id: 'home',
      title: 'Home',
      root: ComponentNode(
        type: 'column',
        children: [
          ComponentNode(
            type: 'text',
            props: {'content': 'Hello'},
          ),
        ],
      ),
    ),
  );
}

void main() {
  final validator = ContractValidator();

  group('ContractValidator.validate', () {
    test('valid contract returns empty list', () {
      expect(validator.validate(_validContract()), isEmpty);
    });

    test('unsupported schema version', () {
      final c = ScreenContract(
        schemaVersion: '0.9',
        screen: _validContract().screen,
      );
      final issues = validator.validate(c);
      expect(issues, isNotEmpty);
      expect(issues.first, contains('Unsupported schema version'));
    });

    test('empty screen id', () {
      final base = _validContract();
      final c = ScreenContract(
        schemaVersion: base.schemaVersion,
        screen: Screen(
          id: '',
          title: base.screen.title,
          root: base.screen.root,
        ),
      );
      expect(validator.validate(c), contains('Screen id must not be empty.'));
    });

    test('empty screen title', () {
      final base = _validContract();
      final c = ScreenContract(
        schemaVersion: base.schemaVersion,
        screen: Screen(
          id: base.screen.id,
          title: '',
          root: base.screen.root,
        ),
      );
      expect(validator.validate(c), contains('Screen title must not be empty.'));
    });

    test('unknown component type', () {
      final base = _validContract();
      final c = ScreenContract(
        schemaVersion: base.schemaVersion,
        screen: Screen(
          id: base.screen.id,
          title: base.screen.title,
          root: ComponentNode(type: 'notARealWidget'),
        ),
      );
      final issues = validator.validate(c);
      expect(issues.any((s) => s.contains('unknown component type')), isTrue);
    });

    test('leaf with children', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(
            type: 'text',
            props: {'content': 'ok'},
            children: [
              ComponentNode(type: 'text', props: {'content': 'nested'}),
            ],
          ),
        ),
      );
      final issues = validator.validate(c);
      expect(issues.any((s) => s.contains('should not have children')), isTrue);
    });

    test('text missing content', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(type: 'text', props: {}),
        ),
      );
      expect(
        validator.validate(c),
        contains('root: text component requires a "content" prop.'),
      );
    });

    test('button missing label', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(type: 'button', props: {}),
        ),
      );
      expect(
        validator.validate(c),
        contains('root: button component requires a "label" prop.'),
      );
    });

    test('image missing url', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(type: 'image', props: {}),
        ),
      );
      expect(
        validator.validate(c),
        contains('root: image component requires a "url" prop.'),
      );
    });

    test('input without id', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(type: 'input', props: {}),
        ),
      );
      expect(
        validator.validate(c),
        contains('root: input component should have a non-empty "id".'),
      );
    });

    test('unknown action type', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(
            type: 'text',
            props: {'content': 'x'},
            action: const ActionDef(type: 'teleport'),
          ),
        ),
      );
      expect(
        validator.validate(c),
        contains('root: unknown action type "teleport".'),
      );
    });

    test('navigate without targetScreenId', () {
      final c = ScreenContract(
        schemaVersion: '1.0',
        screen: Screen(
          id: 'x',
          title: 'T',
          root: ComponentNode(
            type: 'text',
            props: {'content': 'x'},
            action: const ActionDef(type: 'navigate'),
          ),
        ),
      );
      expect(
        validator.validate(c),
        contains('root: navigate action requires "targetScreenId".'),
      );
    });
  });
}
