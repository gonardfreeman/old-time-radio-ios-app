//
//  NavBarItemView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 07.08.2022.
//

import SwiftUI

struct NavBarItemView: View {
    @Binding var currentTab: Int
    var namespace: Namespace.ID
    
    var index: Int
    var label: String
    
    var body: some View {
        Button {
            currentTab = index
        } label: {
            VStack {
                Spacer()
                Text(label.capitalized)
                    .foregroundColor(currentTab == index ? .blue : Color("TabTextGray"))
                    .font(.system(size: 14))
                if currentTab == index {
                    Color.blue
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }.animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct NavBarItemView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        NavBarItemView(
            currentTab: .constant(1),
            namespace: namespace,
            index: 0,
            label: "future"
        )
    }
}
