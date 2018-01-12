//
//  ContiguousArray+Inspector.swift
//  Inspector
//
//

extension ContiguousArray {
    
    /// Return the unsafe underlying data address of the array
    public var baseAddress: UnsafePointer<Element>? {
        return withUnsafeBufferPointer { $0.baseAddress }
    }
}
