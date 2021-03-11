//
//  CircleWaveView.swift
//  delete_this
//
//  Created by Sebestyén Boglárka on 3/10/21.
//

import SwiftUI

struct CircleWaveContentView: View {
    
    @State private var percent = 50.0
    
    var body: some View {
        VStack {
            CircleWaveView(percent: Int(self.percent))
            Slider(value: self.$percent, in: 0...100)
        }
        .padding(.all)
    }
}

struct Wave: Shape {

    var offset: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()

        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98
        
        if (percent == 0) {
            return p
        }
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.015 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct CircleWaveView: View {
    
    @State private var waveOffset = Angle(degrees: 0)
    let percent: Int
    
    var body: some View {

        GeometryReader { geo in
            ZStack {
                Image("water_filter")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200.0, height: 200.0)
                    .overlay(
                        VStack {
                            Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(percent)/100)
                                .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                                .frame(width: 105, height: 100)
                                .clipShape(Rectangle().scale(1.0))
                            Spacer().frame(width: 105, height: 20, alignment: .bottom)
                            
                            
                        }, alignment: .bottom)
                }
            }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct CircleWaveContentView_Previews: PreviewProvider {
    static var previews: some View {
        CircleWaveView(percent: 58)
    }
}
