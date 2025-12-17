import Vapor

public func configure(_ app: Application) throws {
    try App.configure(app)
}

@main
struct Run {
    static func main() throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        try configure(app)
        try app.run()
    }
}
