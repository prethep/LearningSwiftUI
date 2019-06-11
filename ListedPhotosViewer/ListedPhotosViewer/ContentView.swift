//
//  ContentView.swift
//  ListedPhotosViewer
//
//  Created by PP on 11.06.19.
//  Copyright © 2019 PP. All rights reserved.
//

import Combine
import SwiftUI

class DataSource: BindableObject {
    // PassthroughSubject< send nothing and never throw errors >
    var didChange = PassthroughSubject<Void, Never>()
    var photos = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath, let filenames = try? fm.contentsOfDirectory(atPath: path) {
            for filename in filenames {
                if filename.hasPrefix("nssl") {
                    photos.append(filename)
                }
            }
        }
        
        didChange.send(())
    }
    
}

struct DetailView: View {
    @State private var navBarHidden = false
    var selectedPhoto: String
    
    var body: some View {
//        Image(selectedImage) // beta issue
        let img = UIImage(named: selectedPhoto)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(1024/768 , contentMode: .fit) // beta issue
            .navigationBarTitle(Text(selectedPhoto), displayMode: .inline)
            .navigationBarHidden(navBarHidden)
            .tapAction {
                self.navBarHidden.toggle()
            }
    }
}

struct ContentView: View {
    @ObjectBinding private var dataSource = DataSource()
    var body: some View {
        NavigationView {
            List(dataSource.photos.identified(by: \.self)) { photo in
                NavigationButton(destination: DetailView(selectedPhoto: photo), isDetail: true) {
                    Text(photo)
                }
            }.navigationBarTitle(Text("Photos"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
