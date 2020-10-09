import Vapor
import Fluent

struct FrontendModule: Module {
    static var migrations: [Migration] { [] }
    static var router: RouteCollection { FrontendRouter() }
}
