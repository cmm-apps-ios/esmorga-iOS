//
//  EventListCell.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import SwiftUI

struct EventListCell: View {

    var centerTitle: Bool = false
    var imageUrl: URL?
    var title: String
    var subtitle: String?
    var secondary: String?
    var titleAlignment: Alignment = .leading

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .cornerRadius(8)
            } placeholder: {
                Image("placeholder-esmorga")
                    .resizable()
                    .aspectRatio(16/9, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .cornerRadius(8)
            }
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
    EventListCell(title: "Title", subtitle: "Subtitle", secondary: "Secondary")
}
