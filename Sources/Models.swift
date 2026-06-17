import Foundation

struct TaskList: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var emoji: String = "📋"
    var colorHex: String = "#7C6FF0"
}

struct TaskItem: Identifiable, Codable, Hashable {
    var id: String
    var listId: String
    var parentId: String? = nil
    var title: String
    var notes: String = ""
    var done: Bool = false
    var dueDate: Date? = nil
}

/// Routes for value-based navigation.
enum Route: Hashable {
    case list(String)
    case task(String)
}

func newId(_ prefix: String) -> String {
    "\(prefix)-\(Int(Date().timeIntervalSince1970 * 1000))-\(Int.random(in: 0..<100000))"
}
