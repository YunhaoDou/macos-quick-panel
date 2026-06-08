import Foundation
import AppKit

/// DeepSeek API balance and usage tracker
final class DeepSeekManager: ObservableObject {
    static let shared = DeepSeekManager()

    @Published var balance: String = "--"
    @Published var currency: String = "CNY"
    @Published var isAvailable: Bool = false
    @Published var grantedBalance: String = "--"
    @Published var toppedUpBalance: String = "--"
    @Published var isLoading = false
    @Published var errorMessage: String = ""
    @Published var apiKey: String {
        didSet { saveKey() }
    }

    private let baseURL = "https://api.deepseek.com"
    private let keychainService = "com.quickpanel.deepseek"

    private init() {
        self.apiKey = DeepSeekManager.loadKey()
        if !apiKey.isEmpty {
            refresh()
        }
    }

    /// Load API key from UserDefaults (initially populated from ~/.hermes/.env)
    private static func loadKey() -> String {
        if let saved = UserDefaults.standard.string(forKey: "deepseek_api_key"), !saved.isEmpty {
            return saved
        }
        // Try to read from ~/.hermes/.env
        let envPath = "\(NSHomeDirectory())/.hermes/.env"
        if let content = try? String(contentsOfFile: envPath, encoding: .utf8) {
            for line in content.components(separatedBy: .newlines) {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.hasPrefix("DEEPSEEK_API_KEY=") {
                    var key = String(trimmed.dropFirst("DEEPSEEK_API_KEY=".count))
                    // Remove optional quotes
                    if key.hasPrefix("\"") && key.hasSuffix("\"") {
                        key = String(key.dropFirst().dropLast())
                    }
                    if !key.isEmpty {
                        UserDefaults.standard.set(key, forKey: "deepseek_api_key")
                        return key
                    }
                }
            }
        }
        return ""
    }

    private func saveKey() {
        UserDefaults.standard.set(apiKey, forKey: "deepseek_api_key")
    }

    /// Refresh balance from DeepSeek API
    func refresh() {
        guard !apiKey.isEmpty else {
            errorMessage = "API Key 未设置"
            return
        }

        isLoading = true
        errorMessage = ""

        guard let url = URL(string: "\(baseURL)/user/balance") else {
            isLoading = false
            errorMessage = "URL 无效"
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 8

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "网络错误: \(error.localizedDescription)"
                    return
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.errorMessage = "解析失败"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    self.errorMessage = "API Key 无效"
                    return
                }

                self.isAvailable = json["is_available"] as? Bool ?? false

                if let infos = json["balance_infos"] as? [[String: Any]], let info = infos.first {
                    self.balance = info["total_balance"] as? String ?? "--"
                    self.currency = info["currency"] as? String ?? "CNY"
                    self.grantedBalance = info["granted_balance"] as? String ?? "--"
                    self.toppedUpBalance = info["topped_up_balance"] as? String ?? "--"
                }
            }
        }.resume()
    }

    var formattedBalance: String {
        if isLoading { return "查询中…" }
        if !errorMessage.isEmpty { return errorMessage }
        return "\(balance) \(currency)"
    }
}
