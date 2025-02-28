//
//  DotLoader.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//


import SwiftUI

struct DotLoader: View {
    
    let particleCount = 8
    let radius = 20.0
    @State private var particles: [Particle] = []
    
    // MARK: - Body
    
    var body: some View {
        ZStack{
            ForEach(particles){ particle in
                Circle()
                    .frame(width: 10,height: 10)
                    .offset(x: radius * CGFloat(cos(particle.angle * .pi/180)),y:radius * CGFloat(sin(particle.angle * .pi/180)))
                    .foregroundStyle(Color.primaryBugit)
            }
        }
        .onAppear{
            particles = (0..<particleCount).map{ index in
                Particle(id: UUID(), angle: Double(index) * (360.0 / Double(particleCount)))
            }
            
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                particles = particles.map{ particle in
                    Particle(id: particle.id, angle: particle.angle - 600.0)
                }
            }
        }
    }
}



#Preview {
    DotLoader()
}
