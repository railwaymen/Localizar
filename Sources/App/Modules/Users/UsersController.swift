import Vapor
import Fluent

final class UsersController {
    func login(_ req: Request) throws -> EventLoopFuture<Response> {
        UserCredentialsAuthenticator()
            .authenticate(req: req)
            .guard({ _ in req.auth.has(UserModel.self) }, else: Abort(.unprocessableEntity))
            .flatMapThrowing { try $0.apiModel() }
            .flatMapThrowing { try Response.ok(body: $0) }
    }
    
    func register(_ req: Request) throws -> EventLoopFuture<Response> {
        let userData = try req.content.decode(UserModel.CreateModel.self)
        try userData.validate()
        let newUser = try UserModel(userData)
        return UserModel.query(on: req.db)
            .filter(\.$username == userData.username)
            .first()
            .guard({ $0 == nil }, else: UserModel.ValidationError.usernameAlreadyExists)
            .flatMap { _ in
                newUser.save(on: req.db)
            }
            .map { Response.noContent() }
    }
}
