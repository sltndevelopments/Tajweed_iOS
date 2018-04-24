//
//  Created by Tagir Nafikov on 14/12/2017.
//

import Foundation


extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    static func pluralFormNumberString(for number: Int) -> String {
        let bigRemainder = number % 100
        let samllRemainder = number % 10
        if samllRemainder == 1, bigRemainder != 11 {
            return "1"
        } else if samllRemainder > 1, samllRemainder < 5, (bigRemainder < 10 || bigRemainder > 20) {
            return "2"
        } else {
            return "0"
        }
    }
    
    func localizedPlural(for number: Int) -> String {
        let numberString = String.pluralFormNumberString(for: number)
        return "\(numberString) \(self)".localized
    }
}
