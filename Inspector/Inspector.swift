//
//  Inspector.swift
//  Inspector
//

public protocol InspectableProtocol {
    
    associatedtype Element
    
    var value: Element { get }
    
    init(_ value: Element)
}

public class Inspectable<T>: InspectableProtocol {
    
    public internal(set) var value: Element
    
    public typealias Element = T
    
    public required init(_ value: Element) {
        self.value = value
    }
}

extension String {
    
    public var cString: [CChar] {
        return Array(utf8CString)
    }
}
