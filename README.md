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
```
- [x] Learn about the <b>BindableObject</b> protocol
- [x] Notify about changes using <b>didChange.send(())</b>
- [x] Understand the difference between <b>@State</b> and <b>@ObjectBinding</b>
- [x] Use someArray<b>.identified(by: \.self)</b> instead of conforming to the <b>Identifiable</b> protocol

## Project 1: FlagGuessing
- [x] Declare all @State variables as private when possible (recommended by Apple)
- [x] Let alerts appear based on a boolean @State variable (declarative way):
```Swift
.presentation($showingAlert) { 
  // Present alert
  
  // SwiftUI will automatically toggle 'showingAlert' variable.
}
```
- [x] Creation of an Alert and attaching a custom action to the dismiss button: 
```Swift
Alert(title: Text(alertTitle), message: Text(score), dismissButton: .default(Text("Continue")) {
  self.nextQuestion()
}) 
```
