//
//  Method.swift
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

import ObjectiveC.runtime


/// An class type that represents an instance Method.
final public class Method: Inspectable<ObjectiveC.Method> {
    
    /// Returns the name of a method.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var name: Selector {
        return Selector(method_getName(value))
    }
    
    /// Returns the implementation of a method.
    /// The implementation can be modified, so it can't be lazy.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var implementation: IMP {
        return IMP(method_getImplementation(value))
    }
    
    /// Returns a string describing a method's parameter and return types.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var typeEncoding: String? {
        let type = method_getTypeEncoding(value)
        return type != nil ? String(cString: type!) : nil
    }
    
    /// Returns the number of arguments accepted by a method.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public var numberOfArguments: UInt {
        return UInt(method_getNumberOfArguments(value))
    }
    
    /// Returns a string describing a method's return type.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var returnType: String {
        #if swift(>=4.0)
            let type = method_copyReturnType(value)
        #else
            let type = method_copyReturnType(value)!
        #endif
        defer {
            free(type)
        }
        return String(cString: type)
    }
    
    /// Returns a string describing a single parameter type of a method.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var argumentType: ((UInt) -> String?) {
        return {
            precondition($0 < self.numberOfArguments)
            guard
                let type = method_copyArgumentType(self.value, UInt32($0))
                else { return nil }
            defer {
                free(type)
            }
            return String(cString: type)
        }
    }
}

extension Method {
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func getMethodDescription() -> objc_method_description {
        #if swift(>=4.0)
            let buffer = method_getDescription(value)
        #else
            let buffer = method_getDescription(value)!
        #endif
        let desc = buffer.move()
        return desc
    }
    
    /// Sets the implementation of a method.
    ///
    /// - Parameters:
    ///   - imp: The implemention to set to this method.
    /// - Returns: The previous implementation of the method.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func setImplementation(_ imp: ObjectiveC.IMP) -> ObjectiveC.IMP {
        return method_setImplementation(value, imp)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func setImplementation(_ imp: IMP) -> IMP {
        return IMP(setImplementation(imp.value))
    }

    /// Exchanges the implementations of two methods.
    ///
    /// - Parameter m: ObjectiveC.Method to exchange.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func exchangeImplementation(_ m: Element) {
        method_exchangeImplementations(value, m)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func exchangeImplementation(_  m: Method) {
        method_exchangeImplementations(value, m.value)
    }
}

extension Method: CustomStringConvertible  {

    public var description: String {
        let descRep = getMethodDescription()
        let desc = """
            \(String(describing: descRep.name))
            \(String(describing: descRep.types))
            """
        return desc
    }
}

extension Method: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}
