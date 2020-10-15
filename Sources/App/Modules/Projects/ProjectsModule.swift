import Vapor
import Fluent

struct ProjectsModule: Module {
    static let router: RouteCollection = ProjectsRouter()
}
