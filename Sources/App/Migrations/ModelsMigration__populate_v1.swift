import Vapor
import Fluent

struct ModelsMigration__populate_v1: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        ProjectModel.query(on: database)
            .filter(\.$slug == nil)
            .all()
            .mapEach { project -> EventLoopFuture<Void> in
                guard let newSlug = project.name.convertedToSlug() else {
                    return project.delete(on: database)
                }
                project.slug = newSlug
                return project.update(on: database)
            }
            .flatMap { $0.flatten(on: database.eventLoop) }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.future()
    }
}
