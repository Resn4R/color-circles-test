//
//  ContentView.swift
//  color circles
//
//  Created by Vito Borghi on 18/09/2023.
//

import SwiftUI
import Foundation
import CoreMotion


struct ContentView: View {
    @State private var amount = 0.0
    @State private var manager = CMMotionManager()
    @State private var gyroX: Double?
    @State private var gyroY: Double?
    @State private var gyroZ: Double?
    
    func startGyro(){
        print(manager.isGyroAvailable)
        print(manager.isGyroActive)
        
        if manager.isGyroAvailable {
            manager.gyroUpdateInterval = 0.0001
            
            manager.startGyroUpdates(to: .main) { (data, error) in
                gyroX = abs((manager.gyroData?.rotationRate.x)!)
                gyroY = abs((manager.gyroData?.rotationRate.y)!)
                gyroZ = abs((manager.gyroData?.rotationRate.z)!)
            }
        } else {
            fatalError("Gyroscope not available on this device.")
        }
    }
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .fill(Color(red: 1, green: 0, blue: 0))
                    .frame(width: 200 * (gyroX ?? amount))
                    .offset(x: -50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 1, blue: 0))
                    .frame(width: 200 * (gyroY ?? amount))
                    .offset(x: 50, y: -80)
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color(red: 0, green: 0, blue: 1))
                    .frame(width: 200 * (gyroZ ?? amount))
                    .blendMode(.screen)
            }
            .frame(width: 300, height: 300)
            
            Slider(value: $amount)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
        
        .onAppear{
            startGyro()
        }
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
