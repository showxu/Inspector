//
//  InspectableProtocol.swift
//
//  Copyright (c) 2018 0xxd0 (https://github.com/0xxd0). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

/// A protocol type for inspect
public protocol InspectableProtocol {
    
    associatedtype Element
    
    var value: Element { get }
    
    init(_ value: Element)
}

// MARK: - Hashable stub
extension InspectableProtocol where Element: Hashable {
    
    public var hashValue: Int {
        return value.hashValue
    }
}

// MARK: - Equatable stub
extension InspectableProtocol where Element: Equatable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - CustomStringConvertible stub
extension InspectableProtocol where Element: CustomStringConvertible {
    
    public var description: String {
        return "\(Element.Type.self): \(value.description)"
    }
}

// MARK: - CustomDebugStringConvertible stub
extension InspectableProtocol where Element: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(Element.Type.self): \(value.debugDescription)"
    }
}

// MARK: - CustomDebugStringConvertible & CustomStringConvertible stub
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

