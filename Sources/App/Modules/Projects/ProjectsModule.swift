import Vapor
import Fluent

struct ProjectsModule: Module {
    static let migrations: [Migration] = [
        ProjectMigration_v1_0_0(),
    ]
    
    static let router: RouteCollection = ProjectsRouter()
}
