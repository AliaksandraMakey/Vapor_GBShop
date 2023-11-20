import Fluent
import FluentPostgresDriver
import Vapor
import JWT
import Mailgun
import QueuesRedisDriver

public func configure(_ app: Application) throws {
    // MARK: JWT
    app.directory.workingDirectory = "/Users/aleksandramakei/Projects/vapor_GBShop/"
    if app.environment != .testing {
        let jwksFilePath = app.directory.workingDirectory + (Environment.get("JWKS_KEYPAIR_FILE") ?? "keypair.jwks")
        if !FileManager.default.fileExists(atPath: jwksFilePath) {
            fatalError("Файл не существует по указанному пути: \(jwksFilePath)")
        } 
         guard
             let jwks = FileManager.default.contents(atPath: jwksFilePath),
             let jwksString = String(data: jwks, encoding: .utf8)
             else {
                 fatalError("Failed to load JWKS Keypair file at: \(jwksFilePath)")
         }
        do {
            try app.jwt.signers.use(jwksJSON: jwksString)
        } catch {
            print("Произошла ошибка при загрузке и использовании JWK: \(error)")
        }
    }
    
//    app.http.server.configuration.port = 8080 // Настройте порт на ваш выбор
//    app.http.server.configuration.hostname = "0.0.0.0" // Настройте хост на ваш выбор
    
    // MARK: Database
    // Configure PostgreSQL database
    app.databases.use(
        .postgres(
            hostname: Environment.get("POSTGRES_HOSTNAME") ?? "localhost",
            username: Environment.get("POSTGRES_USERNAME") ?? "vapor",
            password: Environment.get("POSTGRES_PASSWORD") ?? "password",
            database: Environment.get("POSTGRES_DATABASE") ?? "vapor"
        ), as: .psql)
        
    // MARK: Middleware
    app.middleware = .init()
    app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    
    // MARK: Model Middleware
    
    // MARK: Mailgun
    app.mailgun.use(.fake)
//    app.mailgun.configuration = .environment
//    app.mailgun.defaultDomain = .sandbox
//    app.mailgun
    
    // MARK: App Config
    app.config = .environment
    
    try routes(app)
    try migrations(app)
    try queues(app)
    try services(app)
    
    
    if app.environment == .development {
        try app.autoMigrate().wait()
        try app.queues.startInProcessJobs()
    }
}
