import Vapor
import Fluent

struct UsersModule: Module {
    static var migrations: [Migration] {
        [
            UserMigration_v1_0_0()
        ]
    }
    
    static var router: RouteCollection { UsersRouter() }
}
