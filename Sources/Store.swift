import Foundation
import Observation

/// Offline-first observable store backed by a JSON file in Application Support.
@Observable
final class Store {
    var lists: [TaskList] = []
    var tasks: [TaskItem] = []

    init() {
        load()
    }

    // MARK: - Queries

    func list(_ id: String) -> TaskList? { lists.first { $0.id == id } }
    func task(_ id: String) -> TaskItem? { tasks.first { $0.id == id } }

    func topTasks(listId: String) -> [TaskItem] {
        tasks.filter { $0.listId == listId && $0.parentId == nil }
    }

    func subtasks(_ parentId: String) -> [TaskItem] {
        tasks.filter { $0.parentId == parentId }
    }

    func openCount(listId: String) -> Int {
        tasks.filter { $0.listId == listId && $0.parentId == nil && !$0.done }.count
    }

    // MARK: - Mutations

    func addList(_ title: String, emoji: String = "📋") {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        lists.append(TaskList(id: newId("list"), title: t, emoji: emoji))
        save()
    }

    func addTask(listId: String, title: String, parentId: String? = nil) {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        tasks.append(TaskItem(id: newId("task"), listId: listId, parentId: parentId, title: t))
        save()
    }

    func toggle(_ id: String) {
        guard let i = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[i].done.toggle()
        save()
    }

    func updateTask(_ id: String, title: String? = nil, notes: String? = nil) {
        guard let i = tasks.firstIndex(where: { $0.id == id }) else { return }
        if let title { tasks[i].title = title }
        if let notes { tasks[i].notes = notes }
        save()
    }

    func deleteTask(_ id: String) {
        var remove: Set<String> = [id]
        var changed = true
        while changed {
            changed = false
            for t in tasks where t.parentId != nil && remove.contains(t.parentId!) && !remove.contains(t.id) {
                remove.insert(t.id)
                changed = true
            }
        }
        tasks.removeAll { remove.contains($0.id) }
        save()
    }

    // MARK: - Persistence

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("ainotetaker.json")
    }

    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let snapshot = try JSONDecoder().decode(Snapshot.self, from: data)
            lists = snapshot.lists
            tasks = snapshot.tasks
        } catch {
            seed()
        }
    }

    func save() {
        let snapshot = Snapshot(lists: lists, tasks: tasks)
        do {
            let dir = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            let data = try JSONEncoder().encode(snapshot)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            // Best-effort local persistence.
        }
    }

    private func seed() {
        lists = [
            TaskList(id: "inbox", title: "Inbox", emoji: "📥"),
            TaskList(id: "work", title: "Work", emoji: "💼", colorHex: "#7C6FF0"),
            TaskList(id: "personal", title: "Personal", emoji: "🌿", colorHex: "#34C759"),
            TaskList(id: "groceries", title: "Groceries", emoji: "🛒", colorHex: "#FF9F45"),
        ]
        tasks = [
            TaskItem(id: "t1", listId: "inbox", title: "Try AI Note Taker"),
            TaskItem(id: "t2", listId: "work", title: "Ship launch plan", notes: "Coordinate design + marketing."),
            TaskItem(id: "t3", listId: "work", parentId: "t2", title: "Write release notes"),
            TaskItem(id: "t4", listId: "work", parentId: "t2", title: "Schedule announcement"),
            TaskItem(id: "t5", listId: "personal", title: "Morning workout"),
            TaskItem(id: "t6", listId: "groceries", title: "Oat milk"),
            TaskItem(id: "t7", listId: "groceries", title: "Coffee beans", done: true),
        ]
    }
}

private struct Snapshot: Codable {
    var lists: [TaskList]
    var tasks: [TaskItem]
}
