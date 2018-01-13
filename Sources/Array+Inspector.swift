//
//  Array+Inspector.swift
//  Inspector
//
//

extension Array {
    
    /// Return the unsafe underlying data address of the array
    public var baseAddress: UnsafePointer<Element>? {
        return withUnsafeBufferPointer { $0.baseAddress }
    }
}
