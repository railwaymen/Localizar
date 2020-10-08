import Vapor
import Fluent

protocol Module {
    static var migrations: [Migration] { get }
    static var router: RouteCollection { get }
}

extension Module {
    static var migrations: [Migration] { [] }
    var migrations: [Migration] { Self.migrations }
    var router: RouteCollection { Self.router }
}
