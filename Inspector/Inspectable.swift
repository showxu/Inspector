//
//  Inspectable.swift
//  Inspector
//

public typealias Block = Any

/// A base inspectable class type
public class Inspectable<T>: InspectableProtocol {
    
    public internal(set) var value: Element
    
    public typealias Element = T
    
    public required init(_ value: Element) {
        self.value = value
    }
}
