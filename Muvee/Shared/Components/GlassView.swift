import SwiftUI
import UIKit

struct GlassView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

extension View {
    func glassBackground(style: UIBlurEffect.Style = .systemUltraThinMaterial) -> some View {
        self.background(GlassView(style: style))
    }
}
