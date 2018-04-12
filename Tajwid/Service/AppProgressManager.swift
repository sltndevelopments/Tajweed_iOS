//
//  AppProgressManager.swift
//  Tajwid
//
//  Created by Tagir Nafikov on 12/04/2018.
//  Copyright © 2018 teorius. All rights reserved.
//

import Foundation


final class AppProgressManager {
    
    // MARK: - Constants
    
    private enum Constants {
        static let progressDictKey = "progressDictKey"
    }
    
    
    // MARK: - Class private properties
    
    private static var progressDict: [String: Bool] {
        get {
            return UserDefaults.standard.object(forKey: Constants.progressDictKey)
                as? [String: Bool]
                ?? [:]
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.progressDictKey)
        }
    }
    
    
    // MARK: - Class public methods
    
    static func isItemDone(key: String?) -> Bool {
        guard let key = key, let isDone = progressDict[key] else { return false }
        return isDone
    }
    
    static func setItemDone(_ isDone: Bool, for key: String?) {
        guard let key = key else { return }
        progressDict[key] = isDone
    }
    
}
