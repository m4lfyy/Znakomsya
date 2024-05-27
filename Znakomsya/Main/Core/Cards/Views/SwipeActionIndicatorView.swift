//
//  SwipeActionIndicatorView.swift
//  Znakomsya
//
//  Created by Данил Юсупов on 23.05.2024.
//

import SwiftUI

struct SwipeActionIndicatorView: View {
    @Binding var xOffset: CGFloat
    
    var body: some View {
        HStack {
            Text("LIKE")
                .font(Font.custom("Montserrat-Bold", size: 26))
                .foregroundStyle(.green)
                .rotationEffect(.degrees(-45))
                .opacity(Double(xOffset / SizeConst.screenCutoff))
            
            Spacer()
            
            Text("NOPE")
                .font(Font.custom("Montserrat-Bold", size: 26))
                .foregroundStyle(.red)
                .rotationEffect(.degrees(45))
                .opacity(Double(xOffset / SizeConst.screenCutoff) * -1)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 30)
    }
}

#Preview {
    SwipeActionIndicatorView(xOffset: .constant(20))
}
