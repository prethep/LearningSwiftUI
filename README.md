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
``` 
