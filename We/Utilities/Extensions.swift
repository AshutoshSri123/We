import SwiftUI

struct SectionHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.accentColor)
            .padding(.vertical, 4)
    }
}

extension View {
    func sectionHeaderStyle() -> some View {
        self.modifier(SectionHeaderModifier())
    }
}

extension String {
    var isValidURL: Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^[0-9+\\-() ]{6,}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return pred.evaluate(with: self)
    }
    
    var asURL: URL? {
        if isValidURL {
            return URL(string: self)
        } else if let url = URL(string: "https://\(self)") {
            return url
        }
        return nil
    }
}
