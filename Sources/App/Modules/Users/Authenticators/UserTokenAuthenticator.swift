import Vapor
import Fluent

struct UserTokenAuthenticator<Token: ModelTokenAuthenticatable>: RequestAuthenticator {
    
    func authenticate(request req: Request) -> EventLoopFuture<Void> {
        guard let reqToken = req.headers.first(name: "Token") else {
            return req.eventLoop.future(error: Abort(.unauthorized))
        }
        return Token.query(on: req.db)
            .filter(\._$value == reqToken)
            .first()
            .flatMap { token -> EventLoopFuture<Void> in
                guard let token = token else {
                    return req.eventLoop.makeSucceededFuture(())
                }
                guard token.isValid else {
                    return token.delete(on: req.db)
                }
                req.auth.login(token)
                return token._$user.get(on: req.db).map {
                    req.auth.login($0)
                }
            }
    }
}

// MARK: - Helper Extensions
private extension ModelTokenAuthenticatable {
    var _$value: Field<String> {
        self[keyPath: Self.valueKey]
    }

    var _$user: Parent<User> {
        self[keyPath: Self.userKey]
    }
}
