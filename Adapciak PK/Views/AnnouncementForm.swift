//
//  FormView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 14/12/2022.
//

import SwiftUI

struct AnnouncementForm: View {
    @State private var showSheet = false
    @State var showingAdvancedOptions = false
    @State private var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    @State var title: String = ""
    @State var subTitle: String = ""
    @State var content: String = ""
    @State var priority: Bool = false
    @State var sendNotification: Bool = true
    @Binding var ifAdding: Bool
    @AppStorage("loggedIn") var loggedIn = false
    
    //@Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            Form {
                Group{
                    Section(header: Text("Ogłoszenie:")){
                        FloatingTextField(title: "Tytuł", text: $title)
                        FloatingTextField(title: "Podtytuł", text: $subTitle)
                        FloatingTextField(title: "Treść", text: $content)
                        //                        if #available(iOS 16.0, *) {
                        //                            TextField("Tytuł", text: $title, axis: .vertical)
                        //                            TextField("Podtytuł", text: $subTitle, axis: .vertical)
                        //                            TextField("Treść", text: $content, axis: .vertical)
                        //                        } else {
                        //                            TextField("Tytuł", text: $title)
                        //                            TextField("Podtytuł", text: $subTitle)
                        //                            TextField("Treść", text: $content)
                        //                        }
                        Toggle("Wyróżnione", isOn: $priority)
                            .onTapGesture {
                                hideKeyboard()
                            }
                        Toggle("Wyślij z powiadomieniem", isOn: $sendNotification)
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                    HStack{
                        Button("Usuń zdjęcie"){
                            inputImage = nil
                        }
                        .foregroundColor(Color.red)
                        Spacer()
                        if(image == nil){
                            Button("Dodaj zdjęcie"){}
                                .onTapGesture {
                                    hideKeyboard()
                                    showingImagePicker = true
                                }
                        }
                        else{
                            Button("Zmień zdjęcie"){}
                                .onTapGesture {
                                    hideKeyboard()
                                    showingImagePicker = true
                                }
                        }
                    }
                    if(image != nil){
                        image?
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Toggle("Gotowe", isOn: $showingAdvancedOptions.animation())
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .disabled(!(!title.isEmpty && !subTitle.isEmpty && !content.isEmpty))
                    if showingAdvancedOptions{
                        
                        Button("Dodaj") {
                            showSheet.toggle()
                        }
                        .sheet(isPresented: $showSheet) {
                            AnnouncementDetailForm(showingAdvancedOptions: $showingAdvancedOptions, inputImage: $inputImage, title: $title, subTitle: $subTitle, content: $content, priority: $priority, sendNotification: $sendNotification)
                        }
                    }
                }
                .listRowBackground(Color("FieldColor"))
            }
            .gesture(DragGesture().onChanged{_ in hideKeyboard()})
            .onChange(of: inputImage) { _ in loadImage() }
            .onChange(of: showSheet) { newValue in
                if(showingAdvancedOptions == false){
                    ifAdding = newValue
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .navigationTitle("Dodaj ogłoszenie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        hideKeyboard()
                    }
                label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                }
            }
        }
        //        .onChange(of: loggedIn){ loggedIn in
        //            presentationMode.wrappedValue.dismiss()
        //        }
    }
    func loadImage() {
        guard let inputImage = inputImage else {
            image = nil
            return
        }
        image = Image(uiImage: inputImage)
    }
}

struct AnnouncementFormContainer: View{
    @Binding var ifAdding: Bool
    @AppStorage("loggedIn") var loggedIn = false
    
    var body: some View{
        if(loggedIn){
            if #available(iOS 16.0, *) {
                AnnouncementForm(ifAdding: $ifAdding)
                    .scrollContentBackground(.hidden)
                    .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
            } else {
                AnnouncementForm(ifAdding: $ifAdding)
                    .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
            }
        }
        else{
            LogInErrorView()
        }
    }
}


struct AnnouncementForm_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        AnnouncementFormContainer(ifAdding: .constant(true), loggedIn: true)
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .previewDisplayName("MainView")
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
