//
//  UIStackView+Additions.swift
//  Tajwid
//
//  Created by Ha Sab on 16.03.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeFully(view: view)
        }
    }

}
