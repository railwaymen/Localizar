import Vapor
import Fluent

protocol Form {
    associatedtype Model: Fluent.Model
    associatedtype ValidationError: CustomValidationError
    
    init()
    init(req: Request) throws
    
    func createModel() throws -> Model
    func validate(on database: Database) -> EventLoopFuture<ValidationError?>
}
