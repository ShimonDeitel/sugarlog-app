import SwiftUI

/// Blood Sugar Note's identity: a palette built specifically for this app's domain
/// (reading tracking) - not a shared portfolio default.
enum AppTheme {
    static let backdrop = Color(red: 0.929, green: 0.957, blue: 0.957)
    static let card = Color.white
    static let cardBorder = Color(red: 0.204, green: 0.518, blue: 0.545).opacity(0.18)

    static let ink = Color(red: 0.12, green: 0.12, blue: 0.14)
    static let inkFaded = Color(red: 0.12, green: 0.12, blue: 0.14).opacity(0.56)

    static let accent = Color(red: 0.204, green: 0.518, blue: 0.545)
    static let accentDeep = Color(red: 0.133, green: 0.365, blue: 0.388)

    static let rule = Color.black.opacity(0.06)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let displayFont = Font.system(size: 40, weight: .bold, design: .rounded)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
        )
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

enum Haptics {
    static var enabled: Bool = true
    static func light() { guard enabled else { return }; UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func success() { guard enabled else { return }; UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func warning() { guard enabled else { return }; UINotificationFeedbackGenerator().notificationOccurred(.warning) }
}
