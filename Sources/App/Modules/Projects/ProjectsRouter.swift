import Vapor

struct ProjectsRouter: RouteCollection {
    private let controller = ProjectsController()
    
    func boot(routes: RoutesBuilder) throws {
        let routesV1 = routes
            .grouped("v1")
            .grouped(UserTokenAuthenticator<UserTokenModel>())
            .grouped(UserModel.guardMiddleware())
            .grouped("projects")
        routesV1.get(use: controller.getAll)
        routesV1.get(.parameter(ProjectModel.slugParameter), use: controller.getDetails)
        routesV1.post(use: controller.create)
        routesV1.put(.parameter(ProjectModel.slugParameter), use: controller.update)
    }
}
