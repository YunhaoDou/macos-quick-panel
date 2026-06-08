import SwiftUI

// MARK: - 毛玻璃背景 (Glassmorphism 风格)
// 源自 CSS glassmorphism 趋势: backdrop-blur + 半透明白色底色 + 微光边框

struct GlassBackground: ViewModifier {
    var tintColor: Color = .white
    var tintOpacity: Double = 0.06
    var borderOpacity: Double = 0.15
    var material: NSVisualEffectView.Material = .hudWindow

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 底层: NSVisualEffectView 原生磨砂
                    VisualEffectView(material: material, blendingMode: .behindWindow)

                    // 中层: 半透明白色底色 (glassmorphism 特征)
                    tintColor.opacity(tintOpacity)

                    // 表层微光 (左上到右下渐变)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.04),
                            .clear,
                            .clear,
                            .white.opacity(0.02)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .overlay(
                // 边框: 半透明白色描边
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.white.opacity(borderOpacity), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - 深色版本毛玻璃 (用于主面板)
struct DarkGlassBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    VisualEffectView(material: .dark, blendingMode: .behindWindow)
                    Color.black.opacity(0.15)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.05),
                            .clear,
                            .clear,
                            .purple.opacity(0.03)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white.opacity(0.08), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - 面板内部区域毛玻璃 (分栏卡片)
struct CardBackground: ViewModifier {
    var color: Color = .white
    var opacity: Double = 0.04

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(opacity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.white.opacity(0.06), lineWidth: 0.5)
            )
    }
}

// MARK: - AppKit NSVisualEffectView bridge
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.isEmphasized = true
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - 快速扩展
extension View {
    func glassBackground(tint: Color = .white, opacity: Double = 0.06, border: Double = 0.15) -> some View {
        modifier(GlassBackground(tintColor: tint, tintOpacity: opacity, borderOpacity: border))
    }

    func darkGlassBackground() -> some View {
        modifier(DarkGlassBackground())
    }

    func cardBackground(color: Color = .white, opacity: Double = 0.04) -> some View {
        modifier(CardBackground(color: color, opacity: opacity))
    }
}
