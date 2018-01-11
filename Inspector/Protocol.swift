//
//  Protocol.swift
//  Inspector
//
//

import ObjectiveC.runtime

/// An class type that represents an Objective-C declared property.
/// Type Inspectable<ObjectiveC.Protocol> is not available here cause the
/// .Property is built-in syntax 'foo.Protocol' expression
/// So we use ObjectiveC.`Protocol` instand
final public class Protocol: Inspectable<ObjectiveC.`Protocol`>  {
    
    public lazy var name: String? = {
        return nil
    }()
}

