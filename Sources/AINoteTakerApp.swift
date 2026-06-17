import SwiftUI

@main
struct AINoteTakerApp: App {
    @State private var store = Store()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .preferredColorScheme(.dark)
                .tint(.appPrimary)
                .frame(minWidth: 720, minHeight: 480)
        }
        .windowStyle(.titleBar)
    }
}

struct RootView: View {
    @Environment(Store.self) private var store
    @State private var selection: String?
    @State private var newList = ""

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section("Lists") {
                    ForEach(store.lists) { list in
                        HStack(spacing: 8) {
                            Text(list.emoji)
                            Text(list.title)
                            Spacer()
                            Text("\(store.openCount(listId: list.id))")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.appTextMuted)
                        }
                        .tag(list.id)
                    }
                }
            }
            .navigationTitle("AI Note Taker")
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 8) {
                    TextField("New list", text: $newList)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(addList)
                    Button(action: addList) {
                        Image(systemName: "plus")
                    }
                }
                .padding(8)
            }
        } detail: {
            if let id = selection ?? store.lists.first?.id {
                NavigationStack {
                    ListDetailView(listId: id)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .task(let tid): TaskDetailView(taskId: tid)
                            case .list(let lid): ListDetailView(listId: lid)
                            }
                        }
                }
                .id(id)
            } else {
                ZStack {
                    Color.appBg.ignoresSafeArea()
                    Text("Select a list")
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
        }
    }

    private func addList() {
        store.addList(newList)
        newList = ""
    }
}
