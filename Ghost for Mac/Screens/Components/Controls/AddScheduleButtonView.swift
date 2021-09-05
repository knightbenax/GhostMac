//
//  AddScheduleButtonView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 14/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct AddScheduleButtonView: View {
    var body: some View {
        Button(action: {print("balls")}) {
            HStack{
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 16, weight: .bold))
                    .padding([.leading], 10)
                Text("Add Schedule")
                    .padding([.top, .bottom], 6)
                    .padding([.trailing], 10)
                    .padding([.leading], 2)
            }.frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 30)
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color("orange"))
        .foregroundColor(.black)
        .cornerRadius(4)
        .padding([.leading, .trailing], 20)
        .padding([.top], 20)
    }
}

struct AddScheduleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleButtonView()
    }
}
