# Rules & Conventions

Project rules, architecture, and conventions for Free File.

## Project Overview

Free File is a cross-platform file manager built with **Dart 3.10+ / Flutter**, targeting macOS (primary), with Windows and Linux coming soon. It is organized as a Flutter workspace monorepo.

## Common Commands

```bash
# Install dependencies (run from repo root)
dart pub get

# Run the desktop app
cd apps/ff_desktop && flutter run -d macos   # or -d windows / -d linux

# Lint / analyze
dart analyze

# Auto-fix and format
dart fix --apply && dart format .

# Production build
cd apps/ff_desktop && flutter build macos
```

## Architecture

### Monorepo Layout

```
free_file/
├── apps/                        # Platform-specific app entry points
│   ├── ff_desktop/              # Desktop app (macOS, Windows, Linux)
│   └── ff_mobile/               # Mobile app (iOS, Android) — future
├── modules/                     # Feature modules (vertical slices)
│   └── file_explorer/           # File explorer feature
├── packages/                    # Utility / infrastructure packages
│   ├── local_entity_provider/   # File system entity provider
│   ├── shortcut/                # Keyboard shortcut handling
│   ├── storage/                 # Persistent storage
│   └── utils/                   # General utilities
├── core_packages/               # Shared core packages
│   ├── core/                    # Domain models, constants, injector
│   ├── core_ui/                 # Shared UI components (tappable, context menus, etc.)
│   ├── l10n/                    # Localization (ARB → generated)
│   └── theme/                   # Theme tokens, configs, design constants
├── scripts/                     # Build and release scripts
└── pubspec.yaml                 # Workspace root (resolution: workspace)
```

### Where things go

| Directory | What goes here | What does NOT go here |
|-----------|----------------|----------------------|
| `apps/` | Platform entry points, DI setup, platform-specific code (`flutter_acrylic`, window management) | Business logic, feature UI |
| `modules/` | Feature modules — self-contained vertical slices with their own models, services, view models, and UI | Platform-specific dependencies, utility/infrastructure packages |
| `packages/` | Utility and infrastructure packages shared across modules | Feature-specific logic |
| `core_packages/` | Foundational shared code (models, UI primitives, theme, l10n) | Feature-specific logic |

### Feature Module Pattern (Vertical Slices)

Each module in `modules/` follows this structure:

```
modules/<name>/
├── lib/
│   ├── <name>.dart              # Top-level barrel file
│   ├── interfaces/              # Abstract service interfaces
│   ├── models/                  # Data models, enums, constants
│   ├── services/                # Feature-scoped services
│   ├── view_models/             # ChangeNotifier-based state
│   │   └── mixins/              # Shared ViewModel behavior
│   ├── utils/                   # Feature-specific utilities, extensions
│   └── ui/
│       ├── frames/              # Smart widgets (consume ViewModels via context.select)
│       ├── pages/               # Top-level screens
│       └── widgets/             # Dumb/reusable components
└── pubspec.yaml
```

### State Management & DI

- **ViewModels** use `ChangeNotifier` via Provider.
- **DI** uses GetIt as service locator. Access via `injector<MyService>()`.
- **Abstract interfaces** live in the module, concrete implementations that need platform deps live in the app and are registered in `apps/ff_desktop/lib/di.dart`.

### Platform Abstraction

Modules must never depend on platform-specific packages. When a module needs platform behavior:

1. Define an abstract interface in `modules/<name>/lib/interfaces/`
2. Implement it in `apps/<platform>/` with the platform-specific dependency
3. Register the concrete implementation in the app's DI setup
4. Use callbacks (like `sideBarWrapper`) for platform-specific UI wrapping

Example: `WindowServiceInterface` (module) → `WindowService` using `flutter_acrylic` (app).

## Code Conventions

**Imports**: Always use package imports, never relative. Import barrel files, not individual files.
```dart
import 'package:file_explorer/view_models/view_models.dart';  // correct
import 'package:file_explorer/view_models/tab_view_model.dart'; // wrong — import the barrel
```

**Barrel exports**: Each folder with multiple files needs a barrel file named after the folder (e.g., `ui/ui.dart`, `ui/widgets/widgets.dart`). Import the barrel, not individual files.

**Null safety**: Never use the `!` operator. Use pattern matching or local variable promotion with early return.
```dart
// correct
if (value case final v?) {
  return v;
}

// wrong
return value!;
```

**No ternary operators**: Use `switch` expressions instead of `? :`.
```dart
// correct
onTap: switch (model.canBack) {
  true => () => model.back(),
  false => null,
},

// wrong
onTap: model.canBack ? () => model.back() : null,
```

**Early returns**: Prefer guard clauses over else blocks. Keep the primary logic flow flat.

**Frames must use `context.select`** for efficient rebuilds — never `context.watch`:
```dart
final name = context.select<ExploreViewModel, String>((vm) => vm.name);
```

**Use `ChangeNotifierProvider.value` + `context.select`** instead of `ListenableBuilder`.

**Design Tokens**: Use `Spacing.dX` (e.g., `Spacing.d16`, `Spacing.d8`) for all padding, margins, icon sizes, and border radii. No magic numbers.

**Logging**: No `print()` — use `printLog()` or `printError()`.

**Dispose**: Always dispose all controllers, listeners, and subscriptions in `dispose()`.

**Dart 3+ features**: Use records, pattern matching, collection if/for. Use descriptive variable names in patterns.

**Comments**: Avoid redundant TODO or placeholder comments. Good code does not need comments to explain how it works.

**File size**: Keep files small and focused. One widget per file. Split large files by responsibility.

**Linting**: `always_use_package_imports`, `prefer_single_quotes`, `prefer_const_constructors`, `prefer_const_declarations`, `unawaited_futures`, `avoid_print`. Trailing commas preserved.

## UI Component Types

| Type | Location | Description |
|------|----------|-------------|
| **Frames** | `ui/frames/` | Smart widgets that consume ViewModels via `context.select` |
| **Pages** | `ui/pages/` | Top-level screen widgets |
| **Widgets** | `ui/widgets/` | Dumb, reusable components — no business logic or ViewModels |

## Version Control (Git)

- **Commit style**: Emoji prefixes for commit messages.
  - ✨ New feature
  - 🐛 Bug fix
  - ♻️ Refactor
  - 🔥 Remove code/files
  - 📝 Documentation
  - 🔖 Release / version bump
  - 🚀 Deploy / build scripts
  - 🌐 Localization
  - 🙈 Gitignore
- **Branching**: `develop` is the working branch, `main` is stable.
- **Commit scope**: One focused commit per change. Don't bundle unrelated work.

## Checklist Before Commit

- No lint warnings (`dart analyze`)
- Run `dart fix --apply && dart format .`
- No `!` operator used
- No ternary `? :` — use `switch` expressions
- Prefer no `else` blocks (use early return)
- Classes have `const` constructors where possible
- Must use barrel exports
- No platform-specific dependencies in modules
- Frames use `context.select`, never `context.watch`
