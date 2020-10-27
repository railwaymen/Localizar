import Vapor

struct ProjectsRouter: RouteCollection {
    private let controller = ProjectsController()
    
    func boot(routes: RoutesBuilder) throws {
        let routesV1 = routes
            .grouped("v1")
            .grouped(UserTokenAuthenticator<UserTokenModel>())
            .grouped(UserModel.guardMiddleware())
        routesV1.get("projects", use: controller.getAll)
        routesV1.get("projects", .parameter(ProjectModel.slugParameter), use: controller.getDetails)
        routesV1.post("projects", use: controller.create)
        routesV1.put("projects", .parameter(ProjectModel.slugParameter), use: controller.update)
    }
}
