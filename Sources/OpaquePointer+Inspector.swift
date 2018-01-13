//
//  OpaquePointer+Inspector.swift
//  Inspector
//
//

extension OpaquePointer: CustomStringConvertible {
    
    @_inlineable
    public var description: String {
        return debugDescription
    }
}
