import Foundation

@available(macOS 10.15.0, *)
class ApiClient {
    let baseUrl: String
    var token: String?

    init(baseUrl: String = "https://demo.hamhoushdk.ir", token: String? = nil) {
        self.baseUrl = baseUrl
        self.token = token
    }

    func login(username: String, password: String) async throws -> String {
        let loginUrl = "\(baseUrl)/api/api/auth/login"
        let data = "username=\(username)&password=\(password)"
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        var request = URLRequest(url: URL(string: loginUrl)!)
        request.httpMethod = "POST"
        request.httpBody = data.data(using: .utf8)
        request.allHTTPHeaderFields = headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            }
            print(type(of:httpResponse.statusCode),httpResponse.statusCode)
            guard (httpResponse.statusCode == 200) else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
            }
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let dataDict = json["data"] as? [String: Any],
                let accessToken = dataDict["access_token"] as? String {
                self.token = accessToken
                return accessToken
            } else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "نام کاربری یا رمز عبور اشتباه است"])
            }
        } catch {
            throw error
        }
    }

    func chat(botId: String, message: String) async throws -> [String: Any] {
        guard let token = token else {
            throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "لطفا ابتدا لاگین کنید"])
        }

        let chatUrl = "\(baseUrl)/chat/api/bot/\(botId)/chat"
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        let data = ["data": message]

        var request = URLRequest(url: URL(string: chatUrl)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)

        request.allHTTPHeaderFields = headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "خطایی رخ داده است"])
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            } else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "خطایی رخ داده است"])
            }
        } catch {
            throw error
        }
    }

    func bots() async throws -> [String: Any] {
        guard let token = token else {
            throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "لطفا ابتدا لاگین کنید"])
        }

        let botsUrl = "\(baseUrl)/api/api/account/bot"
        let headers = [
            "Authorization": "Bearer \(token)"
        ]

        var request = URLRequest(url: URL(string: botsUrl)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "خطایی رخ داده است"])
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            } else {
                throw NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "خطایی رخ داده است"])
            }
        } catch {
            throw error
        }
    }
}
