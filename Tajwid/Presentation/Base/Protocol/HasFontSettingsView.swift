//
//  Created by Tagir Nafikov on 08/04/2018.
//

import UIKit


fileprivate var fontSettingsViewAssociatedKey = "fontSettingsViewAssociatedKey"
fileprivate let fontSettingsViewHeight = CGFloat(106)


protocol HasFontSettingsView: class {
    
}


extension HasFontSettingsView {
    
    var fontSettingsView : FontSettingsView {
        get {
            if let view = objc_getAssociatedObject(self, &fontSettingsViewAssociatedKey) as? FontSettingsView {
                return view
            }
            let view = FontSettingsView()
            objc_setAssociatedObject(self, &fontSettingsViewAssociatedKey, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
        set {
            objc_setAssociatedObject(self, &fontSettingsViewAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}


extension HasFontSettingsView where Self: UIViewController {
    
    var isFontSettingsViewHidden: Bool {
        guard let topConstraint = fontSettingsViewTopConstaint() else { return true }
        
        return topConstraint.constant < 0
    }

    func addFontSettingsView() {
        fontSettingsView = UIView.loadFromXib(type: FontSettingsView.self)!
        fontSettingsView.backgroundColor = .whiteOne
        view.addSubview(fontSettingsView)
        fontSettingsView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(fontSettingsViewHeight)
            maker.top.equalTo(view.snp.top).offset(-fontSettingsViewHeight)
        }
    }
    
    func fontSettingsViewTopConstaint() -> NSLayoutConstraint? {
        for constraint in view.constraints {
            if constraint.firstItem === fontSettingsView, constraint.firstAttribute == .top {
                return constraint
            }
        }
        
        return nil
    }
    
    func showFontSettingsView() {
        if !isFontSettingsViewHidden { return }
        
        guard let topConstraint = fontSettingsViewTopConstaint() else { return }
        
        topConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func hideFontSettingsView() {
        if isFontSettingsViewHidden { return }
        
        guard let topConstraint = fontSettingsViewTopConstaint() else { return }
        
        topConstraint.constant = -fontSettingsViewHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}
