//
//  IndicatorView.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 14/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import SwiftUI

struct IndicatorView: View {
    var body: some View {
        Circle()
            .fill(Color("orange"))
            .frame(width: 12, height: 12)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
