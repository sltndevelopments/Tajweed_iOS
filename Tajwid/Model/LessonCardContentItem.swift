//
//  Created by Tagir Nafikov on 07/02/2018.
//

import UIKit


final class LessonCardContentItem: Decodable {
    
    private enum ItemType: String {
        case plainText
        case highlitedText
        case arabic
        case image
    }
    
    var type: String
    var content: String
    
    var value: LessonCardContentItemValue {
        let itemType = ItemType(rawValue: type)!
        switch itemType {
        case .plainText:
            return LessonCardContentItemValue.plainText(content)
        case .highlitedText:
            return LessonCardContentItemValue.highlitedText(content)
        case .arabic:
            return LessonCardContentItemValue.arabic(content)
        case .image:
            return LessonCardContentItemValue.image(UIImage(named: content)!)
        }
    }
    
}


enum LessonCardContentItemValue {
    case plainText(String)
    case highlitedText(String)
    case arabic(String)
    case image(UIImage)
}



