import SwiftUI
import CoreWLAN

struct WiFiListView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            if state.wifiManager.isScanning {
                HStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("扫描中…")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.vertical, 8)
            } else if state.wifiManager.networks.isEmpty {
                HStack {
                    Spacer()
                    Text("未发现 Wi-Fi 网络")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.vertical, 8)
            } else {
                Button(action: { state.scanWiFi() }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 9))
                        Text("重新扫描")
                            .font(.caption)
                        Spacer()
                        Text("\(state.wifiManager.networks.count) 个网络")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)

                Divider().opacity(0.2)

                ForEach(state.wifiManager.networks.prefix(15), id: \.ssid) { network in
                    WiFiNetworkRow(network: network, isCurrent: network.ssid == state.wifiManager.currentSSID)
                        .onTapGesture {
                            if network.ssid != state.wifiManager.currentSSID {
                                state.connectWiFi(ssid: network.ssid ?? "")
                            }
                        }
                }
            }
        }
    }
}

struct WiFiNetworkRow: View {
    let network: CWNetwork
    let isCurrent: Bool

    private var signalBars: Int {
        let rssi = network.rssiValue
        switch rssi {
        case ..<(-80): return 1
        case ..<(-70): return 2
        case ..<(-55): return 3
        default: return 4
        }
    }

    private var lockIcon: String {
        network.supportsSecurity(CWSecurity.wpa2Personal) || network.supportsSecurity(CWSecurity.wpa3Personal) || network.supportsSecurity(CWSecurity.wpa2Enterprise) ? "lock.fill" : "lock.open"
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi")
                .font(.system(size: 10))
                .foregroundColor(isCurrent ? .blue : .secondary)

            VStack(alignment: .leading, spacing: 1) {
                Text(network.ssid ?? "未知")
                    .font(.system(size: 11, weight: isCurrent ? .semibold : .regular))
                HStack(spacing: 4) {
                    ForEach(0..<4) { i in
                        Rectangle()
                            .fill(i < signalBars ? Color.secondary : Color.secondary.opacity(0.15))
                            .frame(width: 3, height: CGFloat(4 + i * 2))
                            .cornerRadius(1)
                    }
                }
            }

            Spacer()

            if isCurrent {
                Text("已连接")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }

            Image(systemName: lockIcon)
                .font(.system(size: 8))
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 5)
        .contentShape(Rectangle())
        .background(isCurrent ? Color.blue.opacity(0.04) : Color.clear)
    }
}
