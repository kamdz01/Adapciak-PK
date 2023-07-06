//
//  MainTextField.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 18/03/2023.
//

import Foundation
import SwiftUI

struct MainTextFieldMod: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .textInputAutocapitalization(.never)
        } else {
            content
                .padding()
                .cornerRadius(10)
                .background(Color("FieldColor"))
                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
        }
    }
}

extension TextField {
    func MainTextField() -> some View {
        modifier(MainTextFieldMod())
    }
}
