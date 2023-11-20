import Vapor
import Queues

func queues(_ app: Application) throws {
    // MARK: Queues Configuration
    if app.environment != .testing {
        try app.queues.use(
            .redis(url:
                Environment.get("REDIS_URL") ?? "redis://0.0.0.0:6379"
            )
        )
    }
    
    // MARK: Jobs
    app.queues.add(EmailJob())
}
