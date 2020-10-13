import Vapor
import Fluent

struct ProjectsController {
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        throw Abort(.notFound)
    }
}
