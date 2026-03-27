# Server-Driven UI in Flutter

A production-style **server-driven UI** architecture built entirely with Flutter and Dart. The app contains **zero hardcoded screens** — every layout, component, and navigation action is defined by JSON contracts that the engine renders dynamically at runtime.

## Concept

In a server-driven UI (also called Backend-Driven Content), the client is a **generic rendering engine**. Instead of writing widgets for each screen, you define screens as data — a JSON tree describing which components to render, how to lay them out, and what actions they trigger.

```
┌──────────────────────────────────────────────────────────┐
│                    JSON Contract                          │
│  { "type": "column", "children": [                       │
│      { "type": "text", "props": { "content": "Hi" } },  │
│      { "type": "button", "action": { ... } }             │
│  ]}                                                      │
└──────────────────────────┬───────────────────────────────┘
                           │  loaded from assets/
                           ▼
┌──────────────────────────────────────────────────────────┐
│                 Flutter Rendering Engine                   │
│  LocalApiClient → Models → ComponentParser → Widget Tree  │
└──────────────────────────────────────────────────────────┘
```

This demo loads contracts from bundled JSON assets. In production, these could come from a REST API, Firebase Remote Config, or any other source — the rendering engine stays the same.

## Features

- **10 component types:** column, row, container, card, listView, text, button, image, input, spacer
- **3 action types:** navigate (push screen), snackbar (show message), submit (collect form values)
- **Recursive parsing:** layout nodes contain children, built into a full widget tree
- **Pluggable registry:** adding a new component is one function + one `register()` call
- **Form support:** input fields with state collection and submit action
- **Error handling:** loading states, error with retry, unknown component placeholders

## Demo Screens

| Screen | Description |
|--------|-------------|
| `home` | Welcome page with navigation card, quick actions, and a banner image |
| `profile` | User profile with avatar, details card, and snackbar action |
| `form` | Feedback form with text inputs and submit |

## Quick Start

```bash
flutter pub get
flutter run
```

## JSON Contract Example

```json
{
  "schemaVersion": "1.0",
  "screen": {
    "id": "home",
    "title": "Home",
    "root": {
      "type": "column",
      "props": {
        "crossAxisAlignment": "stretch",
        "padding": { "top": 32, "bottom": 32, "left": 24, "right": 24 }
      },
      "children": [
        {
          "type": "text",
          "props": {
            "content": "Welcome to Server-Driven UI",
            "style": { "fontSize": 28, "fontWeight": "bold" }
          }
        },
        {
          "type": "button",
          "props": { "label": "View Profile" },
          "action": { "type": "navigate", "targetScreenId": "profile" }
        }
      ]
    }
  }
}
```

## Project Structure

```
├── assets/screens/                     # JSON screen contracts
│   ├── home.json
│   ├── profile.json
│   └── form.json
├── lib/
│   ├── main.dart                       # App entry with dynamic routing
│   ├── core/
│   │   ├── models/
│   │   │   └── screen_contract.dart    # Dart models with fromJson
│   │   ├── network/
│   │   │   ├── api_client.dart         # Abstract client interface
│   │   │   └── local_api_client.dart   # Loads JSON from assets
│   │   └── parser/
│   │       ├── component_parser.dart   # Recursive tree → widget builder
│   │       └── component_registry.dart # Type string → builder function map
│   └── presentation/
│       ├── dynamic_screen_page.dart    # Fetch + render + error handling
│       └── widgets/
│           ├── server_text.dart
│           ├── server_button.dart
│           ├── server_image.dart
│           ├── server_input.dart
│           └── unknown_component.dart
├── docs/ARCHITECTURE.md                # Full schema specification
├── pubspec.yaml
└── README.md
```

## Adding a New Screen

1. Create a JSON file at `assets/screens/your_screen.json`.
2. Reference it from any button action:

```json
{ "type": "navigate", "targetScreenId": "your_screen" }
```

No Dart code changes needed.

## Adding a New Component

1. Create a builder function in `lib/presentation/widgets/`.
2. Register it in `ComponentParser._registerDefaults()`:

```dart
_registry.register('yourType', buildYourComponent);
```

## Documentation

- [Architecture & Schema Specification](docs/ARCHITECTURE.md)

## Tech Stack

| Concern | Technology |
|---------|-----------|
| Language | Dart |
| Framework | Flutter 3.x |
| Architecture | Server-Driven UI / Backend-Driven Content |
