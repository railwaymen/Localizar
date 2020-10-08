import Vapor

struct FrontendRouter: RouteCollection {
    private let controller = FrontendController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("v1", "**", use: { _ -> Response in throw Abort(.notFound) })
        routes.get("**", use: controller.index)
        routes.get(use: controller.index)
    }
}
