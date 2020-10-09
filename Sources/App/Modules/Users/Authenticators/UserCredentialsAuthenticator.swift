import Vapor
import Fluent

struct UserCredentialsAuthenticator {
    func authenticate(req: Request) -> EventLoopFuture<UserTokenModel> {
        do {
            let credentials = try req.content.decode(Credentials.self)
            return UserModel.query(on: req.db)
                .filter(\.$username, .equal, credentials.username)
                .first()
                .unwrap(or: Abort(.notFound))
                .flatMapThrowing { user throws -> UserModel.IDValue in
                    guard try Bcrypt.verify(credentials.password, created: user.password) else {
                        throw Abort(.unauthorized)
                    }
                    req.auth.login(user)
                    return try user.requireID()
                }
                .flatMap { userID -> EventLoopFuture<UserTokenModel> in
                    let token = UserTokenModel(
                        token: UUID().uuidString,
                        userID: userID)
                    
                    return token
                        .save(on: req.db)
                        .map { token }
                }
                .flatMap { token in
                    UserTokenModel.query(on: req.db)
                        .filter(\.$token == token.token)
                        .first()
                        .unwrap(or: Abort(.internalServerError))
                        .map { token in
                            req.auth.login(token)
                            return token
                        }
                }
        } catch {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
    }
}

// MARK: - Structures
extension UserCredentialsAuthenticator {
    private struct Credentials: Content {
        let username: String
        let password: String
    }
}
