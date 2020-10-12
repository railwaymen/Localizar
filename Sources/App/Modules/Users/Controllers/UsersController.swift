import Vapor
import Fluent

final class UsersController {
    func login(_ req: Request) throws -> EventLoopFuture<Response> {
        UserCredentialsAuthenticator()
            .authenticate(req: req)
            .guard({ _ in req.auth.has(UserModel.self) }, else: Abort(.unauthorized))
            .flatMapThrowing { try $0.apiModel() }
            .flatMapThrowing { try JSONEncoder().encode($0) }
            .flatMap { tokenData in
                let response = Response(status: .ok, body: .init(data: tokenData))
                return response.encodeResponse(for: req)
            }
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
            .flatMap {
                let response = Response(status: .ok)
                return response.encodeResponse(for: req)
            }
    }
}
