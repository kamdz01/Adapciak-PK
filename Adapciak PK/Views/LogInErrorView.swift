//
//  SignInErrorView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 26/02/2023.
//

import SwiftUI

struct LogInErrorView: View {
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            VStack {
                Group{
                    Text("Nie możesz dodawać wpisów")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Należy się najpierw zalogować!")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.red)
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

struct LogInErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LogInErrorView()
    }
}
