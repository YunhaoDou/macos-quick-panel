import Foundation
import AppKit
import CoreAudio

/// Represents an audio output device
struct AudioDevice: Identifiable {
    let id: String
    let name: String
}

/// Manages audio output device switching using CoreAudio
final class AudioManager {
    static let shared = AudioManager()

    func listDevices() -> [AudioDevice] {
        // First try SwitchAudioSource if available
        if let output = try? shell("which SwitchAudioSource"), !output.isEmpty {
            return listDevicesViaSwitchAudio()
        }
        // Fallback: enumerate via CoreAudio
        return listDevicesViaCoreAudio()
    }

    func currentDeviceName() -> String {
        // Try SwitchAudioSource first
        if let output = try? shell("SwitchAudioSource -c -t output"), !output.isEmpty {
            return output.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        // Fallback via CoreAudio
        return currentDeviceViaCoreAudio()
    }

    func switchToDevice(named name: String) {
        // Try SwitchAudioSource first
        if (try? shell("which SwitchAudioSource")) != nil {
            try? shell("SwitchAudioSource -s '\(name)' -t output")
        }
    }

    // MARK: - SwitchAudioSource Path

    private func listDevicesViaSwitchAudio() -> [AudioDevice] {
        guard let output = try? shell("SwitchAudioSource -a -t output") else { return [] }
        return output
            .split(separator: "\n")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { AudioDevice(id: $0, name: $0) }
    }

    // MARK: - CoreAudio Path (Fallback)

    private func listDevicesViaCoreAudio() -> [AudioDevice] {
        var deviceCount: UInt32 = 0
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        AudioObjectGetPropertyDataSize(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0, nil,
            &deviceCount
        )

        let deviceCountInt = Int(deviceCount) / MemoryLayout<AudioDeviceID>.size
        var audioDevices = [AudioDeviceID](repeating: 0, count: deviceCountInt)
        var dataSize = UInt32(MemoryLayout<AudioDeviceID>.size * deviceCountInt)

        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0, nil,
            &dataSize, &audioDevices
        )

        var devices: [AudioDevice] = []
        for deviceID in audioDevices {
            if let name = deviceName(deviceID), isOutputDevice(deviceID) {
                devices.append(AudioDevice(id: "\(deviceID)", name: name))
            }
        }
        return devices
    }

    private func deviceName(_ id: AudioDeviceID) -> String? {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceNameCFString,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var name: CFString?
        var dataSize = UInt32(MemoryLayout<CFString?>.size)
        AudioObjectGetPropertyData(id, &propertyAddress, 0, nil, &dataSize, &name)
        return name as String?
    }

    private func isOutputDevice(_ id: AudioDeviceID) -> Bool {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreams,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        var dataSize: UInt32 = 0
        AudioObjectGetPropertyDataSize(id, &propertyAddress, 0, nil, &dataSize)
        return dataSize > 0
    }

    private func currentDeviceViaCoreAudio() -> String {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var deviceID = AudioDeviceID()
        var dataSize = UInt32(MemoryLayout<AudioDeviceID>.size)
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress, 0, nil,
            &dataSize, &deviceID
        )
        return deviceName(deviceID) ?? "Unknown"
    }
}
