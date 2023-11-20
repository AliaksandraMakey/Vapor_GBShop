
import Mailgun
import Vapor

struct MockMailgun: MailgunProvider {
    var eventLoop: EventLoop
    
    func send(_ content: MailgunMessage) -> EventLoopFuture<ClientResponse> {
        print(content)
        return eventLoop.makeSucceededFuture(ClientResponse(status: .ok))
    }
    
    func send(_ content: MailgunTemplateMessage) -> EventLoopFuture<ClientResponse> {
        print(content)
        return eventLoop.makeSucceededFuture(ClientResponse(status: .ok))
    }
    
    func setup(forwarding: MailgunRouteSetup) -> EventLoopFuture<ClientResponse> {
        fatalError()
    }
    
    func createTemplate(_ template: MailgunTemplate) -> EventLoopFuture<ClientResponse> {
        fatalError()
    }
    
    func delegating(to eventLoop: EventLoop) -> MailgunProvider {
        var copy = self
        copy.eventLoop = eventLoop
        return copy
    }
}

extension Application.Mailgun.Provider {
    static var fake: Self {
        .init {
            $0.mailgun.use { app, _ in
                MockMailgun(eventLoop: app.eventLoopGroup.next())
            }
        }
    }
}
