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
}
