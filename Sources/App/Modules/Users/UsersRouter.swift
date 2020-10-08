import Vapor

struct UsersRouter: RouteCollection {
    private let controller = UsersController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("sessions", use: controller.login)
    }
}
