import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EdgeInsetsModel.fromJson', () {
    test('parses all fields', () {
      final m = EdgeInsetsModel.fromJson({
        'top': 1,
        'bottom': 2,
        'left': 3,
        'right': 4,
      });
      expect(m.top, 1);
      expect(m.bottom, 2);
      expect(m.left, 3);
      expect(m.right, 4);
    });

    test('missing fields default to zero', () {
      final m = EdgeInsetsModel.fromJson({});
      expect(m.top, 0);
      expect(m.bottom, 0);
      expect(m.left, 0);
      expect(m.right, 0);
    });

    test('partial fields use defaults for absent keys', () {
      final m = EdgeInsetsModel.fromJson({'top': 10});
      expect(m.top, 10);
      expect(m.bottom, 0);
      expect(m.left, 0);
      expect(m.right, 0);
    });
  });

  group('TextStyleModel.fromJson', () {
    test('parses all fields', () {
      final t = TextStyleModel.fromJson({
        'fontSize': 16,
        'fontWeight': 'bold',
        'color': '#FF0000',
        'textAlign': 'center',
      });
      expect(t.fontSize, 16);
      expect(t.fontWeight, 'bold');
      expect(t.color, '#FF0000');
      expect(t.textAlign, 'center');
    });

    test('empty map yields all nulls', () {
      final t = TextStyleModel.fromJson({});
      expect(t.fontSize, isNull);
      expect(t.fontWeight, isNull);
      expect(t.color, isNull);
      expect(t.textAlign, isNull);
    });

    test('fontSize as int coerces to double', () {
      final t = TextStyleModel.fromJson({'fontSize': 14});
      expect(t.fontSize, 14.0);
    });
  });

  group('ButtonStyleModel.fromJson', () {
    test('parses known keys', () {
      final b = ButtonStyleModel.fromJson({
        'backgroundColor': '#00FF00',
        'textColor': '#0000FF',
        'borderRadius': 8,
      });
      expect(b.backgroundColor, '#00FF00');
      expect(b.textColor, '#0000FF');
      expect(b.borderRadius, 8.0);
    });

    test('empty map yields nulls', () {
      final b = ButtonStyleModel.fromJson({});
      expect(b.backgroundColor, isNull);
      expect(b.textColor, isNull);
      expect(b.borderRadius, isNull);
    });
  });

  group('ActionDef.fromJson', () {
    test('parses all fields', () {
      final a = ActionDef.fromJson({
        'type': 'navigate',
        'targetScreenId': 'next',
        'message': 'hello',
      });
      expect(a.type, 'navigate');
      expect(a.targetScreenId, 'next');
      expect(a.message, 'hello');
    });

    test('minimal has type only', () {
      final a = ActionDef.fromJson({'type': 'goBack'});
      expect(a.type, 'goBack');
      expect(a.targetScreenId, isNull);
      expect(a.message, isNull);
    });
  });

  group('ComponentNode.fromJson', () {
    test('parses children', () {
      final n = ComponentNode.fromJson({
        'type': 'column',
        'children': [
          {'type': 'text', 'props': {'content': 'a'}},
          {'type': 'text', 'props': {'content': 'b'}},
        ],
      });
      expect(n.children.length, 2);
      expect(n.children[0].type, 'text');
      expect(n.children[1].props['content'], 'b');
    });

    test('parses action', () {
      final n = ComponentNode.fromJson({
        'type': 'button',
        'props': {'label': 'Go'},
        'action': {'type': 'navigate', 'targetScreenId': 'home'},
      });
      expect(n.action, isNotNull);
      expect(n.action!.type, 'navigate');
      expect(n.action!.targetScreenId, 'home');
    });

    test('parses visible and id', () {
      final n = ComponentNode.fromJson({
        'type': 'text',
        'id': 'title',
        'props': {'content': 'x'},
        'visible': false,
      });
      expect(n.id, 'title');
      expect(n.visible, false);
    });
  });

  group('Screen.fromJson', () {
    test('parses id, title, and root', () {
      final s = Screen.fromJson({
        'id': 'home',
        'title': 'Home',
        'root': {
          'type': 'column',
          'children': [],
        },
      });
      expect(s.id, 'home');
      expect(s.title, 'Home');
      expect(s.root.type, 'column');
      expect(s.root.children, isEmpty);
    });
  });

  group('ScreenContract.fromJson', () {
    test('parses context and theme when present', () {
      final c = ScreenContract.fromJson({
        'schemaVersion': '1.0',
        'context': {'user': 'alice'},
        'theme': {'primaryColor': '#112233'},
        'screen': {
          'id': 's',
          'title': 'T',
          'root': {'type': 'column'},
        },
      });
      expect(c.schemaVersion, '1.0');
      expect(c.context, {'user': 'alice'});
      expect(c.theme, {'primaryColor': '#112233'});
    });

    test('defaults context to empty when omitted', () {
      final c = ScreenContract.fromJson({
        'schemaVersion': '1.0',
        'screen': {
          'id': 's',
          'title': 'T',
          'root': {'type': 'row'},
        },
      });
      expect(c.context, isEmpty);
      expect(c.theme, isNull);
    });
  });
}
