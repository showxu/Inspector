//
//  Selector.swift
//  Inspector
//
//

import ObjectiveC.runtime

/// An class type that represents an Objective-C declared Selector
final public class Selector: Inspectable<ObjectiveC.Selector>  {
    
    public override init(_ value: Element) {
        super.init(value)
    }
    
    /// Returns the name of the method specified by a given selector.
    @available(OSX 10.0, *)
    public lazy var name: String = {
        return String(cString: sel_getName(self.value))
    }()
    
    /// Registers a method with the Objective-C runtime system, maps the method
    /// name to a selector, and returns the selector value.
    ///
    /// - Parameter name: A pointer to a C string. Pass the name of the method you wish to register.
    /// - Note You must register a method name with the Objective-C runtime system to obtain the
    ///     method’s selector before you can add the method to a class definition. If the method name
    ///     has already been registered, this function simply returns the selector.
    @available(OSX 10.0, *)
    public convenience init(register name: String) {
        self.init(sel_registerName(name.cString))
    }
    
    /// Registers a method name with the Objective-C runtime system.
    ///
    /// - Parameter str:  A pointer to a C string. Pass the name of the method you wish to register.
    /// - Note: The implementation of this method is identical to the implementation of \c sel_registerName.
    /// - Note Prior to OS X version 10.0, this method tried to find the selector mapped to the given name
    ///     and returned \c NULL if the selector was not found. This was changed for safety, because it was
    ///     observed that many of the callers of this function did not check the return value for \c NULL.
    @available(OSX 10.0, *)
    public convenience init(uid str: String) {
        self.init(sel_getUid(str.cString))
    }

    /// Returns a Boolean value that indicates whether two selectors are equal.
    ///
    /// - Parameter other: The selector to compare with self.
    /// - Returns: \c YES if \e lhs and \e rhs are equal, otherwise \c NO.
    /// - Note: is equivalent to ==.
    @available(OSX 10.5, *)
    public func isEqual(to other: Element) -> Bool {
        return sel_isEqual(value, other)
    }
    
    /// Identifies a selector as being valid or invalid.
    @available(OSX 10.0, *)
    public var isMapped: Bool {
        return sel_isMapped(value)
    }
}

extension Selector: Equatable, Hashable {
    
    public static func ==(lhs: Selector, rhs: Selector) -> Bool {
        return lhs.value == rhs.value
    }
    
    public var hashValue: Int {
        return value.hashValue
    }
}
