//
//  StaffView.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 24/07/2023.
//

import SwiftUI


struct StaffView: View {
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        StaffGrid(tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        StaffGrid(tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        StaffGrid(tabClicked: $tabClicked)
                            .onAppear() {
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Kadra")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack {
                            Text("")
                            NavigationLink(destination: SignInView()){
                                Image("login-icon")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct StaffGrid: View{
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    let spacing: CGFloat = 20
    let columnCount = 2
    
    var columns: [GridItem] {
        Array(repeatElement(GridItem(.flexible()), count: columnCount))
    }
    
    
    var body: some View{
        ScrollView {
            GeometryReader { proxy in
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(viewModel.staff) { person in
                        NavigationLink(destination: StaffDetailView(person: person)){
                            StaffViewItem(person: person)
                        }
                            .frame(width: cellWidth(for: proxy.size), height: cellWidth(for: proxy.size))
                            .background(Color("FieldColor"))
                            .cornerRadius(15)
                            .padding()
                    }
                }
            }
        }
        .padding(.top)
    }
    
    func cellWidth(for size: CGSize) -> CGFloat {
        (size.width - ((CGFloat(columnCount) - 1) * spacing)) / CGFloat(columnCount)
    }
}

struct StaffViewItem: View {
    
    let person: Person
    
    var body: some View {
//        NavigationLink(destination: StaffDetailView(person: person))
//        {
            ZStack(alignment: .leading) {
                HStack {
                    VStack {
                        FirebaseImage(path: "staffImages/", imageID: .constant(person.image ?? "placeholder.jpg"), zoomable: false)
                        Text(person.name!)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
            }
//        }
    }
}

struct StaffView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        StaffView(tabClicked: .constant(false))
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
