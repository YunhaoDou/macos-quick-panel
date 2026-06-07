import Foundation
import CoreWLAN
import AppKit

/// Wi-Fi network scanning and connection management
final class WiFiManager: ObservableObject {
    static let shared = WiFiManager()
    private let client = CWWiFiClient.shared()

    @Published var networks: [CWNetwork] = []
    @Published var currentSSID: String = ""
    @Published var isScanning = false

    private init() {}

    var isOn: Bool {
        client.interface()?.powerOn() ?? false
    }

    func refreshCurrentSSID() {
        currentSSID = client.interface()?.ssid() ?? ""
    }

    func scan() {
        guard let interface = client.interface(), interface.powerOn() else {
            currentSSID = ""
            networks = []
            return
        }
        isScanning = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let results = try interface.scanForNetworks(withSSID: nil)
                DispatchQueue.main.async {
                    // Sort by signal strength, filter duplicates
                    let unique = Dictionary(grouping: results) { $0.ssid ?? "" }
                        .compactMap { _, group -> CWNetwork? in
                            group.max(by: { ($0.rssiValue) < ($1.rssiValue) })
                        }
                        .sorted { ($0.rssiValue) > ($1.rssiValue) }
                    self?.networks = unique
                    self?.currentSSID = self?.client.interface()?.ssid() ?? ""
                    self?.isScanning = false
                }
            } catch {
                DispatchQueue.main.async {
                    self?.isScanning = false
                }
            }
        }
    }

    func connect(to network: CWNetwork, password: String? = nil) {
        guard let interface = client.interface() else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try interface.associate(to: network, password: password)
                DispatchQueue.main.async {
                    self.currentSSID = network.ssid ?? ""
                }
            } catch {
                // If password needed but not provided, notify
                if (error as NSError).domain == "com.apple.coreWLAN" {
                    DispatchQueue.main.async {
                        // Could show password prompt here
                    }
                }
            }
        }
    }

    func disconnect() {
        client.interface()?.disassociate()
        currentSSID = ""
    }

    func toggleWiFi(_ on: Bool) {
        do {
            try client.interface()?.setPower(on)
        } catch {
            print("Failed to toggle WiFi: \(error)")
        }
    }
}
