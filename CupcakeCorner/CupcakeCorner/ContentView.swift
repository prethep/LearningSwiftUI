//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by PP on 18.06.19.
//  Copyright © 2019 PP. All rights reserved.
//

import Combine
import SwiftUI

class Order: BindableObject, Codable {
    // We don't need to encode/decode the PassthroughSubject
    enum CodingKeys: String, CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    var didChange = PassthroughSubject<Void, Never>()
    
    static let types = ["Vanilla", "Chocolate", "Strawberry",
                        "Rainbow"]
    
    var type = 0 { didSet { update() } }
    var quantity = 3 { didSet{ update() } }
    
    var specialRequestEnabled = false { didSet{ update() } }
    var extraFrosting = false { didSet{ update() } }
    var addSprinkles = false { didSet{ update() } }
    
    var name = "" { didSet{ update() } }
    var streetAddress = "" { didSet{ update() } }
    var city = "" { didSet{ update() } }
    var zip = "" { didSet{ update() } }
    
    var isValid: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    func update() {
        didChange.send(())
    }
}

struct ContentView : View {
    @ObjectBinding var order = Order()
    
    @State var confirmationMessage = ""
    @State var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $order.type, label: Text("Select your cake type")) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0]).tag($0)
                        }
                    }
                    
                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.specialRequestEnabled) {
                        Text("Any special requests?")
                    }
                    if order.specialRequestEnabled {
                        Toggle(isOn: $order.addSprinkles) {
                            Text("Add sprinkles")
                        }
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                    }
                }
                
                Section {
                    TextField($order.name, placeholder: Text("Name"))
                    TextField($order.streetAddress, placeholder: Text("Street Address"))
                    TextField($order.city, placeholder: Text("City"))
                    TextField($order.zip, placeholder: Text("Zip"))
                }
                
                Section {
                    Button(action: {
                        self.placeOrder()
                    }) {
                        Text("Place order")
                    }
                }.disabled(!order.isValid)
                

            }
            
        }
            .navigationBarTitle(Text("Cupcake Corner"))
            .presentation($showingConfirmation) {
                Alert(title: Text("Thank you"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
        
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {
            guard let data = $0 else {
                print("No data in response: \($2?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decodedOrder = try?
                JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcake is on its way!"
                self.showingConfirmation = true
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Invalid response: \(dataString)")
            }
        }.resume()
        
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
