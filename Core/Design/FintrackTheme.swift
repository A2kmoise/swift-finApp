import SwiftUI

enum FintrackTheme {
    static let primaryGreen = Color(red: 0.58, green: 0.99, blue: 0.25) // adjust as needed
    static let background = Color.black
    static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.10)
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
}

extension Text {
    func fintrackTitleStyle() -> some View {
        self
            .font(.title2.weight(.semibold))
            .foregroundColor(FintrackTheme.textPrimary)
    }

    func fintrackSubtitleStyle() -> some View {
        self
            .font(.subheadline)
            .foregroundColor(FintrackTheme.textSecondary)
    }
}
