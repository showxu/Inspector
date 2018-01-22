//
//  Protocol.swift
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

/// An class type that represents an Objective-C declared property.
/// Type Inspectable<ObjectiveC.Protocol> is not available here cause the
/// .Property is built-in syntax 'foo.Protocol' expression
/// So we use ObjectiveC.`Protocol` instand
final public class Protocol: Inspectable<ObjectiveC.`Protocol`>  {
    
    /// Creates a new protocol instance that cannot be used until registered with \c objc_registerProtocol()
    ///
    /// - Parameter name: Protocol name
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(allocate name: String) {
        guard let p = objc_allocateProtocol(name.utf8CString.baseAddress!) else {
            return nil
        }
        self.init(p)
    }
    
    /// Returns a specified protocol.
    ///
    /// - Parameter name: The name of a protocol.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(_ name: String) {
        guard let p = objc_getProtocol(name.utf8CString.baseAddress!) else {
            return nil
        }
        self.init(p)
    }
    
    /// Returns a specified protocol, or creates a new protocol instance if no named protocol could be found.
    ///
    /// - Parameters:
    ///   - name: Protocol name
    ///   - allocate: If create a new protocol or not if no named protocol could be found.
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(_ name: String, allocate: Bool = false) {
        let str = name.utf8CString.baseAddress!
        var aProtocol = objc_getProtocol(str)
        if aProtocol != nil && allocate {
            aProtocol = objc_allocateProtocol(str)
        }
        guard let p = aProtocol else {
            return nil
        }
        self.init(p)
    }

    /// Returns an array of all the protocols known to the runtime.
    ///
    /// - Returns: A C array of all the protocols known to the runtime. The array contains
    ///     \c *outCount pointers followed by a \c NULL terminator. You must free the list with \c free().
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public class func getProtocolList() -> [Element]? {
        var outCount = UInt32(0)
        guard let list = objc_copyProtocolList(&outCount) else {
            return nil
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        autoreleasepool {
            while count >= 1 {
                count -= 1
                buffer[count] = list[count]
            }
        }
        return buffer
    }
    
    /// Returns a Boolean value that indicates whether one protocol conforms to another protocol.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func conforms(to other: Element?) -> Bool {
        return protocol_conformsToProtocol(value, other!)
    }
    
    /// Returns a Boolean value that indicates whether two protocols are equal.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func isEqual(to other: Element) -> Bool {
        return value == other
    }
    
    /// Returns the name of a protocol.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public lazy var name: String = {
        return String(cString: protocol_getName(self.value))
    }()
    
    /// Returns a method description structure for a specified method of a given protocol.
    ///
    /// - Parameters:
    ///   - aSel: A selector.
    ///   - isRequired: A Boolean value that indicates whether aSel is a required method.
    ///   - isInstance: A Boolean value that indicates whether aSel is an instance method.
    /// - Returns: An \c objc_method_description structure that describes the method specified by
    ///     \e aSel, \e isRequiredMethod, and \e isInstanceMethod for the protocol \e p.
    ///     If the protocol does not contain the specified method, returns an \c
    ///     objc_method_description structure with the value \c {NULL, \c NULL}.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodDescription(_ aSel: ObjectiveC.Selector,
                                     isRequired: Bool,
                                     isInstance: Bool) -> objc_method_description {
        return protocol_getMethodDescription(value, aSel, isRequired, isInstance)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodDescription(_ aSel: Selector,
                                     isRequired: Bool,
                                     isInstance: Bool) -> objc_method_description {
        return getMethodDescription(aSel.value,
                                    isRequired: isRequired,
                                    isInstance: isInstance)
    }
    
    /// Returns an array of method descriptions of methods meeting a given specification for a given protocol.
    ///
    /// - Parameters:
    ///   - isRequired: A Boolean value that indicates whether returned methods should be required methods (pass YES to specify required methods).
    ///   - isInstance: isInstanceMethod A Boolean value that indicates whether returned methods should be instance methods (pass YES to specify instance methods).
    /// - Returns: A C array of \c objc_method_description structures containing the names and types of \e p's methods specified by \e isRequiredMethod and \e isInstanceMethod. The array contains \c *outCount pointers followed by a \c NULL terminator. You must free the list with \c free(). If the protocol declares no methods that meet the specification, \c NULL is returned and \c *outCount is 0.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodDescriptionList(isRequired: Bool,
                                         isInstance: Bool) -> [objc_method_description]? {
        var outCount = UInt32(0)
        guard let list = protocol_copyMethodDescriptionList(self.value, isRequired, isInstance, &outCount) else {
            return nil
        }
        defer {
            free(list)
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        autoreleasepool {
            while count >= 1 {
                count -= 1
                buffer[count] = list[count]
            }
        }
        return buffer
    }
    
    /// Returns the specified property of a given protocol.
    ///
    /// - Parameters:
    ///   - name: The name of a property.
    ///   - isRequired: \c YES searches for a required property, \c NO searches for an optional property.
    ///   - isInstance: \c YES searches for an instance property, \c NO searches for a class property.
    /// - Returns: The property specified by \e name, \e isRequiredProperty, and \e isInstanceProperty for \e proto, or \c NULL if none of \e proto's properties meets the specification.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getProperty(_ name: String, isRequired: Bool, isInstance: Bool) -> objc_property_t? {
        return protocol_getProperty(value, Array(name.utf8CString), isRequired, isInstance)
    }
    
    /// Returns an array of the required instance properties declared by a protocol.
    ///
    /// - Returns: A C array of pointers of type \c objc_property_t describing the properties declared by \e proto. Any properties declared by other protocols adopted by this protocol are not included. The array contains \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free(). If the protocol declares no matching properties, \c NULL is returned and \c *outCount is \c 0.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getPropertyList() -> [objc_property_t]? {
        var outCount = UInt32(0)
        guard let list = protocol_copyPropertyList(value, &outCount) else {
            return nil
        }
        defer {
            free(list)
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        autoreleasepool {
            while count >= 1 {
                count -= 1
                buffer[count] = list[count]
            }
        }
        #if swift(>=4.0)
            return buffer
        #else
            return buffer.flatMap { $0 }
        #endif
    }
    
    /// Returns an array of properties declared by a protocol.
    ///
    /// - Parameters:
    ///   - isRequired: \c YES returns required properties, \c NO returns optional properties.
    ///   - isInstance: \c YES returns instance properties, \c NO returns class properties.
    /// - Returns: A C array of pointers of type \c objc_property_t describing the properties declared by \e proto.
    ///     Any properties declared by other protocols adopted by this protocol are not included. The array contains
    ///     \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free().
    ///     If the protocol declares no matching properties, \c NULL is returned and \c *outCount is \c 0.
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
    public func getPropertyList(isRequired: Bool,
                                isInstance: Bool) -> [objc_property_t]? {
        var outCount = UInt32(0)
        guard let list = protocol_copyPropertyList2(value, &outCount, isRequired, isInstance) else {
            return nil
        }
        defer {
            free(list)
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        autoreleasepool {
            while count >= 1 {
                count -= 1
                buffer[count] = list[count]
            }
        }
        #if swift(>=4.0)
            return buffer
        #else
            return buffer.flatMap { $0 }
        #endif
    }
    
    /// Returns an array of the protocols adopted by a protocol.
    ///
    /// - Returns: A C array of protocols adopted by \e proto. The array contains \e *outCount pointers followed
    ///     by a \c NULL terminator. You must free the array with \c free(). If the protocol declares no properties,
    ///     \c NULL is returned and \c *outCount is \c 0.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getProtocolList() -> [Element]? {
        var outCount = UInt32(0)
        guard let list = protocol_copyProtocolList(value, &outCount) else {
            return nil
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        autoreleasepool {
            while count >= 1 {
                count -= 1
                buffer[count] = list[count]
            }
        }
        return buffer
    }
    
    /// Registers a newly constructed protocol with the runtime. The protocol will be ready for use and is immutable after this.
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public func register() {
        objc_registerProtocol(value)
    }
    
    /// Adds a method to a protocol. The protocol must be under construction.
    ///
    /// - Parameters:
    ///   - name: The name of the method to add.
    ///   - types: A C string that represents the method signature.
    ///   - isRequired: YES if the method is not an optional method.
    ///   - isInstance: YES if the method is an instance method.
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func addMethodDescription(_ name: ObjectiveC.Selector,
                                     types: String?,
                                     isRequired: Bool,
                                     isInstance: Bool) {
        protocol_addMethodDescription(value, name, types?.utf8CString.baseAddress, isRequired, isInstance)
    }
    
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public func addMethodDescription(_ sel: Selector,
                                     types: String?,
                                     isRequired: Bool,
                                     isInstance: Bool) {
        addMethodDescription(sel.value, types: types, isRequired: isRequired, isInstance: isInstance)
    }
    
    /// Adds an incorporated protocol to another protocol. The protocol being added to must still be under construction, while the additional protocol must be already constructed.
    ///
    /// - Parameter addition: The protocol you want to incorporate into \e proto, it must be registered.
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public func addProtocol(_ addition: Element) {
        protocol_addProtocol(value, addition)
    }
    
    /// Adds a property to a protocol. The protocol must be under construction.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - attributes: An array of property attributes.
    ///   - attributeCount: The number of attributes in \e attributes.
    ///   - isRequired: YES if the property (accessor methods) is not optional.
    ///   - isInstance: YES if the property (accessor methods) are instance methods.
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public func addProperty(_ name: String,
                            attributes: UnsafePointer<objc_property_attribute_t>?,
                            attributeCount: UInt32,
                            isRequired: Bool,
                            isInstance: Bool) {
        protocol_addProperty(value, name, attributes, attributeCount, isRequired, isInstance)
    }
}

extension Protocol: ExpressibleByStringLiteral {
    
    public convenience init(stringLiteral value: String) {
        self.init(value, allocate: true)!
    }
} 

