//
//  CardView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/7/24.
//

import SwiftUI

struct CardView: View {

    var imageName: String
    var title: String
    var subtitle: String

    var body: some View {
        Group {
            HStack(spacing: 16) {
                VStack {
                    Image(imageName)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .aspectRatio(1/1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                }
                .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(.surfaceContainerLow)
                .modifier(CardModifier())
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("event_list_error_title", comment: "Error"))
                        .style(.heading2)
                    Text(NSLocalizedString("event_list_error_subtitle", comment: "Error"))
                        .style(.body1)
                }
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.trailing, 8)
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.white)
        .modifier(CardModifier())
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(8)
    }
}

#Preview {
    CardView(imageName: "Alert", title: "Error Title", subtitle: "Error Subtitle")
}
