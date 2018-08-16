//
//  RetrierTable.swift
//  OlhoVivoSDK
//
//  Created by Allan Martins on 16/08/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

struct RetrierTable<Key: Hashable, Value> {
    
    var keys = Array<Key>()
    var values = Array<Value>()
    
}

extension RetrierTable: Collection {
    
    var startIndex: Int {
        return keys.startIndex
    }
    
    var endIndex: Int {
        return keys.endIndex
    }
    
    func index(after index: Int) -> Int {
        return keys.index(after: index)
    }
    
    subscript(position: Int) -> Value? {
        return values[position]
    }
    
    subscript(key: Key) -> Value? {
        
        get {
            guard let index = self.keys.index(of: key) else {
                return nil
            }
            
            if index >= values.startIndex && index <= values.endIndex {
                return values[index]
            }
            return nil
        }
        
        set(newValue) {
            
            if newValue == nil && self.keys.contains(key),
                let index = self.keys.index(of: key),
                index >= values.startIndex && index <= values.endIndex {
                self.keys.remove(at: index)
                self.values.remove(at: index)
            }
            
            if newValue != nil && self.keys.contains(key),
                let index = self.keys.index(of: key),
                index >= values.startIndex && index <= values.endIndex {
                self.values[index] = newValue!
            }
            
            if newValue != nil && !self.keys.contains(key) {
                self.keys.append(key)
                self.values.append(newValue!)
            }
            
        }
        
    }
    
}
