//
//  ContentView.swift
//  BetterRest
//
//  Created by Amr El-Fiqi on 22/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Variables
    @State var wakeUpTime = Date.now
    @State var sleepTime = 8.0
    @State var coffeAmount = 1

    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep?")
                    .font(.headline)
                Stepper("\(sleepTime.formatted())", value: $sleepTime,in: 2...12, step: 0.25)
                
                Text("Daily Coffe Intake?")
                    .font(.headline)
                Stepper("\(coffeAmount.formatted())", value: $coffeAmount,in: 1...12)
                
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime() {
        
    }
}

#Preview {
    ContentView()
}
