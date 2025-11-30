//
//  ContentView.swift
//  MetalTriangle
//
//  Created by Vova Smyshlyaev on 20.11.2025.
//

import SwiftUI
import MetalKit

struct ContentView: View {
    @Binding var currentStage: DemoStage
    @Namespace private var namespace

    var body: some View {
        ZStack(alignment: .topTrailing) {
            demoView()

            GlassEffectContainer {
                VStack {
                    Spacer()

                    HStack {
                        ForEach(DemoStage.allCases) { stage in
                            Button(action: {
                                currentStage = stage
                            }) {
                                VStack {
                                    Image(systemName: iconName(for: stage))
                                        .font(.headline)
                                        .padding(.bottom, 2)
                                    Text(stage.rawValue)
                                        .font(.caption)
                                }
                                .padding(6)
                            }
                            .buttonStyle(.glass)
                            .glassEffectUnion(id: stage, namespace: namespace)
                            .cornerRadius(50)
                        }
                    }
                    .glassEffect()
                    .frame(maxWidth: 400)
                    .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
            }

        }
        .edgesIgnoringSafeArea(.all)
    }

    private func iconName(for stage: DemoStage) -> String {
        switch stage {
        case .staticTriangle:
            return "triangle"
        case .dynamicTriangle:
            return "arrow.2.circlepath.circle"
        }
    }

    @ViewBuilder
    func demoView() -> some View {
        switch currentStage {
        case .staticTriangle:
            MetalView()
        case .dynamicTriangle:
            MetalView(isDynamic: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var previewStage: DemoStage = .staticTriangle

    static var previews: some View {
        ContentView(currentStage: $previewStage)
    }
}
