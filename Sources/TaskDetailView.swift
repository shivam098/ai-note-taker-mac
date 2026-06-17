import SwiftUI

struct TaskDetailView: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    let taskId: String
    @State private var newSub = ""

    var body: some View {
        Group {
            if let task = store.task(taskId) {
                content(task)
            } else {
                ZStack {
                    Color.appBg.ignoresSafeArea()
                    Text("This task no longer exists.")
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
        }
    }

    @ViewBuilder
    private func content(_ task: TaskItem) -> some View {
        let subs = store.subtasks(taskId)
        ZStack {
            Color.appBg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        CheckButton(done: task.done, size: 28) { store.toggle(taskId) }
                        TextField("Task name", text: titleBinding, axis: .vertical)
                            .textFieldStyle(.plain)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.appText)
                    }

                    Text("NOTES")
                        .font(.caption).bold()
                        .foregroundStyle(Color.appTextSecondary)
                        .padding(.top, 8)
                    TextField("Add notes, links, or details…", text: notesBinding, axis: .vertical)
                        .textFieldStyle(.plain)
                        .foregroundStyle(Color.appText)
                        .frame(minHeight: 80, alignment: .topLeading)

                    HStack {
                        Text("SUBTASKS  \(subs.filter { $0.done }.count)/\(subs.count)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                    }
                    .padding(.top, 8)

                    ForEach(subs) { sub in
                        HStack(spacing: 12) {
                            CheckButton(done: sub.done, size: 22) { store.toggle(sub.id) }
                            NavigationLink(value: Route.task(sub.id)) {
                                HStack {
                                    Text(sub.title)
                                        .foregroundStyle(sub.done ? Color.appTextMuted : Color.appText)
                                        .strikethrough(sub.done)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.appTextMuted)
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 8)
                    }

                    HStack(spacing: 10) {
                        TextField("Add a subtask…", text: $newSub)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Color.appText)
                            .padding(12)
                            .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 14))
                            .onSubmit { store.addTask(listId: task.listId, title: newSub, parentId: taskId); newSub = "" }
                        Button {
                            store.addTask(listId: task.listId, title: newSub, parentId: taskId); newSub = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color.appPrimary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 4)
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Task")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .destructive) {
                    store.deleteTask(taskId)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }

    private var titleBinding: Binding<String> {
        Binding(get: { store.task(taskId)?.title ?? "" }, set: { store.updateTask(taskId, title: $0) })
    }

    private var notesBinding: Binding<String> {
        Binding(get: { store.task(taskId)?.notes ?? "" }, set: { store.updateTask(taskId, notes: $0) })
    }
}
