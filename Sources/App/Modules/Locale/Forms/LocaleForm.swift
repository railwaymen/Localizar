import Vapor

struct LocaleForm: OutputForm {
    var id: String
    var displayName: String
    
    // MARK: - Initialization
    init(model: Locale) {
        self.id = model.id
        self.displayName = [model.nameEN, model.nameOriginal].joined(separator: " - ")
    }
    
    // MARK: - Internal
    func getOutput() -> Output {
        Output(
            id: id,
            displayName: displayName)
    }
}

// MARK: - Structures

extension LocaleForm {
    
    // MARK: Output
    struct Output: Encodable {
        let id: String
        let displayName: String
    }
}
