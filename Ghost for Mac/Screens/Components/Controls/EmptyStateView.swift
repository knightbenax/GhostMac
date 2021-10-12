//
//  EmptyStateView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 07/09/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack{
            Spacer()
            Image("empty_state_ghost")
                .resizable()
                .scaledToFit()
                .frame(width: 270)
                .padding([.bottom], 10)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            Text("You have no events or tasks for today! Time to read, catch up on that series or go enjoy nature").font(.custom("Overpass-Regular", size: 14))
                .padding([.leading, .trailing], 40).multilineTextAlignment(.center)
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
    }
}
