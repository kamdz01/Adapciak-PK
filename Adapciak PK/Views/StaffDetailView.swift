//
//  StaffDetailView.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 24/07/2023.
//

import SwiftUI

struct StaffDetailView: View {
    
    @ObservedObject private var viewModel = FirebaseViewModel()
    @State var person: Person
    
    
    var body: some View {
        
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            ScrollView{
                VStack {
                    FirebaseImage(path: "staffImages/", imageID: .constant(person.image ?? "placeholder.jpg"), zoomable: false)
                    
                    if (person.phone != nil && person.phone != ""){
                        Text("Numer telefonu:")
                            .font(.title3)
                        Link(person.phone!, destination: URL(string: "tel:\(person.phone!)")!)
                            .font(.title2)
                            .padding(.bottom)
                    }
                    VStack(alignment: .leading) {
                        Text(person.name!).font(.title)
                        if (person.subTitle != nil && person.subTitle != "") {
                            Text(person.subTitle!).font(.title3)
                        }
                        Text(person.content!)
                    }
                    .padding()
                    
                }
                
            }
        }
    }
}

struct StaffDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let person_prev = Person(id: "0", name: "IMIE NAZWISKO", content: "qwertyuiopasdfghjklzxcvbnm", image: "placeholder.jpg", phone: "123456789")
        StaffDetailView(person: person_prev)
    }
}
