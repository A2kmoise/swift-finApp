import Vapor

struct AIChatRequest: Content {
    let userMessage: String
}

struct AIChatResponse: Content {
    let reply: String
}
