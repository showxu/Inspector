//
//  ContiguousArray+Inspector.swift
//  Inspector
//
//

extension ContiguousArray {
    
    /// Return the unsafe underlying data address of the array, unsafe, unreliable.
    @_inlineable
    @_versioned
    var baseAddress: UnsafePointer<Element>? {
        return withUnsafeBufferPointer { $0.baseAddress }
    }
}
