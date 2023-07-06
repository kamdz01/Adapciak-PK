//
//  LinkView.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import SwiftUI


struct LinkView: View {
    var link: String
    var text: String
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Text(text)
            .underline()
            .fontWeight(.medium)
            .onTapGesture {
                if let url = URL(string: link){
                    openURL(url)
                }
            }
    }
}

func validateURL(url: String) -> Bool{
    if((url.isEmpty) || url.contains(" ") || !url.contains(".") || url.hasSuffix(".") || URL(string: url) == nil || URL(string: url)?.host == nil || URL(string: url)?.scheme == nil){
        return false
    }
    else {
        return true
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(link: "https://www.google.pl/", text: "LINK!")
    }
}
