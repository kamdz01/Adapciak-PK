//
//  MainSecureField.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 19/03/2023.
//

import Foundation
import SwiftUI

struct MainSecureFieldMod: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .padding(.bottom, 30)
        } else {
            content
                .padding()
                .cornerRadius(10)
                .background(Color("FieldColor"))
                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
        }
    }
}

extension SecureField {
    func MainSecureField() -> some View {
        modifier(MainSecureFieldMod())
    }
}
