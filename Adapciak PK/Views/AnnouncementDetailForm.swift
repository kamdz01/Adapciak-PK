//
//  AnnouncementDetailForm.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI
import FirebaseStorage
import FirebaseMessaging
import Foundation
import Firebase

struct AnnouncementDetailForm: View {
    @State var ifAdded = 0
    @State var uploadProgressImg = 0.0
    @State var uploadProgressDoc = 0.0
    @State var lastID = ""
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var showingAdvancedOptions: Bool
    @Binding var inputImage: UIImage?
    @Binding var title: String
    @Binding var subTitle: String
    @Binding var content: String
    @Binding var priority: Bool
    @Binding var sendNotification: Bool
    @State var addProcessing = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            if ifAdded == 2{
                VStack{
                    Text("Czekaj...")
                        .font(.title2)
                        .padding(20)
                    ProgressView("Wysyłanie ogłoszenia w toku…", value: uploadProgressDoc, total: 1.0)
                        .padding(10)
                    if (inputImage != nil){
                        ProgressView("Wysyłanie zdjęcia w toku…", value: uploadProgressImg, total: 1.0)
                            .padding(10)
                    }
                    if addProcessing {
                        ProgressView()
                    }
                }
                .padding()
                
            }
            else if ifAdded == 1{
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(Color.green)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Poprawnie dodano twoje ogłoszenie")
                }
                .onAppear{
                    title = ""
                    subTitle = ""
                    content = ""
                    showingAdvancedOptions = false
                    priority = false
                    uploadProgressImg = 0.0
                    uploadProgressDoc = 0
                    inputImage = nil
                    sendNotification = true
                }
            }
            else if ifAdded == 0{
                ScrollView{
                    VStack{
                        Text("Czy na pewno chcesz opublikować to ogłoszenie?")
                            .font(.title)
                            .padding(.bottom)
                        if priority{
                            Text("WYRÓŻNIONE")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.red)
                        }
                        if(inputImage != nil){
                            Image(uiImage: inputImage!)
                                .resizable()
                                .scaledToFit()
                        }
                        VStack(alignment: .leading){
                            Text("Tytuł:")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                            Text(title)
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                            Text("Podtytuł:")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                            Text(subTitle)
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                            Text("Zawartość:")
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                            Text(content)
                                .multilineTextAlignment(.leading)
                                .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                        }
                        .padding(/*@START_MENU_TOKEN@*/.all, 10.0/*@END_MENU_TOKEN@*/)
                        Button(action: {
                            Task{
                                addProcessing = true
                                lastID = await self.viewModel.addAnnouncement(title: title, subTitle: subTitle, content: content, hidden: false, isImage: (inputImage != nil), priority: priority)
                                
                                if lastID != "-1"{
                                    uploadProgressDoc = 1
                                    if inputImage != nil{
                                        uploadImage(imageId: lastID)
                                        ifAdded = 2
                                    }
                                    else{
                                        if (sendNotification){
                                            let sender = PushNotificationSender()
                                            let title_l = title
                                            sender.sendToTopic(title: "Pojawiło się nowe ogłoszenie!", body: title_l, id: lastID, collection: "Announcements", viewModel: viewModel){ result in
                                                addProcessing = false
                                                switch result {
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                    viewModel.hideAnnouncement(id: lastID)
                                                    ifAdded = -1
                                                case .success(_):
                                                    ifAdded = 1
                                                }
                                            }
                                        }
                                        else {
                                            addProcessing = false
                                            ifAdded = 1
                                        }
                                    }
                                }
                                else {
                                    ifAdded = -1
                                }
                            }
                        }) {
                            Text("Dodaj")
                                .MainButtonBold(bgColor: .red)
                        }
                        if addProcessing {
                            ProgressView()
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                }
            }
            else{
                VStack{
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.red)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Błąd podczas dodawania ogłoszenia")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
                .onAppear{
                    title = ""
                    subTitle = ""
                    content = ""
                    showingAdvancedOptions = false
                    priority = false
                    uploadProgressImg = 0.0
                    uploadProgressDoc = 0
                    inputImage = nil
                    sendNotification = true
                }
            }
        }
    }
    
    
    func uploadImage(imageId: String){
        let imageData = inputImage?.jpegData(compressionQuality: 0.1)
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images/\(imageId).jpg")
        let uploadTask = imagesRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            _ = metadata.size
            imagesRef.downloadURL { (url, error) in
                guard url != nil else {
                    return
                }
            }
        }
        uploadTask.observe(.progress) { snapshot in
            uploadProgressImg = snapshot.progress?.fractionCompleted ?? 0
        }
        uploadTask.observe(.resume) { snapshot in
            print("Upload resumed")
        }
        uploadTask.observe(.success) { snapshot in
            print("Upload finished successfully")
            if (sendNotification){
                let sender = PushNotificationSender()
                let title_l = title
                sender.sendToTopic(title: "Pojawiło się nowe ogłoszenie!", body: title_l, id: lastID, collection: "Announcements", viewModel: viewModel) { result in
                    addProcessing = false
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.viewModel.hideAnnouncement(id: imageId)
                        ifAdded = -1
                    case .success(_):
                        ifAdded = 1
                    }
                }
            }
            else {
                addProcessing = false
                ifAdded = 1
            }
        }
        uploadTask.observe(.failure) { snapshot in
            print("Upload error")
            addProcessing = false
            ifAdded = -1
            self.viewModel.hideAnnouncement(id: imageId)
        }
    }
}

struct AnnouncementDetailForm_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        AnnouncementDetailForm(showingAdvancedOptions: .constant(false), inputImage: .constant(UIImage()), title: .constant("title"), subTitle: .constant("subTitle"), content: .constant("content"), priority: .constant(true), sendNotification: .constant(true))
            .environmentObject(viewModel)
    }
}
