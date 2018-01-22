//
//  Class.swift
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

import Foundation.NSObjCRuntime
import ObjectiveC.runtime

/// An class type that represents an Objective-C class.
final public class Class: Inspectable<Swift.AnyClass> {
    
    /// Returns the class definition of a specified class.
    ///
    /// - Parameter name: The name of the class to look up.
    /// - note \c objc_getClass is different from \c objc_lookUpClass in that if the class is not registered, \c objc_getClass calls the class handler callback and then checks a second time to see whether the class is registered. \c objc_lookUpClass does not call the class handler callback.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(_ name: String) {
        self.init(name, isMeta: false)
    }

    /// Returns the class/metaclass definition of a specified class.
    ///
    /// - Parameters:
    ///   - name: The name of the class to look up.
    ///   - isMeta: Specify the named class is meta or not
    /// - Note: \c objc_getClass is different from \c objc_lookUpClass in that if the class is not registered,
    ///     \c objc_getClass calls the class handler callback and then checks a second time to see whether
    ///     the class is registered. \c objc_lookUpClass does not call the class handler callback.
    /// - Note: If the definition for the named class is not registered, this function calls the class handler.
    ///     callback and then checks a second time to see if the class is registered. However, every class.
    ///     definition must have a valid metaclass definition, and so the metaclass definition is always returned,
    ///     whether it’s valid or not.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(_ name: String, isMeta: Bool) {
        let getCls: ((String) -> Element?) = {
            let cStr = $0.utf8CString.baseAddress!
            return (isMeta ? objc_getMetaClass(cStr) : objc_getClass(cStr)) as? Element
        }
        guard let cls = getCls(name) else {
            return nil
        }
        self.init(cls)
    }
    
    /// Returns the class definition of a specified class.
    ///
    /// - Parameter name: The name of the class to look up.
    /// - Returns: The Class object for the named class, or \c nil if the class
    ///     is not registered with the Objective-C runtime.
    /// - Note: \c objc_getClass is different from this function in that if the class is not
    ///     registered, \c objc_getClass calls the class handler callback and then checks a second
    ///     time to see whether the class is registered. This function does not call the class handler callback.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(lookUp name: String) {
        guard let cls = objc_lookUpClass(name.utf8CString.baseAddress!) else {
            return nil
        }
        self.init(cls)
    }
    
    /// Returns the class definition of a specified class.
    ///
    /// - Parameter name: The name of the class to look up.
    /// - Returns: The Class object for the named class.
    /// - Note: This function is the same as \c objc_getClass, but kills the process if the class is not found.
    /// - Note: This function is used by ZeroLink, where failing to find a class would be a compile-time link error without ZeroLink.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public convenience init(requiredClass name: String) {
        self.init(objc_getRequiredClass(name.utf8CString.baseAddress!))
    }
    
    /// Obtains the list of registered class definitions.
    ///
    /// - Returns: An integer value indicating the total number of registered classes.
    /// - Note: The Objective-C runtime library automatically registers all the classes defined in your source code.
    ///     You can create class definitions at runtime and register them with the \c objc_addClass function.
    /// - Warning: You cannot assume that class objects you get from this function are classes that inherit
    ///     from \c NSObject, so you cannot safely call any methods on such classes without detecting
    ///     that the method is implemented first.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public class func getClassList<T>(_ transform: (Element) throws -> T) rethrows -> [T]? {
        var outCount = UInt32(0)
        guard let list = objc_copyClassList(&outCount) else {
            return nil
        }
        var count = Int(outCount)
        do {
            var buffer = try Array(repeating: transform(list.pointee!), count: count)
            try autoreleasepool {
                while count >= 1 {
                    count -= 1
                    try buffer[count] = transform(list[count]!)
                }
            }
            return buffer
        } catch {
            throw error
        }
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public class func getClassList() -> [Element]? {
        return getClassList { $0 }
    }
    
    /// Returns the name of a class.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public lazy var name: String = {
        return String(cString: class_getName(self.value))
    }()
    
    /// Returns a Boolean value that indicates whether a class object is a metaclass.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public lazy var isMeta: Bool = {
        return class_isMetaClass(self.value)
    }()
    
    /// Returns the superclass of a class.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var superclass: Element? {
        return class_getSuperclass(value)
    }
    
    /// The version number of a class definition.
    ///
    /// - note You can use the version number of the class definition to provide versioning of the
    /// interface that your class represents to other classes. This is especially useful for object
    /// serialization (that is, archiving of the object in a flattened form), where it is important to
    /// recognize changes to the layout of the instance variables in different class-definition versions.
    /// - note Classes derived from the Foundation framework \c NSObject class can set the class-definition
    /// version number using the \c setVersion: class method, which is implemented using the \c class_setVersion function.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var version: Int32 {
        get {
            return class_getVersion(value)
        } set {
            class_setVersion(value, newValue)
        }
    }
    
    /// Returns the size of instances of a class.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var instanceSize: Int {
        return class_getInstanceSize(value)
    }
    
    /// Returns the \c Ivar for a specified instance variable of a given class.
    ///
    /// - Parameter name: The name of the instance variable definition to obtain.
    /// - Returns: Inspectable Ivar
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getInstanceVariable(_ name: String) -> Ivar? {
        return Ivar(class_getInstanceVariable(value, name.utf8CString.baseAddress!)!)
    }

    /// Returns the Ivar for a specified class variable of a given class.
    ///
    /// - Parameter name: The name of the class variable definition to obtain.
    /// - Returns: Inspectable Ivar
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getClassVariable(_ name: String) -> Ivar? {
        return Ivar(class_getClassVariable(value, name.utf8CString.baseAddress!)!)
    }
    
    /// Describes the instance variables declared by a class.
    ///
    /// - Returns: An array of pointers of type Ivar describing the instance variables declared by the class.
    ///   Any instance variables declared by superclasses are not included. The array contains *outCount
    ///   pointers followed by a NULL terminator. You must free the array with free().
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getIvarList() -> [Ivar]? {
        var outCount = UInt32(0)
        guard let list = class_copyIvarList(value, &outCount) else {
            return nil
        }
        defer {
            free(list)
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        while count >= 1 {
            count -= 1
            buffer[count] = list[count]
        }
        let ret = buffer.flatMap{ $0 }.map{ Ivar($0) }
        return ret
    }
    
    /// Returns a specified instance method for a given class.
    ///
    /// - Parameter name: The selector of the method you want to retrieve.
    /// - Returns: The method that corresponds to the implementation of the selector specified by
    ///   \e name for the class specified by \e cls, or \c NULL if the specified class or
    ///   its superclasses do not contain an instance method with the specified selector.
    /// - note This function searches superclasses for implementations, whereas \c class_copyMethodList does not.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getInstanceMethod(_ name: ObjectiveC.Selector) -> Method? {
        guard let m = class_getInstanceMethod(value, name) else {
            return nil
        }
        return Method(m)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getInstanceMethod(_ sel: Selector) -> Method? {
        return getInstanceMethod(sel.value)
    }
    
    /// Returns a pointer to the data structure describing a given class method for a given class.
    ///
    /// - Parameter name: A pointer of type \c SEL. Pass the selector of the method you want to retrieve.
    /// - Returns: Inspectable Method
    /// - note Note that this function searches superclasses for implementations,
    ///   whereas \c class_copyMethodList does not.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func getClassMethod(_ name: ObjectiveC.Selector) -> Method? {
        guard let m = class_getClassMethod(value, name) else {
            return nil
        }
        return Method(m)
    }
    
    /// Inspectable version of getClassMethod(_ name: ObjectiveC.Selector) -> Method?
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getClassMethod(_ sel: Selector) -> Method? {
        return getClassMethod(sel.value)
    }
    
    /// Returns the function pointer that would be called if a
    /// particular message were sent to an instance of a class.
    ///
    /// - Parameter name: A selector.
    /// - Returns: The function pointer that would be called if \c [object name] were called
    ///      with an instance of the class, or \c NULL if \e cls is \c Nil.
    /// - note \c class_getMethodImplementation may be faster than \c
    ///     method_getImplementation(class_getInstanceMethod(cls, name)).
    /// - @note The function pointer returned may be a function internal to the runtime instead of
    ///     an actual method implementation. For example, if instances of the class do not respond to
    ///     the selector, the function pointer returned will be part of the runtime's message forwarding machinery.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodImplementation(_ name: ObjectiveC.Selector) -> IMP? {
        guard let impl = class_getMethodImplementation(value, name) else {
            return nil
        }
        return IMP(impl)
    }
        
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodImplementation(_ sel: Selector) -> IMP? {
        return self.getMethodImplementation(sel.value)
    }
    
    /// Returns the function pointer that would be called if a particular
    /// message were sent to an instance of a class.
    ///
    /// - Parameter name: A selector.
    /// - Returns: The function pointer that would be called if \c [object name] were called
    ///     with an instance of the class, or \c NULL if \e cls is \c Nil.
    #if !(arch(arm) || arch(arm64))
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodImplementation(stret name: ObjectiveC.Selector) -> IMP? {
        guard let impl = class_getMethodImplementation_stret(value, name) else {
            return nil
        }
        return IMP(impl)
    }
    #endif
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodImplementation(stret sel: Selector) -> IMP? {
        return self.getMethodImplementation(sel.value)
    }
    
    /// Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
    ///
    /// - Parameter sel: A selector.
    /// - Returns: \c YES if instances of the class respond to the selector, otherwise \c NO.
    /// - Note: You should usually use \c NSObject's \c respondsToSelector: or \c instancesRespondToSelector:
    ///  methods instead of this function.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func respondsToSelector(_ sel: ObjectiveC.Selector) -> Bool {
        return class_respondsToSelector(value, sel)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func respondsToSelector(_ sel: Selector) -> Bool {
        return respondsToSelector(sel.value)
    }
    
    /// Describes the instance methods implemented by a class.
    ///
    /// - Returns: An array of pointers of type Method describing the instance methods
    ///     implemented by the class—any instance methods implemented by superclasses are not included.
    ///     The array contains *outCount pointers followed by a NULL terminator. You must free the array with free().
    /// - Note To get the class methods of a class, use \c class_copyMethodList(object_getClass(cls), &count).
    /// - Note To get the implementations of methods that may be implemented by superclasses,
    ///     use \c class_getInstanceMethod or \c class_getClassMethod.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getMethodList() -> [Method]? {
        var outCount = UInt32(0)
        guard let list = class_copyMethodList(value, &outCount) else {
            return nil
        }
        defer {
            free(list)
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        while count >= 1 {
            count -= 1
            buffer[count] = list[count]
        }
        let ret = buffer.flatMap{ $0 }.map{ Method($0) }
        return ret
    }
    
    /// Returns a Boolean value that indicates whether a class conforms to a given protocol.
    ///
    /// - Parameter protocol: A protocol.
    /// - Returns: YES if cls conforms to protocol, otherwise NO.
    /// - Note: You should usually use NSObject's conformsToProtocol: method instead of this function.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func conformsToProtocol(_ aProtocol: ObjectiveC.`Protocol`?) -> Bool {
        return class_conformsToProtocol(value, aProtocol)
    }
    
    /// Describes the protocols adopted by a class.
    ///
    /// - Returns: An array of pointers of type Protocol* describing the protocols adopted
    ///     by the class. Any protocols adopted by superclasses or other protocols are not included.
    ///     The array contains *outCount pointers followed by a NULL terminator. You must free the array with free().
    /// - Note: If cls adopts no protocols, or cls is Nil, returns NULL and *outCount is 0.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getProtocolList() -> [Protocol]? {
        var outCount = UInt32(0)
        guard let list = class_copyProtocolList(value, &outCount) else {
            return nil
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        while count >= 1 {
            count -= 1
            buffer[count] = list[count]
        }
        let ret = buffer.flatMap{ $0 }.map{ Protocol($0) }
        return ret
    }

    /// Returns a property with a given name of a given class.
    ///
    /// - Parameter name: The name of the property you want to inspect.
    /// - Returns: Inspectable property
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getProperty(_ name: String) -> Property? {
        guard let p = class_getProperty(value, name.utf8CString.baseAddress!) else {
            return nil
        }
        return Property(p)
    }
    
    /// Describes the properties declared by a class.
    ///
    /// - Returns: An array of pointers of type \c objc_property_t describing the properties
    ///     declared by the class. Any properties declared by superclasses are not included.
    ///     The array contains \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free().
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func getPropertyList() -> [Property]? {
        var outCount = UInt32(0)
        guard let list = class_copyPropertyList(value, &outCount) else {
            return nil
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        while count >= 1 {
            count -= 1
            buffer[count] = list[count]
        }
        let ret = buffer.flatMap{ $0 }.map{ Property($0) }
        return ret
    }
    
    ///  Ivar layout for a given class.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var ivarLayout: UnsafePointer<UInt8>? {
        get {
            return class_getIvarLayout(value)
        } set {
            class_setIvarLayout(value, newValue)
        }
    }

    /// Layout for weak Ivars for a given class.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public var weakIvarLayout: UnsafePointer<UInt8>? {
        get {
            return class_getWeakIvarLayout(value)
        } set {
            class_setWeakIvarLayout(value, newValue)
        }
    }
    
    /// Adds a new method to a class with a given name and implementation.
    ///
    /// - Parameters:
    ///   - name: A selector that specifies the name of the method being added.
    ///   - imp: A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
    ///   - types: An array of characters that describe the types of the arguments to the method.
    /// - Returns: YES if the method was added successfully, otherwise NO
    ///     (for example, the class already contains a method implementation with that name).
    /// - Note class_addMethod will add an override of a superclass's implementation,
    ///     but will not replace an existing implementation in this class.
    ///     To change an existing implementation, use method_setImplementation.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func addMethod(_ name: ObjectiveC.Selector,
                          imp: ObjectiveC.IMP,
                          types: String?) -> Bool {
        return class_addMethod(value, name, imp, types?.utf8CString.baseAddress)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func addMethod(_ sel: Selector,
                          imp: IMP,
                          types: String?) -> Bool {
        return addMethod(sel.value, imp: imp.value, types: types)
    }
    
    /// Replaces the implementation of a method for a given class.
    ///
    /// - Parameters:
    ///   - name: A selector that identifies the method whose implementation you want to replace.
    ///   - imp: The new implementation for the method identified by name for the class identified by cls.
    ///   - types: types An array of characters that describe the types of the arguments to the method.
    ///       Since the function must take at least two arguments—self and _cmd, the second and third characters
    ///       must be “@:” (the first character is the return type).
    /// - Returns: The previous implementation of the method identified by \e name for the class identified by \e cls.
    /// - Note:  This function behaves in two different ways:
    ///     - If the method identified by \e name does not yet exist, it is added as if \c class_addMethod were called.
    ///         The type encoding specified by \e types is used as given.
    ///     - If the method identified by \e name does exist, its \c IMP is replaced as if \c method_setImplementation were called.
    ///     The type encoding specified by \e types is ignored.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func replaceMethod(_ name: ObjectiveC.Selector,
                              imp: ObjectiveC.IMP,
                              types: String?) -> ObjectiveC.IMP? {
        return class_replaceMethod(value, name, imp, types?.utf8CString.baseAddress)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func replaceMethod(_ sel: Selector,
                              imp: IMP,
                              types: String?) -> IMP? {
        guard let impl = replaceMethod(sel.value, imp: imp.value, types: types) else {
            return nil
        }
        return IMP(impl)
    }
    
    /// Adds a new instance variable to a class.
    ///
    /// - Parameters:
    ///   - name: name
    ///   - size: size
    ///   - alignment: alignment
    ///   - types: types
    /// - Returns: YES if the instance variable was added successfully, otherwise NO
    ///     (for example, the class already contains an instance variable with that name).
    /// - Note This function may only be called after objc_allocateClassPair and before objc_registerClassPair.
    ///     Adding an instance variable to an existing class is not supported.
    /// - Note The class must not be a metaclass. Adding an instance variable to a metaclass is not supported.
    /// - Note The instance variable's minimum alignment in bytes is 1<<align. The minimum alignment of an instance
    ///     variable depends on the ivar's type and the machine architecture.
    ///     For variables of any pointer type, pass log2(sizeof(pointer_type)).
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func addIvar(_ name: String,
                        types: String) -> Bool {
        var size = 0
        var alignment = 0
        NSGetSizeAndAlignment(types.utf8CString.baseAddress!, &size, &alignment)
        return class_addIvar(value,
                             name.utf8CString.baseAddress!,
                             size,
                             UInt8(log2(Double(alignment))),
                             types.utf8CString.baseAddress)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func addIvar(_ ivar: Ivar) -> Bool {
        return addIvar(ivar.name!,
                       types: ivar.typeEncoding!)
    }
    
    /// Adds a protocol to a class.
    ///
    /// - Parameter aProtocol: The protocol to add to \e cls.
    /// - Returns: \c YES if the method was added successfully, otherwise \c NO
    ///     (for example, the class already conforms to that protocol).
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func addProtocol(_ aProtocol: ObjectiveC.`Protocol`) -> Bool {
        return class_addProtocol(value, aProtocol)
    }
    
    /// Adds a property to a class.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - attributes: An array of property attributes.
    ///   - attributeCount: The number of attributes in \e attributes.
    /// - Returns: \c YES if the property was added successfully, otherwise \c NO
    ///     (for example, the class already has that property).
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func addProperty(_ name: String,
                            attributes: [objc_property_attribute_t]?,
                            attributeCount: Int) -> Bool {
        return class_addProperty(value,
                                 name.utf8CString.baseAddress!,
                                 attributes?.baseAddress,
                                 UInt32(attributeCount))
    }
    
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public func addProperty(_ p: Property) -> Bool {
        return addProperty(p.name,
                           attributes: p.attributeList,
                           attributeCount: p.attributeList?.count ?? 0)
    }

    /// Replace a property of a class.
    ///
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - attributes: An array of property attributes.
    ///   - attributeCount: The number of attributes in \e attributes.
    @available(iOS 4.3, macOS 10.7, tvOS 9.0, watchOS 2.0, *)
    public func replaceProperty(_ name: String, _ attributes: UnsafePointer<objc_property_attribute_t>?, _ attributeCount: UInt32) {
        class_replaceProperty(value, name.utf8CString.baseAddress!, attributes, attributeCount)
    }
    
    /// Creates an instance of a class, allocating memory for the class in the
    /// default malloc memory zone.
    ///
    /// - Parameter extraBytes: An integer indicating the number of extra bytes to allocate.
    ///     The additional bytes can be used to store additional instance variables beyond
    ///     those defined in the class definition.
    /// - Returns: An instance of the class \e cls.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public func createInstance(_ extraBytes: Int) -> Any? {
        return class_createInstance(value, extraBytes)
    }
}

extension Class {
    
    public func subClass(depth: Int = 1) -> [Element] {
        let allClass = Class.getClassList()
        var buffer: [Element] = []
        
        allClass?.forEach { cls in
            var aCls: Element? = cls
            var depth = depth
            while aCls != nil && depth >= 1 {
                depth -= 1
                let superCls: AnyClass? = aCls?.superclass()
                if superCls == value {
                    buffer.append(cls)
                    break
                }
                aCls = superCls
            }
        }
        return buffer
    }
}

extension Class {
    
    /// Creates a new class and metaclass, or Nil if the class could not be created (for example, the desired name is already in use).
    ///
    /// - Parameters:
    ///   - superclass: The class to use as the new class's superclass, or \c Nil to create a new root class.
    ///   - name: The string to use as the new class's name. The string will be copied.
    ///   - extraBytes: The number of bytes to allocate for indexed ivars at the end of
    ///       the class and metaclass objects. This should usually be \c 0.
    /// - Note You can get a pointer to the new metaclass by calling \c object_getClass(newClass).
    /// - Note To create a new class, start by calling \c objc_allocateClassPair.
    ///     Then set the class's attributes with functions like \c class_addMethod and \c class_addIvar.
    ///     When you are done building the class, call \c objc_registerClassPair. The new class is now ready for use.
    /// - Note Instance methods and instance variables should be added to the class itself.
    ///     Class methods should be added to the metaclass.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public convenience init?(_ superclass: Swift.AnyClass?, _ name: String, _ extraBytes: Int) {
        guard let cls = objc_allocateClassPair(superclass, name.utf8CString.baseAddress!, extraBytes) else {
            return nil
        }
        self.init(cls)
    }
    
    /// Registers a class that was allocated using \c objc_allocateClassPair.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public func register() {
        objc_registerClassPair(value)
    }
    
    /// Used by Foundation's Key-Value Observing.
    ///
    /// - Parameters:
    ///   - name: Name of new class
    ///   - extraBytes: extraBytes
    /// - Returns: Duplicated class
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public func duplicate(_ name: String, _ extraBytes: Int) -> Element {
        return objc_duplicateClass(value, name.utf8CString.baseAddress!, extraBytes)
    }
    
    /// Destroy a class and its associated metaclass.
    ///
    /// - Note: The class to be destroyed. It must have been allocated with
    ///     \c objc_allocateClassPair
    /// - Warning: Do not call if instances of this class or a subclass exist.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public func dispose() {
        objc_disposeClassPair(value)
    }
}

