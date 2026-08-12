//
//  EventDetailsView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 26/7/24.
//

import SwiftUI
import UIKit

import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  // Flutter dependencies are passed in through the view environment.
  @Environment(FlutterDependencies.self) var flutterDependencies

  func makeUIViewController(context: Context) -> some UIViewController {
    
      let flutterEngine = flutterDependencies.flutterEngine

      let flutterViewController = FlutterViewController(
      engine: flutterEngine,
      nibName: nil,
      bundle: nil)
      
      let event: [String: Any] = [
          "id": "123",
          "name": "My Event",
          "date": 1725000000,
          "description": "This is my event",
          "imageUrl": NSNull(),
          "location": [
              "name": "Bilbao",
              "lat": 43.2630,
              "long": -2.9350
          ],
          "tags": [
              "music",
              "social"
          ],
          "userJoined": false,
          "currentAttendeeCount": 25,
          "maxCapacity": 100,
          "joinDeadline": 1724990000
      ]
      
      let channel = FlutterMethodChannel(
          name: "my_app/navigation",
          binaryMessenger: flutterEngine.binaryMessenger
      )

      DispatchQueue.main.async {
          
          channel.invokeMethod(
            "openEvent",
            arguments: event
          )
      }
      
      //flutterViewController.pushRoute("/event")

      return flutterViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct EventDetailsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: EventDetailsViewModel

    init(viewModel: EventDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        FlutterViewControllerRepresentable()
    }
}
