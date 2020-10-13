import Vapor
import Fluent

final class ProjectUserPivot: Model {
    static let schema: String = "project_user_pivots"
    
    @ID var id: UUID?
    @Parent(key: FieldKeys.project) var project: ProjectModel
    @Parent(key: FieldKeys.user) var user: UserModel
    
    // MARK: - Initialization
    init() {}
}

// MARK: - Structures
extension ProjectUserPivot {
    struct FieldKeys {
        static var project: FieldKey { "project" }
        static var user: FieldKey { "user" }
    }
}
