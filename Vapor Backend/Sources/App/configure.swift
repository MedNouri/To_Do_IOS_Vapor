import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig()
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
    let databaseName: String
    let databasePort: Int
    
    if (env == .testing) {
        databaseName = "vapor-test"
        databasePort = 3307
    } else {
        databaseName = "vapor"
        databasePort = 3306
    }
    
    let mysqlConfig = MySQLDatabaseConfig(
        hostname: "localhost",
        port: databasePort,
        username: "vapor",
        password: "password",
        database: databaseName
    )
    
    let database = MySQLDatabase(config: mysqlConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)

    // Configure migrations
//    var migrations = MigrationConfig()
//
//    // admins
//
//   // migrations.add(migration: User.self, database: .mysql)  // changed
//
//    services.register(migrations)

    // Configure Command
       var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)
}
