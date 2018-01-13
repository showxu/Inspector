//
//  ObjectiveC.Protocol+Inspector.swift
//  Inspector
//
//

import ObjectiveC.runtime

public typealias ObjCProtocol = ObjectiveC.`Protocol`

extension ObjCProtocol: Equatable {
    
    @_inlineable
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public static func ==(lhs: ObjCProtocol, rhs: ObjCProtocol) -> Bool {
        return protocol_isEqual(lhs, rhs)
    }
}
