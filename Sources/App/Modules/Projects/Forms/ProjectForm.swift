import Vapor
import Fluent

struct ProjectForm: InOutForm {
    var name: String
    var slug: String
    
    // MARK: - Initialization
    init() {
        self.name = ""
        self.slug = ""
    }
    
    init(req: Request) throws {
        let input = try req.content.decode(Input.self)
        self.name = input.name
        self.slug = input.name.convertedToSlug() ?? ""
    }
    
    init(model: ProjectModel) {
        self.name = model.name
        self.slug = model.slug!
    }
    
    // MARK: - Internal
    func createModel() throws -> ProjectModel {
        guard !slug.isEmpty else { throw ValidationError.slugCouldNotBeGenerated }
        return ProjectModel(
            name: name,
            slug: slug)
    }
    
    func validate(on database: Database) -> EventLoopFuture<ValidationError?> {
        ProjectModel.query(on: database)
            .filter(\.$slug == slug)
            .first()
            .map { $0 == nil ? nil : ValidationError.projectNameAlreadyExists }
            .unwrap(orElse: { firstValidationError() })
        
    }
    
    func getOutput() -> Output {
        Output(name: name, slug: slug)
    }
}

// MARK: - Private
extension ProjectForm {
    private func firstValidationError() -> ValidationError? {
        guard !name.isEmpty else { return .projectNameTooShort }
        guard !slug.isEmpty else { return .slugCouldNotBeGenerated }
        return nil
    }
}

// MARK: - Structures

extension ProjectForm {
    
    // MARK: ValidationError
    enum ValidationError: CustomValidationError {
        case projectNameAlreadyExists
        case projectNameTooShort
        
        case slugCouldNotBeGenerated
        
        var key: String {
            switch self {
            case .projectNameAlreadyExists:
                return "projectNameAlreadyExists"
            case .projectNameTooShort:
                return "projectNameTooShort"
            case .slugCouldNotBeGenerated:
                return "slugCouldNotBeGenerated"
            }
        }
    }
    
    // MARK: Input
    private struct Input: Decodable {
        let name: String
    }
    
    // MARK: Output
    struct Output: Encodable {
        let name: String
        let slug: String
    }
}
