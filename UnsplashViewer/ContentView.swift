//
//  ContentView.swift
//  UnsplashViewer
//
//  Created by Alexios Karadimos on 28/10/20.
//

import Combine
import SwiftUI


class DataSource: ObservableObject {
    // Send nothing and never throw errors
    let didChange = PassthroughSubject<Void, Never>()
    @Published var pictures = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath,
           let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasSuffix("-unsplash.jpg") {
                    pictures.append(item)
                }
            }
        }
        
        didChange.send(())
    }
}


struct DetailView: View {
    var selectedImage: String
    @State var hidesNavigationBar = false
    
    var body: some View {
        let img = UIImage(named: selectedImage)!
        Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
            .navigationBarHidden(hidesNavigationBar)
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                // Image was tapped once
                self.hidesNavigationBar.toggle()
            })
    }
}


struct ContentView: View {
    @ObservedObject var dataSource = DataSource()
    
    var body: some View {
        NavigationView {
            List(dataSource.pictures, id: \.self) { picture in
                NavigationLink(
                    destination: DetailView(selectedImage: picture),
                    label: {
                        Text(picture)
                            .padding()
                    })
            }.navigationTitle(Text("Unsplash Viewer"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
