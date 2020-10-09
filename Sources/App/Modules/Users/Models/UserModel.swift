import Vapor
import Fluent

final class UserModel: Model, Authenticatable {
    static let schema: String = "users"
    
    @ID var id: UUID?
    @Field(key: FieldKeys.username) var username: String
    @Field(key: FieldKeys.password) var password: String
    @Children(for: \UserTokenModel.$user) var tokens: [UserTokenModel]
    
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
}

// MARK: - Structures
extension UserModel {
    struct FieldKeys {
        static var username: FieldKey { "username" }
        static var password: FieldKey { "password" }
    }
}
