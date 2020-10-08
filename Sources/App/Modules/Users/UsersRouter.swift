import Vapor

struct UsersRouter: RouteCollection {
    private let controller = UsersController()
    
    func boot(routes: RoutesBuilder) throws {
        let v1 = routes.grouped("v1")
        v1.post("sessions", use: controller.login)
    }
}
