import Vapor
import Fluent

struct UsersModule: Module {
    static var router: RouteCollection { UsersRouter() }
}
