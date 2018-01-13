//
//  Array+Inspector.swift
//  Inspector
//
//

extension Array {
    
    /// Return the unsafe underlying data address of the array, unsafe, unreliable.
    @_inlineable
    @_versioned
    var baseAddress: UnsafePointer<Element>? {
        return withUnsafeBufferPointer { $0.baseAddress }
    }
}
