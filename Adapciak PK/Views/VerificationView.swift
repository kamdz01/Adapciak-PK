//
//  VerificationView.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import SwiftUI

struct VerificationView: View {
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    @State var verificationEmail = ""
    @State var errorMessage = ""
    @State var statuteLink = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    hideKeyboard()
                }
            if (statuteLink == ""){
                VStack(spacing: 15){
                    Text("Do aktywacji aplikacji potrzebne jest połączenie z internetem")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    ProgressView()
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .onAppear{
                    viewModel.getLink(id: "STATUTE_LINK"){link in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                            withAnimation{
                                statuteLink = link
                            }
                        }
                    }
                }
            }
            else {
                VStack(spacing: 15){
                    Spacer()
                    Text("Podaj kod weryfikacyjny wysłany na adres e-mail podany przy wypełnianiu formularza. W przypadku braku maila z kodem skontaktuj się z kadrą Adapciaka.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    TextField("Kod weryfikacyjny", text: $verificationEmail)
                        .MainTextField()
                    Button(action: {
                        hideKeyboard()
                        findEmail(email: verificationEmail)
                    }) {
                        Text("Zaloguj")
                            .MainButtonBold()
                    }
                    if !errorMessage.isEmpty {
                        Text("Błąd: \(errorMessage)")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("Klikając w przycisk \"Zaloguj\" akceptujesz regulamin Adapciaka: ")
                        .multilineTextAlignment(.center)
                    LinkView(link: statuteLink, text: "Link do Regulaminu")
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    func findEmail(email: String){
        @AppStorage("verificated") var verificated = false
        viewModel.db.collection("Emails").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    errorMessage = "Error getting email: \(err)"
                    print("Error getting documents: \(err)")
                } else {
                    if (!querySnapshot!.isEmpty){
                        withAnimation() {
                            verificated = true
                        }
                        errorMessage = ""
                    }
                    else{
                        withAnimation() {
                            verificated = false
                        }
                        errorMessage = "Takiego e-maila nie ma w bazie danych"
                    }
                }
            }
    }
    
}

struct VerificationView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        VerificationView()
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
        ContentView()
    }
}
