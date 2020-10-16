import Vapor

struct Locale {
    static let `default`: Locale = Locale.all.first(where: { $0.id == "en" })!
    
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

// MARK: - CustomStringConvertible
extension Locale: CustomStringConvertible {
    var description: String {
        let base = "[\(id)] \(nameEN)"
        guard nameEN != nameOriginal else { return base }
        return base + " - \(nameOriginal)"
    }
}

// MARK: - Array Extension
extension Array where Element == Locale {
    func contains(ids: [String]) -> Bool {
        ids.allSatisfy { contains(id: $0) }
    }
    
    func contains(id: String) -> Bool {
        contains(where: { $0.id == id })
    }
}
