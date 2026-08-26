//
//  FlutterCreateEventViewControllerRepresentable.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 17/08/2026.
//

import SwiftUI
import Lottie
import Flutter

struct FlutterCreateEventViewControllerRepresentable: UIViewControllerRepresentable {
  // Flutter dependencies are passed in through the view environment.
  @Environment(FlutterDependencies.self) var flutterDependencies

  func makeUIViewController(context: Context) -> some UIViewController {
      
      let flutterViewController = FlutterViewController(
        engine: flutterDependencies.flutterEngine,
        nibName: nil,
        bundle: nil)

      flutterViewController.pushRoute("/create-event/")
      
      return flutterViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
