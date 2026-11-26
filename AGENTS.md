# Agent instructions

AI Note Taker for Mac: a SwiftUI prototype of a lists, tasks and notes app (nested subtasks, saved to a JSON file),
scaffolded in June 2026. The Xcode project is generated from `project.yml` with XcodeGen.

**On a real Mac?** Start with [docs/HANDOFF-mac.md](docs/HANDOFF-mac.md): where the project stands, and how to finish
testing and set the app up.

- Build and run: `xcodegen generate`, then
  `xcodebuild -project AINoteTaker.xcodeproj -target AINoteTaker -configuration Debug build` and
  `open build/Debug/AINoteTaker.app` (or open `AINoteTaker.xcodeproj` in Xcode and press ⌘R).
  Run the store tests with `xcodebuild -project AINoteTaker.xcodeproj -scheme AINoteTaker -destination 'platform=macOS' test`.
  Edit `project.yml`, not the generated (git-ignored) Xcode project.
- Commit as `shivam098 <39924466+shivam098@users.noreply.github.com>`.
- One PR per change and an independent review before merging (squash). PR descriptions start with the owner's Agent
  assessment block (docs/HANDOFF-mac.md, section 7).
