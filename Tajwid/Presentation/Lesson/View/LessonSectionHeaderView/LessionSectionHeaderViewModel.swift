//
//  Created by Tagir Nafikov on 10/02/2018.
//

import Foundation


struct LessionSectionHeaderViewModel {
    
    // MARK: - Public properties
    
    var arabicText: String
    var text: String
    
    
    // MARK: - Init
    
    init(lessonSection: LessonSection) {
        arabicText = lessonSection.arabicTitle ?? "vvvv"
        text = lessonSection.title
    }
    
}
