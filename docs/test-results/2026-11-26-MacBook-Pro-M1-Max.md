# Real-Mac test results: 2026-11-26

- Mac: MacBook Pro, Apple M1 Max
- macOS: 27.0.1 (26A434)
- Xcode: 26.6 (17F113); XcodeGen: 2.46.0
- App revision: `a30551e66b006620d877b392923fa07a0ad16049`
- Method: owner confirmed the initial appearance and Light-mode behavior; the remaining checks used local accessibility automation and, where noted, inspection of the saved JSON. The app's pre-test data was restored afterward.

## Build

**Pass:** `xcodegen generate` and `xcodebuild -project AINoteTaker.xcodeproj -target AINoteTaker -configuration Debug build CODE_SIGN_IDENTITY=-` succeeded. Installed and launched the locally signed app. There is no test target or automated test suite in this revision.

## Real-Mac checklist

| # | Result | Notes |
|---|---|---|
| 1 | Pass | Owner confirmed the dark window, four sample lists, and Inbox page. The window measured 900 × 532; accessibility showed one open task for each list. |
| 2 | Pass | Owner confirmed the app stayed dark with macOS set to Light. |
| 3 | Pass | Selecting each list changed the page. Down arrow moved Work to Personal when the sidebar was explicitly focused. The owner initially reported arrows did not work; focus was not established in that attempt. |
| 4 | Partial | Return and + each added a list. Empty and spaces-only submissions added none; the saved test list had the 📋 emoji. Its initial zero count was not separately checked. |
| 5 | Pass | Return and + each added a task. An empty submission added none. |
| 6 | Partial | A test task toggled complete and back; JSON reflected both changes. Coffee beans was initially complete. The completed section, strikethrough, and count change were not independently checked visually. |
| 7 | Pass | Opened a task; the page exposed title, NOTES and SUBTASKS, and Back returned to the previous page. |
| 8 | Fail | Title editing saved, but Return selected the existing notes text instead of inserting a newline, so further typing replaced it. Shift-Return had the same result. [Issue #2](https://github.com/shivam098/ai-note-taker-mac/issues/2). The notes icon was not visually checked. |
| 9 | Partial | Work started at 0/2; adding and completing a subtask showed 1/3 on the task page. A separate child received a nested subtask. The list-row 1/3 label was not visually checked. |
| 10 | Pass | Deleting a test parent removed its child and grandchild from the saved data and returned to the list. |
| 11 | Pass | After quit and reopen, a test list and its 31 open tasks were still present. Removing the saved file while quit restored the four sample lists on launch. Pre-test data was restored afterward. |
| 12 | Fail | Invalid JSON opened with sample lists; adding a list replaced the invalid file with a new JSON snapshot. [Issue #3](https://github.com/shivam098/ai-note-taker-mac/issues/3). |
| 13 | Pass | Command-N opened a second window. Adding a task in one updated the other window's list count to 31. |
| 14 | Pass | Added 30 tasks; the scroll bar moved from 0 to 1 while the add-task field stayed at the same screen position. |

No crashes were observed during these checks. The user-specific Applications copy was created by the earlier elevated session and is root-owned; a writable second clone was used for this report.
