//
//  LoginView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 31/07/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    var authViewModel : AuthViewModel
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("You need to connect your Google Account to continue")
                .font(.custom("Overpass-Regular", size: 14))
                .padding([.bottom], 20)
            Button(action: { authViewModel.signInGoogle() }) {
                HStack{
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding([.leading], 20)
                    Text("Add Google Account")
                        .font(.custom("Overpass-Regular", size: 14))
                        .padding([.top, .bottom], 10)
                        .padding([.trailing], 20)
                        .padding([.leading], 2)
                }
            }.buttonStyle(PlainButtonStyle())
                .background(Color("orange"))
                .foregroundColor(.black)
                .cornerRadius(4)
                .padding([.bottom], 20)
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var authViewModel = AuthViewModel()
    
    static var previews: some View {
        LoginView(authViewModel: authViewModel)
    }
}
