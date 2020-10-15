import Vapor

struct LocaleRouter: RouteCollection {
    private let controller = LocaleController()
    
    func boot(routes: RoutesBuilder) throws {
        let routesV1 = routes.grouped("v1")
        routesV1.get("locales", use: controller.getAll)
    }
}
