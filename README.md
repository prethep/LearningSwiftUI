![alt text](https://i.ibb.co/0jCsnrY/banner.png)

## Project 1: ListedPhotosViewer
- [x] Explore the Combine Framework:
```Swift
  class DataSource: BindableObject {
    // PassthroughSubject< send nothing and never throw errors >
    var didChange = PassthroughSubject<Void, Never>()
    var photos = [String]()
    
    init() {
      ...
      didChange.send(())
    }
  }
```
- [x] Learn about the <b>BindableObject</b> protocol
- [x] Notify about changes using <b>didChange.send(())</b>
- [x] Understand the difference between <b>@State</b> and <b>@ObjectBinding</b>
- [x] Use someArray<b>.identified(by: \.self)</b> instead of conforming to the <b>Identifiable</b> protocol


## Project 2: FlagGuessing
- [x] Declare all <b>@State</b> variables as <b>private</b> when possible (recommended by Apple)
- [x] Let alerts appear based on a boolean @State variable (<b>declarative</b> way):
```Swift
.presentation($showingAlert) { 
  // Present alert
  
  // SwiftUI will automatically toggle 'showingAlert' variable.
}
```
- [x] Creation of an <b>Alert</b> and attaching a <b>custom action</b> to the dismiss button: 
```Swift
Alert(title: Text(alertTitle), message: Text(score), dismissButton: .default(Text("Continue")) {
  self.nextQuestion()
}) 
```


## Project 3: iBeaconDetector
- [x] How to let a BindableObject conform to a delegate
```Swift
class BeaconDetector: NSObject, BindableObject, CLLocationManagerDelegate {
    var didChange = PassthroughSubject<Void, Never>()
    ...
    override init() { // overrides NSObject init
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    ...
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], 
                            satisfying beaconConstraint: CLBeaconIdentityConstraint) {
       ...
    }
    ...
}
```
- [x] Modifier Sequence matters (everytime a modifier is added, a new view is created.)
- [x] To ignore all safe area:
```Swift
  .edgesIgnoringSafeArea(.all)
```
- [x] Creating a custom modifier:
```Swift
struct BigText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 72, design: .rounded))
            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}
```
```Swift
Text("RIGHT HERE")
        .modifier(BigText())
``` 
- [x] Complex logic inside a View may require the 'return' keyword e.g.:
```Swift
struct ContentView : View {
    @ObjectBinding var detector = BeaconDetector()
    var body: some View {
        if detector.lastDistance == .immediate {
            return Text("RIGHT HERE")
                .modifier(BigText())
                .background(Color.red)
                .edgesIgnoringSafeArea(.all)
        } else if detector.lastDistance == .near {
            return Text("NEAR")
                .modifier(BigText())
                .background(Color.orange)
                .edgesIgnoringSafeArea(.all)
    ...
}
``` 
## Project 4: BetterRest
- [x] Setting up a DatePicker:
```Swift
DatePicker($wakeUp, displayedComponents: .hourAndMinute)
```
- [x] Setting up a Stepper:
```Swift
Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
    Text("\(sleepAmount, specifier: "%g") hours")
}
```
- [x] Rounding up "8.0000.." -> 8 and "8.2500000" -> 8.25:
```Swift
Text("\(16.0/2.0, specifier: "%g"))
```
- [x] Create a trailing navigation bar button:
```Swift
.navigationBarItems(trailing:
    Button(action: calculateBedtime) {
        Text("Calculate")
    }
)
```
- [x] Presenting an alert:
```Swift
.presentation($showingAlert) {
    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
```
- [x] Change only hours and minutes from current DateTime():
```Swift
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
```

- [x] Use CoreML Model to predict:
```Swift
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
```
