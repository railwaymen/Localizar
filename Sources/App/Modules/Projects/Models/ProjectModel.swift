import Vapor
import Fluent

final class ProjectModel: Model {
    static let schema: String = "projects"
    
    @ID var id: UUID?
    @Field(key: FieldKeys.name) var name: String
    
    @Siblings(through: ProjectUserPivot.self, from: \.$project, to: \.$user)
    var users: [UserModel]
    
    // MARK: - Initialization
    init() {}
    
    init(
        id: UUID? = nil,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

// MARK: - Structures
extension ProjectModel {
    struct FieldKeys {
        static var name: FieldKey { "name" }
    }
}
