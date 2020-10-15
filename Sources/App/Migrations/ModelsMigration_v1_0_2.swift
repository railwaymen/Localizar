import Vapor
import Fluent
import FluentSQL

struct ModelsMigration_v1_0_2: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(ProjectModel.schema)
                .field(ProjectModel.FieldKeys.slug, .string)
                .update(),
            ProjectModel.query(on: database)
                .all()
                .flatMapEach(on: database.eventLoop) { project -> EventLoopFuture<Void> in
                    guard let slug = project.name.convertedToSlug() else {
                        return project.delete(on: database)
                    }
                    project.slug = slug
                    return project.save(on: database)
                }
                .map { _ in Void() },
        ])
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ProjectModel.schema)
            .deleteField(ProjectModel.FieldKeys.slug)
            .update()
    }
}
