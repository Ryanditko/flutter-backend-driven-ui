/// Dart models mirroring the backend JSON screen contract.
///
/// The component tree is recursive: layout nodes hold [children],
/// leaf nodes render directly. Every interactive component may carry
/// an [ActionDef] describing what happens on tap.
library;

// ---------------------------------------------------------------------------
// Edge Insets
// ---------------------------------------------------------------------------

class EdgeInsetsModel {
  final double top;
  final double bottom;
  final double left;
  final double right;

  const EdgeInsetsModel({
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  factory EdgeInsetsModel.fromJson(Map<String, dynamic> json) {
    return EdgeInsetsModel(
      top: (json['top'] as num?)?.toDouble() ?? 0,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 0,
      left: (json['left'] as num?)?.toDouble() ?? 0,
      right: (json['right'] as num?)?.toDouble() ?? 0,
    );
  }
}

// ---------------------------------------------------------------------------
// Text Style
// ---------------------------------------------------------------------------

class TextStyleModel {
  final double? fontSize;
  final String? fontWeight;
  final String? color;
  final String? textAlign;

  const TextStyleModel({this.fontSize, this.fontWeight, this.color, this.textAlign});

  factory TextStyleModel.fromJson(Map<String, dynamic> json) {
    return TextStyleModel(
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: json['fontWeight'] as String?,
      color: json['color'] as String?,
      textAlign: json['textAlign'] as String?,
    );
  }
}

// ---------------------------------------------------------------------------
// Button Style
// ---------------------------------------------------------------------------

class ButtonStyleModel {
  final String? backgroundColor;
  final String? textColor;
  final double? borderRadius;

  const ButtonStyleModel({this.backgroundColor, this.textColor, this.borderRadius});

  factory ButtonStyleModel.fromJson(Map<String, dynamic> json) {
    return ButtonStyleModel(
      backgroundColor: json['backgroundColor'] as String?,
      textColor: json['textColor'] as String?,
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
    );
  }
}

// ---------------------------------------------------------------------------
// Action definitions
// ---------------------------------------------------------------------------

class ActionDef {
  final String type;
  final String? targetScreenId;
  final String? message;

  const ActionDef({required this.type, this.targetScreenId, this.message});

  factory ActionDef.fromJson(Map<String, dynamic> json) {
    return ActionDef(
      type: json['type'] as String,
      targetScreenId: json['targetScreenId'] as String?,
      message: json['message'] as String?,
    );
  }
}

// ---------------------------------------------------------------------------
// Component node (recursive)
// ---------------------------------------------------------------------------

class ComponentNode {
  final String type;
  final String? id;
  final Map<String, dynamic> props;
  final List<ComponentNode> children;
  final ActionDef? action;

  /// Controls conditional rendering. Accepts a literal `bool`, a string
  /// `"true"/"false"`, or a template expression like `"{{isLoggedIn}}"`.
  final dynamic visible;

  const ComponentNode({
    required this.type,
    this.id,
    this.props = const {},
    this.children = const [],
    this.action,
    this.visible,
  });

  factory ComponentNode.fromJson(Map<String, dynamic> json) {
    return ComponentNode(
      type: json['type'] as String,
      id: json['id'] as String?,
      props: (json['props'] as Map<String, dynamic>?) ?? {},
      children: (json['children'] as List<dynamic>?)
              ?.map((c) => ComponentNode.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      action: json['action'] != null
          ? ActionDef.fromJson(json['action'] as Map<String, dynamic>)
          : null,
      visible: json['visible'],
    );
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class Screen {
  final String id;
  final String title;
  final ComponentNode root;

  const Screen({required this.id, required this.title, required this.root});

  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      id: json['id'] as String,
      title: json['title'] as String,
      root: ComponentNode.fromJson(json['root'] as Map<String, dynamic>),
    );
  }
}

// ---------------------------------------------------------------------------
// Top-level contract envelope
// ---------------------------------------------------------------------------

class ScreenContract {
  final String schemaVersion;
  final Screen screen;

  /// Optional initial variable bindings for the expression engine.
  final Map<String, dynamic> context;

  const ScreenContract({
    required this.schemaVersion,
    required this.screen,
    this.context = const {},
  });

  factory ScreenContract.fromJson(Map<String, dynamic> json) {
    return ScreenContract(
      schemaVersion: json['schemaVersion'] as String,
      screen: Screen.fromJson(json['screen'] as Map<String, dynamic>),
      context: (json['context'] as Map<String, dynamic>?) ?? {},
    );
  }
}
