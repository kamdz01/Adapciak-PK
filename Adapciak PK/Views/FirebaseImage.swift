//
//  ImageView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 20/12/2022.
//


import SwiftUI
import Combine
import FirebaseStorage

struct FirebaseImage : View {
    
    var path: String
    @State var isLoading = true
    @State var ifError = false
    @Binding var imageID: String
    @State private var imageURL = URL(string: "")
    @State var image = UIImage()
    @State var ifShown = false
    @State private var isImagePresented = false
    private let fileManager = LocalFileManager.instance
    
    var body: some View {
        ZStack{
            if (isLoading)
            {
                ProgressView()
                    .padding([.top, .bottom])
            }
            else {
                if (!ifError){
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .id(image)
                        .transition(.scale.animation(.easeOut(duration: 0.15)))
                        .onTapGesture {
                            isImagePresented = true
                        }
                        .fullScreenCover(isPresented: $isImagePresented) {
                            ZStack {
                                SwiftUIImageViewer(image: image)
                                VStack{
                                    HStack{
                                        Spacer()
                                        ZStack {
                                            Image(systemName: "xmark")
                                                .font(.headline)
                                                .padding(10)
                                                .background(Color.secondary)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    isImagePresented = false
                                            }
                                        }
                                        .padding(5)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    
                }
                else{
                    Text("Błąd podczas ładowania obrazka")
                        .foregroundColor(.secondary)
                        .padding([.top, .bottom])
                }
            }
        }
        .onAppear{
            if (!ifShown){
                if (nil != fileManager.getImage(imageName: imageID, folderName: "temp")){
                    image = fileManager.getImage(imageName: imageID, folderName: "temp")!
                    print("Image already in storage")
                    isLoading = false
                    ifShown = true
                }
                else{
                    print("Downloading image to storage...")
                    isLoading = false
                    loadImageToMem()
                    ifShown = true
                }
            }
        }
        .onChange(of: imageID){ id in
            if (nil != fileManager.getImage(imageName: imageID, folderName: "temp")){
                image = fileManager.getImage(imageName: imageID, folderName: "temp")!
                print("Image already in storage")
                //isLoading = false
                ifShown = true
            }
            else{
                print("Downloading image to storage...")
                loadImageToMem()
                ifShown = true
            }
        }
    }
    
    func loadImageToMem(){
        if (isLoading){
            return
        }
        isLoading = true
        let storage = Storage.storage().reference(withPath: "\(path)\(imageID)")
        storage.getData(maxSize: ((2048 * 2048 * 5 * 5) as Int64) ) { data, error in
            if error != nil {
                print("Download fail")
                isLoading = false
                ifError = true
                return
            }
            if (data != nil){
                print("Download success")
                fileManager.saveImage(image: UIImage(data: data!)!, imageName: imageID, folderName: "temp")
                image = fileManager.getImage(imageName: imageID, folderName: "temp") ?? UIImage(data: data!) ?? UIImage()
                ifError = false
                isLoading = false
                return
            }
            else{
                print("Download fail")
                ifError = true
                isLoading = false
                return
            }
        }
    }
}

struct FirebaseImage_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseImage(path: "", imageID: .constant("N2_t.png"))
    }
}
