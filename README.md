# AI Note Taker — macOS

Native Mac app (Swift + SwiftUI) for AI Note Taker — a tasks + notes + nested
lists app with a dark, violet-accented design and a Mac-style sidebar.

## Tech stack
- **Swift 5** + **SwiftUI** (macOS 14+)
- **Observation** framework (`@Observable Store`) for state
- **NavigationSplitView** sidebar (lists) + detail (tasks → task)
- **Offline-first** local persistence (Codable → JSON in Application Support)

## Features (scaffold)
- Sidebar of lists with open-task counts; add a list inline
- List detail: tasks, completed section, inline add
- Task detail: editable title + notes, **nested subtasks**, delete (toolbar)
- Seeded sample data; everything is free (no paywall)

## Build & run (on a Mac)
The Xcode project is generated from `project.yml` with **XcodeGen**:

```bash
brew install xcodegen        # one-time
cd ai-note-taker-mac
xcodegen generate            # creates AINoteTaker.xcodeproj
open AINoteTaker.xcodeproj   # then press Run in Xcode
```

### No XcodeGen? Alternative
1. In Xcode: File ▸ New ▸ Project ▸ macOS App (SwiftUI, name "AINoteTaker").
2. Delete the default `ContentView.swift` / `App.swift`.
3. Drag everything in `Sources/` into the project.
4. Set the deployment target to macOS 14 and press Run.

## Project layout
```
project.yml                 # XcodeGen spec (macOS app)
Sources/
  AINoteTakerApp.swift       # @main App + NavigationSplitView sidebar
  Models.swift               # TaskList, TaskItem, Route
  Store.swift                # @Observable store + JSON persistence
  Theme.swift                # dark + violet colors
  Components.swift           # CheckButton
  ListDetailView.swift       # tasks in a list
  TaskDetailView.swift       # title, notes, nested subtasks
```

## Roadmap
- Multiple windows, menu-bar commands, keyboard shortcuts
- Quick-add, due dates, reminders
- AI features (voice → tasks, summaries) — needs an AI API key
- Cloud sync & sharing; shares a design language with the iOS and Android apps
