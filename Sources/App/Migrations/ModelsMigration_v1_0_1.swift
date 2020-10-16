import Vapor
import Fluent

struct ModelsMigration_v1_0_1: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(ProjectModel.schema)
                .id()
                .field(ProjectModel.FieldKeys.name, .string, .required)
                .create(),
            database.schema(ProjectUserPivot.schema)
                .id()
                .field(ProjectUserPivot.FieldKeys.project, .uuid, .required)
                .field(ProjectUserPivot.FieldKeys.user, .uuid, .required)
                .foreignKey(
                    ProjectUserPivot.FieldKeys.project,
                    references: ProjectModel.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade)
                .foreignKey(
                    ProjectUserPivot.FieldKeys.user,
                    references: UserModel.schema, .id,
                    onDelete: .cascade,
                    onUpdate: .cascade)
                .create()
        ])
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(ProjectUserPivot.schema)
                .delete(),
            database.schema(ProjectModel.schema)
                .delete()
        ])
    }
}
