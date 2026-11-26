# Handoff: finishing on a real Mac

For whoever picks this up on a Mac — a person, or a coding agent started in this repo (AGENTS.md points here). Work
through it in order: check where things stand, set up the Mac, build and test, install and set up the app, run the
checks only a real Mac can do, then report what you found.

Written 26 November 2026 on a Windows PC with no Mac: this prototype has never been built or run on a Mac yet (there's
no CI). Everything below about how the app behaves is read from the code, not tried.

## 1. Where things stand

AI Note Taker for Mac is a SwiftUI app for lists, tasks and notes, with a dark, violet look and a Mac sidebar. It was
scaffolded in one commit in June 2026, and nothing has changed since.

What's in the code (`Sources/`, 7 Swift files):

- **Sidebar** (`AINoteTakerApp.swift`): the lists, each with an emoji and its number of open tasks, and a box at the
  bottom to add a list.
- **List page** (`ListDetailView.swift`): the open tasks, a "Completed" section, and a box to add a task. Each row has a
  round check button, and shows "done/total subtasks" and a notes icon when there are any.
- **Task page** (`TaskDetailView.swift`): editable title and notes, subtasks (a subtask can have its own subtasks, with
  no limit), and a trash button in the toolbar that deletes the task and everything under it.
- **Store** (`Store.swift`, `Models.swift`): one store shared by every window. It saves everything to
  `~/Library/Application Support/ainotetaker.json` after every change, including each keystroke in a title or notes.
  When there's no file, it starts with sample data: 4 lists (Inbox, Work, Personal, Groceries) and 7 tasks.
- **Look** (`Theme.swift`, `Components.swift`): the colours, and the check button. The app is always dark.
- **`project.yml`**: the XcodeGen spec. One app target, `AINoteTaker`: bundle ID `com.ainotetaker.mac`, macOS 14.0 or
  later, Swift 5, Hardened Runtime on. No App Sandbox, no entitlements, no signing team, and no scheme defined.

What's missing or stubbed:

- **No AI and no voice,** despite the name. The README's roadmap lists AI features (voice → tasks, summaries) and says
  they need an AI API key.
- Lists can be added, but not renamed, deleted or reordered. The model has a colour for each list and a due date for
  each task; the app doesn't show or edit either.
- No menu commands, keyboard shortcuts, due dates, reminders or sync (all on the README's roadmap), and no search.
- No app icon, no tests, no CI.
- If the saved file can't be read, the app quietly starts again with the sample data, and the next change overwrites
  the file.

AI Note Taker for iPhone and Android is in [ai-note-taker-ios](https://github.com/shivam098/ai-note-taker-ios) and
[ai-note-taker-android](https://github.com/shivam098/ai-note-taker-android): one scaffold commit each, and no CI.

The code described here is `main` at `259e99d9885b218f4adb24443792b17e5943208d`, the only commit before this
handoff. Before you start: `git pull` and `gh pr list` — later work may have landed.

## 2. Set up this Mac

**macOS 14 (Sonoma) or later.** The app's deployment target is macOS 14.0.

**Xcode 15 or later**, because the code uses the Observation framework (`@Observable`). Install the newest Xcode your
macOS supports from the App Store, open it once so it finishes installing, then:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
xcodebuild -version
```

**Xcode's command line tools:** `xcode-select --install` (if it says they're already installed, that's fine).

**Homebrew** (<https://brew.sh>), then XcodeGen and the GitHub CLI:

```sh
brew install xcodegen gh
```

**GitHub, as shivam098:**

```sh
gh auth login      # GitHub.com, HTTPS, log in with a browser as shivam098
gh auth setup-git  # git pushes with that login
gh auth status     # should show shivam098
```

**The repo,** with commits in the owner's name:

```sh
gh repo clone shivam098/ai-note-taker-mac
cd ai-note-taker-mac
git config user.name shivam098
git config user.email 39924466+shivam098@users.noreply.github.com
```

## 3. Build and test

`project.yml` is the source of truth. The Xcode project is generated from it and isn't committed (`.gitignore` skips
`*.xcodeproj` and `build/`).

```sh
xcodegen generate   # writes AINoteTaker.xcodeproj
xcodebuild -project AINoteTaker.xcodeproj -target AINoteTaker -configuration Debug build
```

Expect `** BUILD SUCCEEDED **`, and the app at `build/Debug/AINoteTaker.app` (xcodebuild's default folder for a
`-target` build). Or open `AINoteTaker.xcodeproj` in Xcode and press ⌘R: Xcode makes a scheme for the target the first
time, since `project.yml` doesn't define one.

- **There are no tests.** There's no test target, so every check in section 5 is by hand.
- **Untested: signing.** `project.yml` sets no team. If `xcodebuild` stops with a signing error, add
  `CODE_SIGN_IDENTITY=-` to the command (Xcode's "Sign to Run Locally", no Apple account needed), or
  `DEVELOPMENT_TEAM=<your team ID>` to sign with your Apple team. Anything you change in Xcode's project editor is lost
  the next time you run `xcodegen generate`; put lasting changes in `project.yml`.
- **If the build fails,** fix the compile errors in small PRs, one problem per PR. The code has never been compiled, so
  there may be some.
- **A good first PR:** a GitHub Actions workflow on `macos-15` that runs `brew install xcodegen`, `xcodegen generate`
  and the build command above (with `CODE_SIGN_IDENTITY=-`, as the runner has no team). Building with `-target` needs
  no scheme; to use `-scheme` instead, add a `schemes:` entry to `project.yml` first.

## 4. Install and set up the app

Run it from Xcode (⌘R), or:

```sh
open build/Debug/AINoteTaker.app
```

To keep a copy, drag `build/Debug/AINoteTaker.app` into Applications. An app you built on this Mac isn't
quarantined, so macOS doesn't ask you to "Open Anyway".

- **Permissions:** none. The app doesn't use the microphone, the network, or any file except its own data file.
- **First run:** the sample lists and tasks appear. There's nothing else to set up.
- **Its data** is in `~/Library/Application Support/ainotetaker.json`. To start again from the sample data, quit the
  app and delete that file.

## 5. What only a real Mac can check

These need a person at the Mac. An agent can build the app, then walk the person through this list and write down
the answers. Note anything that looks wrong, even if it isn't on the list.

1. **First launch.** A dark window, at least 720 × 480, with a "Lists" sidebar: 📥 Inbox, 💼 Work, 🌿 Personal and
   🛒 Groceries, each with 1 open task. The page on the right shows Inbox ("Try AI Note Taker"), though no list is
   highlighted yet.
2. **Always dark.** Switch macOS to Light (System Settings › Appearance): the app stays dark.
3. **Choosing a list.** Click each list, then move with the arrow keys: the page switches to that list, titled with its
   emoji and name.
4. **Adding a list.** Type a name in "New list" at the bottom of the sidebar and press Return, or click +: it's added
   at the end with 📋 and 0. An empty or spaces-only name adds nothing.
5. **Adding a task.** Type in "Add a task…" and press Return, or click the violet +: the task appears and the list's
   count goes up by one. An empty name adds nothing.
6. **Completing a task.** Click a task's circle: it moves under "COMPLETED", struck through, and the count goes down.
   Click it again to undo. In Groceries, "Coffee beans" starts completed.
7. **Opening a task.** Click a task's name: its page shows the title, NOTES, and SUBTASKS with done/total. The back
   button in the toolbar returns to the list.
8. **Editing.** Change the title, and write notes over several lines. Back on the list, the row shows the new title and
   a notes icon.
9. **Subtasks.** Work › "Ship launch plan" has 2 subtasks. Add one with "Add a subtask…" and tick one: the page says
   1/3, and the list row says "1/3 subtasks". Open a subtask and give it a subtask of its own.
10. **Deleting.** On a task's page, click the trash button: the task and all its subtasks, at every level, are gone,
    and you're back on the page you came from. The code asks for no confirmation and has no undo.
11. **Saving.** Make some changes, quit (⌘Q) and reopen: everything is as you left it. Quit, delete
    `~/Library/Application Support/ainotetaker.json`, reopen: the sample data is back.
12. **A damaged data file.** Quit, replace the file's contents with some junk text, reopen. From the code: the sample
    data shows, and your next change overwrites the file. Write down what actually happens.
13. **A second window.** File › New Window (⌘N): it shows the same lists, and a change in one window shows in the other.
14. **Lots of tasks.** Add 30 or more tasks to one list: the page scrolls, and the "Add a task…" box stays at the
    bottom.

## 6. Report what you found

Write the results to `docs/test-results/<YYYY-MM-DD>-<Mac model>.md` (for example
`docs/test-results/2026-11-27-MacBook-Air-M2.md`) and open a PR with it. Include the Mac model, chip, macOS version,
Xcode version and the commit you tested, then each item of section 5 (and the build from section 3) with pass or fail
and notes. These print what you need:

```sh
system_profiler SPHardwareDataType | grep -E "Model Name|Chip|Processor Name"
sw_vers
xcodebuild -version
git rev-parse HEAD
```

Open one GitHub issue per problem (`gh issue create`), with the steps to reproduce it, what you expected and what
happened, and your Mac and macOS version. If the app crashed, attach the crash report (Console › Crash Reports, or
`~/Library/Logs/DiagnosticReports`).

## 7. Rules for agents working here

- One PR per change.
- CI green where CI exists. There's none yet; once a workflow is added, don't merge while it's red.
- An independent review before merging: a person or agent that didn't write the change.
- Squash-merge.
- Every PR description starts with the owner's Agent assessment block, before anything else:

  ```markdown
  <!-- copilot-assessment:v1 -->
  ### Agent assessment

  Self-reported assessment, not an independent review.

  Assessed revision: `<full 40-character head SHA>`

  | Dimension | Assessment | Rationale |
  |---|---|---|
  | Change confidence | 7/10 | ↑ what supports the change<br>↓ what isn't verified yet |
  <!-- /copilot-assessment -->
  ```

  The score is out of 10. A bug fix also gets rows for Diagnosis confidence and Evidence fit. Put each ↑ (supporting)
  and ↓ (unverified) item on its own line with `<br>`, keep `|` out of the cells, and update the SHA when you push
  again.
- Never commit secrets or build output. `build/`, `DerivedData/` and the generated `.xcodeproj` are in `.gitignore`.
- Edit `project.yml`, not the generated Xcode project.
- Don't build a reduced version of a feature, or add extra security measures, without asking the owner.
- State measurements as findings, and ask the owner before drawing conclusions from them.
- Commit as `shivam098 <39924466+shivam098@users.noreply.github.com>`.

## 8. Decisions waiting for the owner

- **Is this prototype still wanted?** Jarvis for Mac
  ([mac-voice-assistant](https://github.com/shivam098/mac-voice-assistant), in development) plans a voice "idea board"
  for ideas, to-dos and reminders ("add renew passport to my to-do list", "remind me to call mom tomorrow at 5 pm").
  This app is a typed list of tasks and notes, and its roadmap adds reminders and voice → tasks. ThumbFree for Mac
  ([thumbfree-mac](https://github.com/shivam098/thumbfree-mac)) is dictation only and keeps no tasks. The iPhone and
  Android versions of this app are at the same scaffold stage.
- **Where its AI would run.** The README says the AI features need an AI API key, which suggests an online service.
  Jarvis for Mac runs its AI model on the Mac.
- **If it's kept:** which Apple team signs it, an app icon, and how it's shared.
