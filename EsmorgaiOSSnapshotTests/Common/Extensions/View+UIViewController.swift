//
//  View+UIViewController.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Vidal Pérez, Omar on 10/9/24.
//

import Foundation
import SwiftUI

extension SwiftUI.View {

    func toVC() -> UIViewController {
        let vc = UIHostingController(rootView: self)
        vc.view.frame = UIScreen.main.bounds
        return vc
    }
}
