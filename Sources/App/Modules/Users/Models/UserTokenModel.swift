import Vapor
import Fluent

final class UserTokenModel: ModelTokenAuthenticatable {
    static var schema: String = "user_tokens"
    static var valueKey: KeyPath<UserTokenModel, Field<String>> = \.$token
    static var userKey: KeyPath<UserTokenModel, Parent<UserModel>> = \.$user
    
    var isValid: Bool {
        createdAt.addingTimeInterval(.day) > Date()
    }
    
    @ID var id: UUID?
    @Field(key: FieldKeys.token) var token: String
    @Field(key: FieldKeys.createdAt) var createdAt: Date
    @Parent(key: FieldKeys.user) var user: UserModel
    
    // MARK: - Initialization
    init() {}
    
    init(
        id: UUID? = nil,
        token: String,
        createdAt: Date = Date(),
        userID: UserModel.IDValue
    ) {
        self.id = id
        self.token = token
        self.createdAt = createdAt
        self.$user.id = userID
    }
}

// MARK: - ApiModelType
extension UserTokenModel: ApiModelType {
    func apiModel() throws -> ApiModel {
        .init(token: token)
    }
}

// MARK: - Structures
extension UserTokenModel {
    struct FieldKeys {
        static var token: FieldKey { "token" }
        static var createdAt: FieldKey { "created_at" }
        static var user: FieldKey { "user_id" }
    }
    
    struct ApiModel: Codable {
        let token: String
    }
}
