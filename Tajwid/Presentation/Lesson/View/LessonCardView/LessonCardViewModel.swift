//
//  Created by Tagir Nafikov on 10/02/2018.
//

import Foundation


struct LessonCardViewModel {
    
    // MARK: - Public properties
    
    var title: String?
    var contentItemsValues: [LessonCardContentItemValue]
    
    
    // MARK: - Init
    
    init(lessonCard: LessonCard) {
        title = lessonCard.title
        contentItemsValues = lessonCard.contentItems.map() { $0.value }
    }
    
}
