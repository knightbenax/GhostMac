//
//  TopView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 31/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct TopView: View {
    @State var loading : Bool
    var baseViewModel = BaseViewModel()
    var statsViewModel = StatsViewModel()
    @State var prodStats = "Seeking today's productivity"
    @AppStorage("firstname") var firstname = ""
    
    init(loading: Bool) {
        self.loading = loading
    }
    
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text("Hi " + firstname)
                    .font(.system(size: 20, weight: .bold)).foregroundColor(Color.white)
                Text(prodStats)
                    .font(.system(size: 12)).foregroundColor(Color.white)
            }
            .padding([.leading, .trailing], 14)
            .padding([.top], 10)
            .padding([.bottom], 14)
            .onAppear(){
                statsViewModel.getRescueTimeData(completion: { result in
                    prodStats = result
                })
            }
            Spacer()
            if (loading){
                ProgressView().progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 30, height: 30)
            }
            VStack{
                Button(action: {print("bussy")}) {
                    HStack{
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 16, weight: .bold))
                            .padding([.leading], 10)
                        Text("Add Schedule")
                            .padding([.top, .bottom], 6)
                            .padding([.trailing], 10)
                            .padding([.leading], 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color("orange"))
                .foregroundColor(.black)
                .cornerRadius(4)
            }
            .padding([.leading, .trailing], 14)
        }.frame(maxWidth: .infinity)
        .background(Color("GhostBlue"))
    }
}

struct TopView_Previews: PreviewProvider {
    static var loading : Bool = false
    
    static var previews: some View {
        TopView(loading: loading)
    }
}
