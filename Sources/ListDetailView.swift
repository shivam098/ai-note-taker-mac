import SwiftUI

struct ListDetailView: View {
    @Environment(Store.self) private var store
    let listId: String
    @State private var newTask = ""

    var body: some View {
        let list = store.list(listId)
        let top = store.topTasks(listId: listId)
        let active = top.filter { !$0.done }
        let done = top.filter { $0.done }

        ZStack {
            Color.appBg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(active) { task in
                        TaskRowView(task: task)
                    }
                    if !done.isEmpty {
                        HStack {
                            Text("COMPLETED \(done.count)")
                                .font(.caption).bold()
                                .foregroundStyle(Color.appTextMuted)
                            Spacer()
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 6)
                        ForEach(done) { task in
                            TaskRowView(task: task)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(list.map { "\($0.emoji)  \($0.title)" } ?? "List")
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 10) {
                TextField("Add a task…", text: $newTask)
                    .textFieldStyle(.plain)
                    .foregroundStyle(Color.appText)
                    .padding(12)
                    .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 14))
                    .onSubmit { store.addTask(listId: listId, title: newTask); newTask = "" }
                Button {
                    store.addTask(listId: listId, title: newTask); newTask = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.appPrimary)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}

struct TaskRowView: View {
    @Environment(Store.self) private var store
    let task: TaskItem

    var body: some View {
        let subs = store.subtasks(task.id)
        HStack(spacing: 12) {
            CheckButton(done: task.done) { store.toggle(task.id) }
            NavigationLink(value: Route.task(task.id)) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(task.title)
                            .font(.system(size: 16))
                            .foregroundStyle(task.done ? Color.appTextMuted : Color.appText)
                            .strikethrough(task.done)
                        if !subs.isEmpty || !task.notes.isEmpty {
                            HStack(spacing: 8) {
                                if !subs.isEmpty {
                                    Text("\(subs.filter { $0.done }.count)/\(subs.count) subtasks")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.appTextMuted)
                                }
                                if !task.notes.isEmpty {
                                    Image(systemName: "note.text")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color.appTextMuted)
                                }
                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.appTextMuted)
                        .font(.system(size: 13, weight: .semibold))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
    }
}
