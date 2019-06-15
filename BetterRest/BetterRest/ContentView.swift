//
//  ContentView.swift
//  BetterRest
//
//  Created by PP on 15.06.19.
//  Copyright © 2019 PP. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount: Double = 8
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                    .lineLimit(nil)
                
                DatePicker($wakeUp, displayedComponents: .hourAndMinute)
                
                Text("Desired amount of sleep")
                    .font(.headline)
                    .lineLimit(nil)
                
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }.padding(.bottom)
                
                Text("Daily coffee intake")
                    .font(.headline)
                    .lineLimit(nil)
                
                Stepper(value: $coffeeAmount, in: 1...20, step: 1) {
                    if coffeeAmount == 1 {
                        Text("1 cup")
                    } else {
                        Text("\(coffeeAmount) cups")
                    }
                }
                
                Spacer()
                
            }
                .navigationBarTitle(Text("Better Rest"))
                .navigationBarItems(trailing:
                    Button(action: calculateBedtime) {
                        Text("Calculate")
                    }
                )
                .padding()
                .presentation($showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            
            
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        do {
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(coffee: Double(coffeeAmount), estimatedSleep: Double(sleepAmount), wake: Double(hour + minute))
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
        
    }
    
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
