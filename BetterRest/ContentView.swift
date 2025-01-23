//
//  ContentView.swift
//  BetterRest
//
//  Created by Amr El-Fiqi on 22/01/2025.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    // MARK: - Variables
    @State var wakeUpTime = defaultWakeUpTime
    @State var sleepAmount = 8.0
    @State var coffeAmount = 1

    // Alert Vars
    @State private var alertIsPresented = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Computed Property
    static var defaultWakeUpTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep?")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted())", value: $sleepAmount,in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily Coffe Intake?")
                        .font(.headline)
                    Stepper("^[\(coffeAmount) cup](inflect: true)", value: $coffeAmount,in: 1...20)
                }
                
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
            // Show the results
            .alert("Results", isPresented: $alertIsPresented) {
                Button("Ok") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // Get the time in seconds
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // Feed the results into CoreML
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            let sleepTime = wakeUpTime - prediction.actualSleep
            
            // Sleep time alert setup
            alertTitle = "Your sleep time is:"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            alertIsPresented = true
            
        } catch {
            alertTitle = "Error"
            alertMessage = "There was an error calculating your sleep time. Please try again later."
            alertIsPresented = true
        }
    }
}

#Preview {
    ContentView()
}
