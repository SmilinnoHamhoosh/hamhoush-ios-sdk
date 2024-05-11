import XCTest
@testable import HamhoushSdk // Replace YourModuleName with the actual module name where ApiClient resides

@available(macOS 10.15.0, *)
class ApiClientTests: XCTestCase {
    var apiClient: ApiClient!

    override func setUp() {
        super.setUp()
        apiClient = ApiClient()
    }

    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }

    func testLogin() {
        let expectation = XCTestExpectation(description: "Login expectation")
        
        // Replace username and password with valid ones for your testing
        Task {
            do {
                let accessToken = try await apiClient.login(username: "parham@gmail.com", password: "Hamhoush@123")
                XCTAssertNotNil(accessToken, "Access token should not be nil after successful login")
                expectation.fulfill()
            } catch {
                XCTFail("Login failed with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0) // Adjust timeout as needed
    }

    func testChat() {
        let expectation = XCTestExpectation(description: "Chat expectation")

        // Replace botId and message with valid ones for your testing
        let botId = "yourBotId"
        let message = "Test message"

        // Make sure to login before attempting to chat
        Task {
            do {
                let accessToken = try await apiClient.login(username: "parham@gmail.com", password: "Hamhoush@123")
                let response = try await apiClient.chat(botId: botId, message: message)
                XCTAssertNotNil(response, "Response should not be nil after chatting")
                expectation.fulfill()
            } catch {
                XCTFail("Chat failed with error: \(error.localizedDescription)")
            }
        }

        wait(for: [expectation], timeout: 10.0) // Adjust timeout as needed
    }

    func testBots() {
        let expectation = XCTestExpectation(description: "Bots expectation")

        // Make sure to login before attempting to get bots
        Task {
            do {
                let accessToken = try await apiClient.login(username: "parham@gmail.com", password: "Hamhoush@123")
                let response = try await apiClient.bots()
                XCTAssertNotNil(response, "Response should not be nil after getting bots")
                expectation.fulfill()
            } catch {
                XCTFail("Fetching bots failed with error: \(error.localizedDescription)")
            }
        }

        wait(for: [expectation], timeout: 10.0) // Adjust timeout as needed
    }
}
