//
//  Created by Tagir Nafikov on 10/02/2018.
//

import Foundation


struct LessonCardViewModel {
    
    // MARK: - Public properties
    
    var title: String?
    
    var contentItemsValues: [LessonCardContentItemValue]
    
    var path: String?
    
    var index: Int?
    
    var hasSound: Bool
    
    var isDone: Bool
    
    
    // MARK: - Init
    
    init(lessonCard: LessonCard) {
        title = lessonCard.title
        contentItemsValues = lessonCard.contentItems.map() { $0.value }
        path = lessonCard.path
        index = lessonCard.index
        hasSound = lessonCard.soundURL != nil
        isDone = AppProgressManager.isItemDone(key: lessonCard.path)
    }
    
}
