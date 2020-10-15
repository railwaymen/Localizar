import Vapor
import Fluent
import ModelValidator

final class UserModel: Model, Authenticatable {
    static let schema: String = "users"
    
    @ID var id: UUID?
    @Field(key: FieldKeys.username) var username: String
    @Field(key: FieldKeys.password) var password: String
    @Children(for: \UserTokenModel.$user) var tokens: [UserTokenModel]
    
    @Siblings(through: ProjectUserPivot.self, from: \.$user, to: \.$project)
    var projects: [ProjectModel]
    
    // MARK: - Initialization
    init() {}
    
    init(
        id: UUID? = nil,
        username: String,
        password: String
    ) {
        self.id = id
        self.username = username
        self.password = password
    }
    
    init(_ model: CreateModel) throws {
        self.username = model.username
        self.password = try Bcrypt.hash(model.password)
    }
}

// MARK: - Structures
extension UserModel {
    struct FieldKeys {
        static var username: FieldKey { "username" }
        static var password: FieldKey { "password" }
    }
    
    struct CreateModel: Decodable, ModelValidator.Validatable {
        typealias ValidationError = UserModel.ValidationError
        
        let username: String
        let password: String
        
        func validations(validations: inout ModelValidator.Validations<UserModel.CreateModel>) {
            validations.add(\.username, .count(4...), error: .usernameIsTooShort)
            validations.add(\.username) { username in
                guard !CharacterSet.alphanumerics.isSuperset(of: CharacterSet(charactersIn: username)) else { return nil }
                return .usernameIsNotAlphanumeric
            }
            validations.add(\.password, .count(8...), error: .passwordIsTooShort)
        }
    }
    
    enum ValidationError: CustomValidationError {
        case usernameIsTooShort
        case usernameIsNotAlphanumeric
        case usernameAlreadyExists
        
        case passwordIsTooShort
        
        var key: String {
            switch self {
            case .usernameIsTooShort:
                return "usernameIsTooShort"
            case .usernameIsNotAlphanumeric:
                return "usernameIsNotAlphanumeric"
            case .usernameAlreadyExists:
                return "usernameAlreadyExists"
                
            case .passwordIsTooShort:
                return "passwordIsTooShort"
            }
        }
    }
}
