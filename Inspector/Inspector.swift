//
//  Inspector.swift
//  Inspector
//

public class Inspectable<T> {
    
    public typealias Element = T
    
    public internal(set) var value: Element
    
    public init(_ value: Element) {
        self.value = value
    }
}
