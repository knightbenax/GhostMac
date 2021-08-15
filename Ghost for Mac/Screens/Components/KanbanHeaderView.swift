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
        VStack(spacing: 0){
            if (currentDay == indexDay){
                HStack(alignment: .center, spacing: 0){
                    IndicatorView()
                    Text(day + ", " +  dayOfMonth)
                        .font(.custom("Overpass-Regular", size: 14))
                        .foregroundColor(Color("textColor"))
                        
                }.padding([.top], 10)
                .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                Text(day + ", " +  dayOfMonth)
                    .font(.custom("Overpass-Regular", size: 14))
                    .foregroundColor(Color("textColor"))
                    .padding([.leading, .trailing], 6)
                    .padding([.top], 10)
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
