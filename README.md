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
