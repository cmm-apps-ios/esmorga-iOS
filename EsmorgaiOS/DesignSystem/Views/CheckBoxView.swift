//
//  CheckBoxView.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 04/09/2026.
//

// Source - https://stackoverflow.com/a/63389253
// Posted by Jad Chaar
// Retrieved 2026-09-04, License - CC BY-SA 4.0

import SwiftUI

struct CheckBoxView: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    struct CheckBoxViewHolder: View {
        @State var checked = false

        var body: some View {
            CheckBoxView(checked: $checked)
        }
    }

    static var previews: some View {
        CheckBoxViewHolder()
    }
}
