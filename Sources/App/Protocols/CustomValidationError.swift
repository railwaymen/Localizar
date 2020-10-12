import Vapor

protocol CustomValidationError: AbortError, CustomStringConvertible {
    var key: String { get }
}

extension CustomValidationError {
    var description: String { key }
    var reason: String { key }
    var status: HTTPResponseStatus { .unprocessableEntity }
    var headers: HTTPHeaders { .init() }
}
