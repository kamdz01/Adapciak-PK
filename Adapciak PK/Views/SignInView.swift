//
//  SignInView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @AppStorage("loggedIn") var loggedIn = false
    @AppStorage("verificated") var verificated = false
    @AppStorage("email") var email = ""
    @AppStorage("password") var password = ""
    
    @State var showNotificationBtn = true
    @State var signOutProcessing = false
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    @State var presentAlert = false
    
    @Environment (\.scenePhase) private var scenePhase
    
    private let fileManager = LocalFileManager.instance
    
    var body: some View {
        
        if loggedIn{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                VStack(spacing: 15){
                    Spacer()
                    Text("Zalogowano jako: \n\(email)")
                        .font(.title2)
                    Button(action: {
                        signOutUser()
                    }) {
                        Text("Wyloguj")
                            .MainButtonBold()
                    }
                    Spacer()
                    Button(action: {
                        _ = fileManager.deleteFolder(folderName: "temp")
                        presentAlert = true
                    }) {
                        Text("Usuń dane aplikacji")
                            .MainButtonBold()
                    }
                    .alert(isPresented: $presentAlert){
                        Alert(
                            title: Text("Usunięto wszystkie lokalne dane"),
                            dismissButton: Alert.Button.default(Text("OK"), action: {
                                //                                withAnimation(){
                                //                                    verificated = false
                                //                                }
                            })
                        )
                    }
                    if(showNotificationBtn){
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            Text("Włącz powiadomienia")
                                .MainButtonBold()
                        }
                    }
                }
                .padding()
                .navigationTitle("Logowanie")
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear(){
                let center = UNUserNotificationCenter.current()
                center.getNotificationSettings { settings in
                    guard (settings.authorizationStatus == .authorized) ||
                            (settings.authorizationStatus == .provisional) else {
                        showNotificationBtn = true
                        return
                    }
                    showNotificationBtn = false
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { settings in
                        guard (settings.authorizationStatus == .authorized) ||
                                (settings.authorizationStatus == .provisional) else {
                            showNotificationBtn = true
                            return
                        }
                        showNotificationBtn = false
                    }
                }
            }
        }
        else{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                VStack(spacing: 15) {
                    Spacer()
                    Text("Uwaga! Opcja logowania dostępna jest tylko dla Kadry Rajdu. Jeżeli jesteś uczestnikiem, nie musisz się logować.")
                        .padding()
                    SignInCredentialFields(email: $email, password: $password)
                    Button(action: {
                        hideKeyboard()
                        signInUser(userEmail: email, userPassword: password)
                    }) {
                        Text("Zaloguj")
                            .MainButtonBold(ifActive: !(email.isEmpty || password.isEmpty || signInProcessing))
                    }
                    .disabled(email.isEmpty || password.isEmpty || signInProcessing)
                    if signInProcessing {
                        ProgressView()
                    }
                    if !signInErrorMessage.isEmpty {
                        Text("Failed signing in: \(signInErrorMessage)")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: {
                        _ = fileManager.deleteFolder(folderName: "temp")
                        presentAlert = true
                    }) {
                        Text("Usuń dane aplikacji")
                            .MainButtonBold()
                    }
                    .alert(isPresented: $presentAlert){
                        Alert(
                            title: Text("Usunięto wszystkie lokalne dane"),
                            dismissButton: Alert.Button.default(Text("OK"), action: {
                                //                                withAnimation(){
                                //                                    verificated = false
                                //                                }
                            })
                        )
                    }
                    if(showNotificationBtn){
                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            Text("Włącz powiadomienia")
                                .MainButtonBold()
                        }
                    }
                }
                .padding()
                .navigationTitle("Logowanie")
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
            .gesture(DragGesture().onChanged{_ in hideKeyboard()})
            .onAppear(){
                let center = UNUserNotificationCenter.current()
                center.getNotificationSettings { settings in
                    guard (settings.authorizationStatus == .authorized) ||
                            (settings.authorizationStatus == .provisional) else {
                        showNotificationBtn = true
                        return
                    }
                    showNotificationBtn = false
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { settings in
                        guard (settings.authorizationStatus == .authorized) ||
                                (settings.authorizationStatus == .provisional) else {
                            showNotificationBtn = true
                            return
                        }
                        showNotificationBtn = false
                    }
                }
            }
        }
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                signInProcessing = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                signInProcessing = false
            case .some(_):
                print("User signed in")
                signInProcessing = false
                signInErrorMessage = ""
                loggedIn = true
            }
            
        }
        print("LoggedIn: \(loggedIn)")
    }
    
    func signOutUser() {
        signOutProcessing = true
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            signOutProcessing = false
        }
        loggedIn = false
        email = ""
        password = ""
        print("LoggedIn: \(loggedIn), Email: \(email), Password: \(password)")
    }
}

struct SignInView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        //        SignInView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("samplepassw"))
        //        SignInView(loggedIn: .constant(false), email: .constant("sample@email.com"), password: .constant("samplepassw"))
        SignInView()
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .environmentObject(viewModel)
            .onAppear(){
                self.viewModel.fetchData()
            }
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group {
            TextField("Email", text: $email)
                .MainTextField()
            SecureField("Hasło", text: $password)
                .MainSecureField()
        }
    }
}
