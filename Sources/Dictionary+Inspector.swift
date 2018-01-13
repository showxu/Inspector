//
//  Dictionary+Inspector.swift
//  Inspector
//
//

extension Dictionary {
    
    @_inlineable
    public func contains(key: Dictionary.Key) -> Bool {
        return index(forKey: key) != nil
    }
}
