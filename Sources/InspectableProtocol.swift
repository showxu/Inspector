//
//  InspectableProtocol.swift
//  Inspector
//
//

/// A protocol type for inspect
public protocol InspectableProtocol {
    
    associatedtype Element
    
    var value: Element { get }
    
    init(_ value: Element)
}

// MARK: - Hashable
extension InspectableProtocol where Element: Hashable {
    
    public var hashValue: Int {
        return value.hashValue
    }
}

// MARK: - Equatable
extension InspectableProtocol where Element: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - CustomStringConvertible
extension InspectableProtocol where Element: CustomStringConvertible {
    
    public var description: String {
        return value.description
    }
}

// MARK: - CustomDebugStringConvertible
extension InspectableProtocol where Element: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return value.debugDescription
    }
}

// MARK: - CustomDebugStringConvertible & CustomStringConvertible
extension InspectableProtocol where Element: CustomDebugStringConvertible & CustomStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - ExpressibleByStringLiteral stub
extension InspectableProtocol {
    
    public init<T>(stringLiteral value: Element.StringLiteralType)
        where T: ExpressibleByStringLiteral, T == Element  {
            self.init(Element(stringLiteral: value))
    }
}

