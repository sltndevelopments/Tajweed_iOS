//
//  Created by Tagir Nafikov on 18/03/2018.
//

import UIKit
import SnapKit


final class MenuView: UIView {
    
    // MARK: - Public properties
    
    var items: [MenuItem]? {
        didSet {
            set(items: items)
        }
    }
    
    typealias MenuItemClosure = (MenuItem) -> Void
    
    var didSelectItem: MenuItemClosure?
    
    
    // MARK: - Private properties
    
    private var itemViewModels: [MenuItemViewModel]?

    private var itemViews: [MenuItemView]?
    
    
    // MARK: - Private methods
    
    private func set(items: [MenuItem]?) {
        itemViews?.forEach { $0.removeFromSuperview() }
        itemViews?.removeAll()
        itemViewModels?.removeAll()
        
        var prevView: UIView?
        
        guard let items = items else { return }
        
        if itemViews == nil {
            itemViews = [MenuItemView]()
        }
        if itemViewModels == nil {
            itemViewModels = [MenuItemViewModel]()
        }
        
        let count = items.count
        for (index, item) in items.enumerated() {
            let isLast = index == count - 1
            
            let itemViewModel = MenuItemViewModel(
                title: item.title,
                subtitle: item.subtitle,
                isSeparatorHidden: isLast)
            itemViewModels?.append(itemViewModel)
            
            let itemView = UIView.loadFromXib(type: MenuItemView.self)!
            itemView.update(with: itemViewModel)
            itemView.didSelect = didSelectItemView(_:)
            addSubview(itemView)
            itemViews?.append(itemView)
            itemView.snp.makeConstraints { maker in
                if let prevView = prevView {
                    maker.top.equalTo(prevView.snp.bottom)
                } else {
                    maker.top.equalToSuperview()
                }
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                
                if isLast {
                    maker.bottom.equalToSuperview()
                }
            }
            
            prevView = itemView
        }
    }
    
    
    // MARK: - Actions
    
    private func didSelectItemView(_ view: MenuItemView) {
        guard let index = itemViews?.index(of: view),
            let item = items?[index]
            else {
                return
        }
        
        didSelectItem?(item)
    }
    
}
