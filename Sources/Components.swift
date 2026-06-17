import SwiftUI

/// Round, tappable completion check used across lists and task detail.
struct CheckButton: View {
    let done: Bool
    var size: CGFloat = 26
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .strokeBorder(done ? Color.appPrimary : Color.appTextMuted, lineWidth: 2)
                    .background(Circle().fill(done ? Color.appPrimary : Color.clear))
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: size * 0.5, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
    }
}
