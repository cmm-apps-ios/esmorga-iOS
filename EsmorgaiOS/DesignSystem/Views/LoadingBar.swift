//
//  ProgressBar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 4/7/24.
//

import SwiftUI

struct LoadingBar: View {
    @State private var progress: Double = 0.0
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: height)
                    .foregroundColor(.surfaceVariant)
                    .cornerRadius(height / 2)
                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(progress), height: height)
                    .foregroundColor(.claret)
                    .cornerRadius(height / 2)
                    .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: progress)
            }
        }
        .frame(height: height)
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        withAnimation {
            progress = 1.0
        }
    }
}

#Preview {
    LoadingBar().padding()
}
