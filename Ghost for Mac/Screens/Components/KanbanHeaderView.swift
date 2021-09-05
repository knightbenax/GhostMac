//
//  KanbanHeaderView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 14/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct KanbanHeaderView: View {
    var day : String
    var dayOfMonth : String
    var currentDay : Int
    var indexDay : Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            if (currentDay == indexDay){
                HStack(alignment: .center, spacing: 0){
                    IndicatorView()
                    Text(day + ", " +  dayOfMonth)
                        .font(.custom("Overpass-Regular", size: 14))
                        .foregroundColor(Color("textColor"))
                    Spacer()
                    Button(action: {print("be")}) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 32, height: 28, alignment: .center)
                    }
                    .buttonStyle(BlueButtonStyle())
                    .foregroundColor(.black)
                    .cornerRadius(4.0)
                }.padding([.top], 10)
                .padding([.leading, .trailing], 14)
                .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                HStack(alignment: .center, spacing: 0){
                    Text(day + ", " +  dayOfMonth)
                        .font(.custom("Overpass-Regular", size: 14))
                        .foregroundColor(Color("textColor"))
                    Spacer()
                    Button(action: {print("be")}) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 32, height: 28, alignment: .center)
                    }
                    .buttonStyle(BlueButtonStyle())
                    .foregroundColor(.black)
                    .cornerRadius(4.0)
                }.padding([.top], 10)
                .padding([.leading, .trailing], 16)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct KanbanHeaderView_Previews: PreviewProvider {
    static var day  = "Friday"
    static var dayOfMonth  = "13th August"
    static var currentDay  = 7
    static var indexDay  = 7
    
    static var previews: some View {
        KanbanHeaderView(day: day, dayOfMonth: dayOfMonth, currentDay: currentDay, indexDay: indexDay)
    }
}
