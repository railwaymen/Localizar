import Vapor
import Fluent

struct TranslationForm {
    static func getPage(from page: Page<TranslationModel>) throws -> PageOutput {
        PageOutput(
            total: page.metadata.total,
            items: try page.items.map { try TranslationForm(model: $0).getOutput() })
    }
    
    var id: UUID?
    var key: String
    var value: String
    
    // MARK: - Initialization
    init(model: TranslationModel) throws {
        self.id = try model.requireID()
        self.key = model.key
        self.value = model.value
    }
    
    func getOutput() -> Output {
        Output(
            id: id!,
            key: key,
            value: value)
    }
}

extension TranslationForm {
    struct PageOutput: Encodable {
        let total: Int
        let items: [Output]
    }
    
    struct Output: Encodable {
        let id: UUID
        let key: String
        let value: String
    }
}
