# Architecture & Schema Specification

## Overview

This project implements a **Server-Driven UI** (also known as Backend-Driven Content) pattern entirely in Flutter/Dart. The app is a generic rendering engine that interprets JSON screen contracts and builds Flutter widget trees at runtime. No screens are hardcoded.

### Design principles

- **No hardcoded screens.** Every screen is a JSON contract loaded at runtime.
- **Recursive component tree.** A screen is a tree of nodes. Layout nodes contain children; leaf nodes render directly.
- **Actions over callbacks.** Interactive behaviour is declared in the JSON (navigate, snackbar, submit) — the engine interprets them.
- **Schema versioning.** Every contract includes `schemaVersion` so the engine can handle breaking changes gracefully.
- **Extensible registry.** Adding a new component type requires one builder function and one `register()` call.
- **Pluggable data source.** The `ApiClient` abstraction lets you swap local assets for a remote API without touching the rendering engine.

---

## Data Flow

```
JSON Contracts                          Flutter Rendering Engine
──────────────                          ───────────────────────
assets/screens/*.json                   LocalApiClient
       │                                     │
       ▼                                     ▼
  rootBundle.loadString()  ────────▶  ScreenContract (Dart model)
                                             │
                                             ▼
                                      ComponentParser
                                             │
                                       ┌─────┴─────┐
                                       ▼           ▼
                                   Layout      Leaf Nodes
                                   Nodes       (text, button,
                                   (column,     image, input)
                                    row, card)
                                       │
                                       ▼
                                  Widget Tree
                                       │
                                       ▼
                                  Rendered UI
```

1. The app navigates to a route like `/screen/home`.
2. `DynamicScreenPage` asks `LocalApiClient` to load `assets/screens/home.json`.
3. The JSON is deserialized into a `ScreenContract` model.
4. `ComponentParser` recursively walks the component tree and builds Flutter widgets.
5. The widget tree is rendered inside a `Scaffold` with `SingleChildScrollView`.

---

## Screen Contract Schema

### Top-level envelope

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schemaVersion` | `string` | Yes | Contract format version (currently `"1.0"`) |
| `screen` | `Screen` | Yes | The screen definition |

### Screen

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | Yes | Unique screen identifier |
| `title` | `string` | Yes | Displayed in the app bar |
| `root` | `ComponentNode` | Yes | Root of the component tree |

### ComponentNode

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | `string` | Yes | Component type identifier |
| `id` | `string` | No | Unique ID (used for input fields) |
| `props` | `object` | No | Type-specific properties |
| `children` | `ComponentNode[]` | No | Child nodes (for layout types) |
| `action` | `ActionDef` | No | Behaviour on interaction |

### ActionDef

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | `string` | Yes | One of: `navigate`, `snackbar`, `submit` |
| `targetScreenId` | `string` | For `navigate` | Screen ID to push |
| `message` | `string` | For `snackbar` | Message to display |

---

## Component Types

### Layout components

These components contain `children` and control layout.

#### `column`

Arranges children vertically.

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `mainAxisAlignment` | `string` | `"start"` | `start`, `center`, `end`, `spaceBetween`, `spaceAround`, `spaceEvenly` |
| `crossAxisAlignment` | `string` | `"start"` | `start`, `center`, `end`, `stretch` |
| `padding` | `EdgeInsets` | none | Padding around the column |

#### `row`

Arranges children horizontally. Same props as `column`.

#### `container`

Generic wrapper with optional background color.

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `padding` | `EdgeInsets` | none | Inner padding |
| `backgroundColor` | `string` | none | Hex color (e.g., `"#F5F5F5"`) |

#### `card`

Material card with elevation.

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `padding` | `EdgeInsets` | none | Inner padding |
| `elevation` | `number` | `1` | Shadow elevation |

#### `listView`

Scrollable list (nested inside `SingleChildScrollView`, uses `shrinkWrap`).

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `padding` | `EdgeInsets` | none | List padding |

### Leaf components

#### `text`

| Prop | Type | Description |
|------|------|-------------|
| `content` | `string` | The text to display |
| `style.fontSize` | `number` | Font size in logical pixels |
| `style.fontWeight` | `string` | `normal`, `bold`, or `w100`–`w900` |
| `style.color` | `string` | Hex color |
| `style.textAlign` | `string` | `left`, `center`, `right` |

#### `button`

| Prop | Type | Description |
|------|------|-------------|
| `label` | `string` | Button text |
| `style.backgroundColor` | `string` | Hex background color |
| `style.textColor` | `string` | Hex text color |
| `style.borderRadius` | `number` | Corner radius (default: 8) |

Buttons typically carry an `action`.

#### `image`

| Prop | Type | Description |
|------|------|-------------|
| `url` | `string` | Image URL |
| `width` | `number` | Width in logical pixels |
| `height` | `number` | Height in logical pixels |
| `fit` | `string` | `cover`, `contain`, `fill`, `fitWidth`, `fitHeight`, `none` |
| `borderRadius` | `number` | Corner radius |

#### `input`

| Prop | Type | Description |
|------|------|-------------|
| `label` | `string` | Field label |
| `hint` | `string` | Placeholder text |
| `maxLines` | `number` | Number of lines (default: 1) |
| `keyboardType` | `string` | `text`, `emailAddress`, `number`, `phone`, `url`, `multiline` |

Input nodes should have an `id` so the submit action can collect their values.

#### `spacer`

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `height` | `number` | `16` | Vertical space |
| `width` | `number` | none | Horizontal space |

### EdgeInsets object

| Field | Type | Default |
|-------|------|---------|
| `top` | `number` | `0` |
| `bottom` | `number` | `0` |
| `left` | `number` | `0` |
| `right` | `number` | `0` |

---

## Action Types

### `navigate`

Pushes a new `DynamicScreenPage` onto the navigation stack.

```json
{ "type": "navigate", "targetScreenId": "profile" }
```

### `snackbar`

Shows a snackbar with the given message.

```json
{ "type": "snackbar", "message": "Hello!" }
```

### `submit`

Collects all input field values on the current screen (keyed by component `id`) and displays them in a snackbar.

```json
{ "type": "submit" }
```

---

## App Architecture

```
lib/
├── main.dart                           # MaterialApp with onGenerateRoute
├── core/
│   ├── models/screen_contract.dart     # Data classes with fromJson
│   ├── network/
│   │   ├── api_client.dart             # Abstract client interface
│   │   └── local_api_client.dart       # Loads JSON from bundled assets
│   └── parser/
│       ├── component_parser.dart       # Recursive tree → widget builder
│       └── component_registry.dart     # Type → builder function map
└── presentation/
    ├── dynamic_screen_page.dart        # Load + render + error handling
    └── widgets/
        ├── server_text.dart            # Text builder
        ├── server_button.dart          # Button builder + action handler
        ├── server_image.dart           # Network image builder
        ├── server_input.dart           # TextField builder
        └── unknown_component.dart      # Fallback for unknown types
```

### Key design decisions

- **`ApiClient` abstraction** — `LocalApiClient` loads from bundled assets. To switch to a remote API, implement a `RemoteApiClient` with the same interface. The rendering engine doesn't change.
- **`ComponentRegistry`** decouples the parser from individual components. Adding a new type is one function + one `register()` call.
- **`InputCollectorState`** is an abstract state class that `DynamicScreenPage` extends, allowing buttons anywhere in the tree to access collected input values via `context.findAncestorStateOfType`.
- **Error handling** covers loading states, asset load failures with retry, and unknown component types rendered as visible warning boxes.

---

## Adding a New Screen

1. Create a JSON file at `assets/screens/your_screen.json` following the contract schema above.
2. Reference it from any button action:

```json
{ "type": "navigate", "targetScreenId": "your_screen" }
```

No Dart code changes needed.

---

## Adding a New Component

1. Create a builder function in `presentation/widgets/` matching the `ComponentBuilder` signature:

```dart
Widget buildYourComponent(
  ComponentNode node,
  BuildContext context,
  Widget Function(ComponentNode) buildChild,
) {
  // Build and return your widget
}
```

2. Register it in `ComponentParser._registerDefaults()`:

```dart
_registry.register('yourType', buildYourComponent);
```

No other files need to change.

---

## Scaling to Production

To evolve this into a production server-driven UI system:

- **Remote data source:** Implement a `RemoteApiClient` that fetches contracts from a REST API, Firebase Remote Config, or any backend.
- **Caching:** Add a caching layer that stores fetched contracts locally and falls back to cache when offline.
- **A/B testing:** The data source can return different contracts for different users.
- **Theming:** Add a `theme` node to the contract schema for dynamic colors and typography.
- **Animations:** Add transition definitions to navigation actions.
- **Validation:** Add a contract validator that checks schema version compatibility before rendering.
