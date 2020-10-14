import Vapor
import Fluent

struct ModelsMigrations {
    static var all: [Migration] { [
        ModelsMigration_v1_0_0(),
        ModelsMigration_v1_0_1(),
        ModelsMigration_v1_0_2(),
    ] }
}
