//
//  AlertView.swift
//  DSA
//
//  Created by Tagir Nafikov on 20/12/2017.
//  Copyright © 2017 AK BARS DIGITAL TECHNOLOGIES OOO. All rights reserved.
//

import UIKit


class AlertView {
    
    typealias AlertHandler = (_ index: Int) -> Void
    
    private var title: String?
    private var message: String?
    private var buttonTitles: [String]
    private var buttonStyles: [UIAlertActionStyle]
    private var cancelButtonTitle: String
    private var style: UIAlertControllerStyle
    private let isCancelButtonVisible: Bool
    
    
    init(
        title: String? = nil,
        message: String? = nil,
        buttonTitles: [String] = [],
        buttonStyles: [UIAlertActionStyle] = [],
        showCancel: Bool = true,
        cancelButtonTitle: String = "ОК",
        style: UIAlertControllerStyle) {
        
        self.title = title
        self.message = message
        self.buttonTitles = buttonTitles
        self.isCancelButtonVisible = showCancel
        self.cancelButtonTitle = cancelButtonTitle
        self.style = style
        self.buttonStyles = !buttonStyles.isEmpty ?
            buttonStyles :
            (0..<buttonTitles.count).map { _ in .default }
    }
    
    
    func show(in viewController: UIViewController, handler: AlertHandler? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        buttonTitles.enumerated()
            .forEach { (index, title) in
                let action = alertAction(
                    title: title,
                    style: buttonStyles[index],
                    index: index,
                    handler: handler)
                alert.addAction(action)
        }
        
        if isCancelButtonVisible {
            let cancelAction = self.alertAction(
                title: self.cancelButtonTitle,
                style: .cancel,
                index: self.buttonTitles.count,
                handler: handler)
            alert.addAction(cancelAction)
        }
        
        viewController.present(alert, animated: true)
    }
    
    
    private func alertAction(
        title: String,
        style: UIAlertActionStyle,
        index: Int,
        handler: AlertHandler?) -> UIAlertAction {
        return UIAlertAction(
            title: title,
            style: style,
            handler: { _ in
                handler?(index)
        })
    }
}

