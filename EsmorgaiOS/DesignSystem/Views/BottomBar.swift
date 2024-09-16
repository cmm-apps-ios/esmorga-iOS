//
//  BottomBar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import SwiftUI

struct BottomBar: View {

    enum AccessibilityIds {
        static let barItem: String = "BottomBar.barItem"
    }

    @Binding var selectedTab: Int
    var barItems: [BottomBarItem]

    struct BottomBarItem {
        let image: String
        let text: String
        let tag: Int
    }

    var body: some View {
        Group {
            HStack {
                ForEach(barItems, id: \.tag) { item in
                    createItemButton(item: item)
                }
            }
            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))

            .frame(height: 75)
            .frame(maxWidth: .infinity)
        }
        .background(.surface)
        .padding(.zero)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(.surfaceVariant), alignment: .top)
    }

    private func createItemButton(item: BottomBarItem) -> some View {

        Button(action: {
            selectedTab = item.tag
        }) {
            VStack {
                Image(systemName: item.image)
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(selectedTab == item.tag ? .onSurfaceVariant : .onSurface)
                    .padding(.vertical, 4)
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text(item.text)
                    .style(.caption, textColor: selectedTab == item.tag ? .onSurfaceVariant : .onSurface)
                    .padding(.top, 4)
            }
        }.frame(maxWidth: .infinity, alignment: .center)
            .accessibilityIdentifier(AccessibilityIds.barItem + "\(item.tag)")
    }
}
