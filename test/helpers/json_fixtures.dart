import 'package:flutter_backend_driven_ui/core/models/screen_contract.dart';

ScreenContract minimalContract({
  String id = 'test',
  String title = 'Test Screen',
  ComponentNode? root,
}) {
  return ScreenContract(
    schemaVersion: '1.0',
    screen: Screen(
      id: id,
      title: title,
      root: root ??
          const ComponentNode(
            type: 'text',
            props: {'content': 'Hello'},
          ),
    ),
  );
}

ComponentNode textNode({
  String content = 'Test text',
  Map<String, dynamic>? style,
}) {
  return ComponentNode(
    type: 'text',
    props: {
      'content': content,
      if (style != null) 'style': style,
    },
  );
}

ComponentNode buttonNode({
  String label = 'Test button',
  ActionDef? action,
  Map<String, dynamic>? style,
}) {
  return ComponentNode(
    type: 'button',
    props: {
      'label': label,
      if (style != null) 'style': style,
    },
    action: action,
  );
}

ComponentNode columnNode({List<ComponentNode> children = const []}) {
  return ComponentNode(
    type: 'column',
    props: const {'crossAxisAlignment': 'stretch'},
    children: children,
  );
}

ComponentNode inputNode({
  String id = 'input_1',
  String label = 'Label',
  String hint = 'Hint',
}) {
  return ComponentNode(
    type: 'input',
    id: id,
    props: {'label': label, 'hint': hint},
  );
}

Map<String, dynamic> fullContractJson() {
  return {
    'schemaVersion': '1.0',
    'context': {
      'user': {'name': 'Jane'},
    },
    'theme': {
      'primaryColor': '#820AD1',
      'brightness': 'dark',
    },
    'screen': {
      'id': 'test',
      'title': 'Test',
      'root': {
        'type': 'column',
        'props': {'crossAxisAlignment': 'stretch'},
        'children': [
          {
            'type': 'text',
            'props': {'content': 'Hello, {{user.name}}!'},
          },
        ],
      },
    },
  };
}
