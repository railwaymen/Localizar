import Vapor
import Fluent

struct CreateProjectForm: Form {
    var name: String
    
    // MARK: - Initialization
    init() {
        self.name = ""
    }
    
    init(req: Request) throws {
        let input = try req.content.decode(Input.self)
        self.name = input.name
    }
    
    // MARK: - Internal
    func createModel() -> ProjectModel {
        ProjectModel(name: name)
    }
    
    func validate(on database: Database) -> EventLoopFuture<ValidationError?> {
        ProjectModel.query(on: database)
            .filter(\.$name == name)
            .first()
            .map { $0 == nil ? nil : ValidationError.projectNameAlreadyExists }
            .unwrap(orElse: { firstValidationError() })
    }
    
}

// MARK: - Private
extension CreateProjectForm {
    private func firstValidationError() -> ValidationError? {
        guard !name.isEmpty else { return .projectNameTooShort }
        return nil
    }
}

// MARK: - Structures

extension CreateProjectForm {
    
    // MARK: ValidationError
    enum ValidationError: CustomValidationError {
        case projectNameAlreadyExists
        case projectNameTooShort
        
        var key: String {
            switch self {
            case .projectNameAlreadyExists:
                return "projectNameAlreadyExists"
            case .projectNameTooShort:
                return "projectNameTooShort"
            }
        }
    }
    
    // MARK: Input
    private struct Input: Decodable {
        let name: String
    }
}
