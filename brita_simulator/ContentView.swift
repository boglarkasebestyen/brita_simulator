//
//  CircleWaveView.swift
//  brita_simulator
//
//  Created by Sebestyén Boglárka on 3/05/21.
//
import SwiftUI

import AVFoundation

var audioPlayer: AVAudioPlayer?

struct ContentView: View {
    
    @State var audioPlayer: AVAudioPlayer!
    @State private var waterLevel = 100 //water left
    @State private var tankLevel = 0
    @State private var alertShowing = false
    @State private var  randomNum = Int.random(in: 1...30)
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var timeElapsed = 0
    let blueColor = Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5)
    @State private var waterColor = Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5)

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath:path))
                audioPlayer?.play()
            } catch {
                print("Can't play sound")
            }
        }
    }

    func increaseTank() {
        tankLevel = tankLevel + 10
    }
    
    func decreaseWater() {
        waterLevel = waterLevel - 10
    }
    
    func increaseWater() {
        waterLevel = waterLevel + 10
    }
    
    func playWater() {
        playSound(sound: "drip", type: "mp3")
    }
    
    func playTank() {
        playSound(sound: "fill", type: "mp3")
    }
    
    func playFilter() {
        playSound(sound: "running_water", type: "wav")
    }
    

    
    struct ButtonMod: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(10)
                .frame(maxWidth: 150)
                .cornerRadius(20)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
                .opacity(0.6)
        }
    }

    struct TextMod: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(Color.white)
                .opacity(0.8)
        }
    }
  
    var body: some View {
        GeometryReader { geometry in
                    ZStack {
                        Spacer()
                        Image("background")
                            .resizable()
                            .aspectRatio(geometry.size, contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()


                    VStack { //main container
                        Text("Brita Simulator")
                            .font(.system(size: 42, weight: .bold, design: .default))
                            .padding()
                            .foregroundColor(Color.blue)
                            .opacity(0.4)
                       
                        //import CircleWaveView
                        CircleWaveView(percent: waterLevel, color: waterColor)

                        Spacer()
                    
                    //WATER % INDICATOR
                    VStack {
                        Spacer()
                            .frame(maxWidth: 40, maxHeight: 50)
                        Text(String(waterLevel) + "%")
                            .font(.system(size: 37, weight: .bold, design: .default))
                            .modifier(TextMod())
                        Text("water left")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 17, weight: .bold, design: .default))
                            .opacity(0.6)
                            .modifier(TextMod())
                    }
                    
                    Spacer()
                        
                    //BUTTONS
                    HStack {
                        Spacer()
                        //POUR WATER BUTTON & WATER %
                        VStack{
                            Button(action: {
                                if (waterLevel >= 1) {
                                    decreaseWater()
                                    playWater()
                                }
                            }, label: {
                                Text("Pour water")
                                    .modifier(ButtonMod())
                            })
                            Text(String(waterLevel) + "%")
                                .modifier(TextMod())
                                
                                //ALERT
                                .onReceive(timer) { _ in
                                    timeElapsed += 2
                                    //print(timeElapsed, randomNum)
                                    
                                    if timeElapsed > randomNum {
                                        alertShowing = true;
                                        waterColor = Color(red: 0.73, green: 0.64, blue: 0.62, opacity: 0.5)
                                        randomNum += Int.random(in: 1...30)
                                    } else {
                                        alertShowing = false
                                    }
                                }.alert(isPresented:$alertShowing, content: {
        //                            self.timer.upstream.connect().cancel()
                                    return Alert(title: Text("Your water has gone bad!"), message: Text("Change your filter!"), dismissButton: nil)
                                })
                        }
                        Spacer()
                            .frame(maxWidth: 40, maxHeight: 450)
                    
                        
                        //FILL TANK BUTTON AND WATER %
                        VStack{
                            Button(action: {

                                if (tankLevel <= 90) {
                                    increaseTank()
                                    playTank()
                                }
                                
                                if (tankLevel == 100) {
                                    tankLevel = 0
                                }
                                
                                if (waterLevel <= 90) {
                                    increaseWater()
                                    playTank()
                                }
                                
                                if (waterLevel == 100) {
                                    tankLevel = 0
                                }
                            }, label: {
                                Text("Fill tank")
                                    .modifier(ButtonMod())
                            })
                            Text(String(tankLevel) + "%")
                                .modifier(TextMod())
                        }
                        Spacer()
                        
                    }
                        Spacer()
                        
                        //CHANGE FILTER BUTTON
                        HStack {
                            Button(action: {
                                    waterLevel = 0
                                    tankLevel = 0
                                    playFilter()
                                    waterColor = blueColor
                                }, label: {
                                    Text("Change filter")
                                        .modifier(ButtonMod())
                                })
                        }
                        .padding(.bottom, 100)
                        Spacer()
                        Spacer()
                    }
                }
            }
        }

struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                Group {
                    ContentView()
                    ContentView()
                    ContentView()
                }
        }
    }
}
