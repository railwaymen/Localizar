import Vapor
import Fluent
import FluentSQL

struct ModelsMigration_v1_0_2: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(ProjectModel.schema)
                .field(ProjectModel.FieldKeys.slug, .string)
                .update(),
        ])
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ProjectModel.schema)
            .deleteField(ProjectModel.FieldKeys.slug)
            .update()
    }
}
