//
//  ContentView.swift
//  color circles
//
//  Created by Vito Borghi on 18/09/2023.
//

import SwiftUI
import CoreMotion


struct ContentView: View {
    enum motionTypes {
        case gyro, accelerometer
    }
    @State private var motionUpdateSamplingRate = 0.0001
    @State private var motionUsed = ""
    @State private var manager = CMMotionManager()
    @State private var motionX: Double?
    @State private var motionY: Double?
    @State private var motionZ: Double?
    
    func startMotion(with motionType: motionTypes){
        
        if motionType == .gyro {
            manager.stopAccelerometerUpdates()
            
            manager.startGyroUpdates(to: .main) { (data, error) in
                manager.gyroUpdateInterval = motionUpdateSamplingRate
                
                motionX = abs((manager.gyroData?.rotationRate.x)!)
                motionY = abs((manager.gyroData?.rotationRate.y)!)
                motionZ = abs((manager.gyroData?.rotationRate.z)!)
            }
        } else {
            manager.stopGyroUpdates()
            
            manager.startAccelerometerUpdates(to: .main) { (data, error) in
                manager.accelerometerUpdateInterval = motionUpdateSamplingRate

                motionX = abs((manager.accelerometerData?.acceleration.x)!)
                motionY = abs((manager.accelerometerData?.acceleration.y)!)
                motionZ = abs((manager.accelerometerData?.acceleration.z)!)
            }
        }
    }
        
        func canYouRunIt() {
            guard manager.isGyroAvailable else {
                fatalError("Gyroscope not available on this device.")
            }
            print("Gyro available")
            
            guard manager.isAccelerometerAvailable else {
                fatalError("Accelerometer not available on this device.")
            }
            print("Accelerometer available")
        }
        
        var body: some View {
            VStack{
                ZStack{
                    Circle()
                        .fill(Color(red: 1, green: 0, blue: 0))
                        .frame(width: 200 * (motionX ?? 0))
                        .offset(x: -50, y: -80)
                        .blendMode(.screen)
                    
                    Circle()
                        .fill(Color(red: 0, green: 1, blue: 0))
                        .frame(width: 200 * (motionY ?? 0))
                        .offset(x: 50, y: -80)
                        .blendMode(.screen)
                    
                    Circle()
                        .fill(Color(red: 0, green: 0, blue: 1))
                        .frame(width: 200 * (motionZ ?? 0))
                        .blendMode(.screen)
                }
                .frame(width: 300, height: 300)
                
                
                VStack{
                    Group{
                        Button("Gyroscope"){
                            motionUsed = "gyroscope"
                            startMotion(with: .gyro)
                        }
                        .padding()
                        
                        Button("Accelerometer"){
                            motionUsed = "accelerometer"
                            startMotion(with: .accelerometer)
                        }
                        .padding()
                        
                        Text("Currently using \(motionUsed)")
                            .foregroundStyle(.white)
                            .padding()
                        
                        Text("Step: \(motionUpdateSamplingRate)")
                            .foregroundStyle(.white)
                            .padding()
                        Slider(value: $motionUpdateSamplingRate, in: 0...1)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .ignoresSafeArea()
            .onAppear{
                canYouRunIt()
                
                manager.gyroUpdateInterval = motionUpdateSamplingRate
                manager.accelerometerUpdateInterval = motionUpdateSamplingRate
            }
    }
}
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
