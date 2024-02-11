//
//  ActivityView.swift
//  Assignment2WibuApp
//
//  Created by Riza Adi Kurniawan on 15/02/24.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    
    
    var activityItem: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: activityItem, applicationActivities: applicationActivities)
        
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
       
    }
}
