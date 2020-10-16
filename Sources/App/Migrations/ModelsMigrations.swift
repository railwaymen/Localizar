import Vapor
import Fluent

struct ModelsMigrations {
    static var all: [Migration] {
        [
            Self.v1_0,
            Self.populating
        ].flatMap { $0 }
    }
    
    private static var v1_0: [Migration] { [
        ModelsMigration_v1_0_0(),
        ModelsMigration_v1_0_1(),
        ModelsMigration_v1_0_2(),
        ModelsMigration_v1_0_3(),
        ModelsMigration_v1_0_4(),
    ] }
    
    private static var populating: [Migration] { [
        ModelsMigration__populate_v1(),
    ] }
}
