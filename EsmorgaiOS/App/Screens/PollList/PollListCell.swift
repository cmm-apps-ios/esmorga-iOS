//
//  PollListCell.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 23/9/26.
//

import SwiftUI

struct PollListCell: View {

    var centerTitle: Bool = false
    var title: String
    var subtitle: String?
    var secondary: String?
    var titleAlignment: Alignment = .leading

    var body: some View {
        VStack(alignment: .leading) {
            Image("placeholder-esmorga")
                .resizable()
                .aspectRatio(16/9, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .cornerRadius(8)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.bottom, 16)
            Text(title)
                .style(.heading2)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: titleAlignment == .leading ? .leading : .center)
                .multilineTextAlignment(titleAlignment == .leading ? .leading : .center)
            if let subtitle {
                Text(subtitle)
                    .style(.body1Accent)
                    .padding(.bottom, 4)
            }
            if let secondary {
                Text(secondary)
                    .style(.body1Accent)
                    .padding(.bottom, 16)
            }
        }.padding(.all, 16)
    }
}

#Preview {
    PollListCell(title: "Title", subtitle: "Subtitle", secondary: "Secondary")
}
