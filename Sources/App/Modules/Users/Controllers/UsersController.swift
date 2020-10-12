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
        return try UserModel(userData)
            .save(on: req.db)
            .flatMap {
                let response = Response(status: .ok)
                return response.encodeResponse(for: req)
            }
    }
}
