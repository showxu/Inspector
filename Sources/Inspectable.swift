//
//  Inspectable.swift
//  Inspector
//

/// A base inspectable class type
public class Inspectable<T>: InspectableProtocol {
    
    public internal(set) var value: Element
    
    public typealias Element = T
    
    public required init(_ value: Element) {
        self.value = value
    }
}
