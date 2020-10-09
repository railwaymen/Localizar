import Vapor

struct UsersRouter: RouteCollection {
    private let controller = UsersController()
    
    func boot(routes: RoutesBuilder) throws {
        let routesV1 = routes.grouped("v1")
        routesV1.post("sessions", use: controller.login)
    }
}
