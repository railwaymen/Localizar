import Vapor

struct Locale {
    static let all: [Locale] = Foundation.Locale
        .availableIdentifiers
        .map {
            Locale(
                id: $0,
                nameEN: NSLocale(localeIdentifier: "en")
                    .displayName(forKey: .identifier, value: $0) ?? "",
                nameOriginal: NSLocale(localeIdentifier: $0)
                    .displayName(forKey: .identifier, value: $0) ?? "")
        }
    
    // MARK: - Instance
    let id: String
    let nameEN: String
    let nameOriginal: String
}
