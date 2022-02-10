//
//  ContentView.swift
//  Particles
//
//  Created by Paul Hudson on 07/06/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

struct EmitterView: View {
    private struct ParticleView: View {
        @State private var isActive = false
        
        let position: ParticleState<CGPoint>
        let opacity: ParticleState<Double>
        let scale: ParticleState<CGFloat>
        
        var body: some View {
            Image("spark")
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
            
                .position(isActive ? position.end : position.start)
                .onAppear {
                    isActive.toggle()
                }
        }
    }
    
    private struct ParticleState<T> {
        var start: T
        var end: T
        
        init(_ start: T, _ end: T) {
            self.start = start
            self.end = end
        }
    }
    
    var particleCount: Int
    
    var creationPoint = UnitPoint.center
    var creationRange = CGSize.zero
    
    var angle = Angle.zero
    var angleRange = Angle.zero
    
    var opacity = 1.0
    var opacityRange = 0.0
    var opacitySpeed = 0.0
    
    var rotation = Angle.zero
    var rotationRange = Angle.zero
    var rotationSpeed = Angle.zero
    
    var scale: CGFloat = 1
    var scaleRange: CGFloat = 0
    var scaleSpeed: CGFloat = 0
    
    var speed = 50.0
    var speedRange = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<particleCount, id: \.self) { i in
                    ParticleView(position: position(in: geo), opacity: makeOpacity(), scale: makeScale())
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false))
                }
            }
        }
    }
    
    private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
        let halfCreationRangeWidth = creationRange.width / 2
        let halfCreationRangeHeight = creationRange.height / 2
        
        let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeHeight)
        let creationOffsetY = CGFloat.random(in: -halfCreationRangeHeight...halfCreationRangeWidth)

        let startX = Double(proxy.size.width * (creationPoint.x + creationOffsetX))
        let startY = Double(proxy.size.height * (creationPoint.y + creationOffsetY))
        let start = CGPoint(x: startX, y: startY)
        
        let halfSpeedRange = speedRange / 2
        let actualSpeed = speed + Double.random(in: -halfSpeedRange...halfSpeedRange)
        
        
        let halfAngleRange = angleRange.radians / 2
        let actualdirection = angle.radians + Double.random(in: -halfAngleRange...halfAngleRange)
        
        let finalX = cos(actualdirection - .pi / 2) * actualSpeed
        let finalY = sin(actualdirection - .pi / 2) * actualSpeed
        let end = CGPoint(x: startX + finalX, y: startY + finalY)
        
        return ParticleState(start, end)
    }
    
    private func makeOpacity() -> ParticleState<Double> {
        let halfOpacityRange = opacityRange / 2
        let randomOpacity = Double.random(in: -halfOpacityRange...halfOpacityRange)
        return ParticleState(opacity + randomOpacity, opacity + opacitySpeed + randomOpacity)
    }
    
    private func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            EmitterView(particleCount: 200, angleRange: .degrees(360), opacitySpeed: -1, scale: 0.4, scaleRange: 0.1, scaleSpeed: 0.4 ,speedRange: 80)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
