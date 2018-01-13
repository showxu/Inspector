//
//  Object.swift
//  Inspector
//
//

import ObjectiveC.runtime

final class Object: Inspectable<Any> {

    /// Returns the class of an object.
    @available(OSX 10.5, *)
    public var `class`: Class? {
        guard let cls = object_getClass(value) else {
            return nil
        }
        return Class(cls)
    }

    /// Sets the class of an object.
    ///
    /// - Parameter cls:  A class object.
    /// - Returns: The previous value of \e object's class, or \c Nil if \e object is \c nil.
    @available(OSX 10.5, *)
    public func setClass(_ cls: Swift.AnyClass) -> Swift.AnyClass? {
        return object_setClass(value, cls)
    }
    
    @available(OSX 10.5, *)
    public func setClass(_ cls: Class) -> Class? {
        guard let `class` = setClass(cls.value) else {
            return nil
        }
        return Class(`class`)
    }
    
    /// Returns whether an object is a class object.
    @available(OSX 10.10, *)
    public lazy var isClass: Bool = {
        object_isClass(self.value)
    }()
    
    /// Reads the value of an instance variable in an object.
    ///
    /// - Parameter ivar: The Ivar describing the instance variable whose value you want to read.
    /// - Returns: The value of the instance variable specified by \e ivar, or \c nil if \e object is \c nil.
    /// - Note: \c object_getIvar is faster than \c object_getInstanceVariable if the Ivar
    ///     for the instance variable is already known.
    @available(OSX 10.5, *)
    @inline(__always)
    public func getIvar(_ ivar: ObjectiveC.Ivar) -> Any? {
        return object_getIvar(value, ivar)
    }
    
    @available(OSX 10.5, *)
    public func getIvar(_ ivar: Ivar) -> Any? {
        return object_getIvar(value, ivar.value)
    }
    
    /// Sets the value of an instance variable in an object.
    ///
    /// - Parameters:
    ///   - ivar: The Ivar describing the instance variable whose value you want to set.
    ///   - value: The new value for the instance variable.
    /// - Note Instance variables with known memory management (such as ARC strong and weak)
    ///     use that memory management. Instance variables with unknown memory management
    ///     are assigned as if they were unsafe_unretained.
    /// - Note \c object_setIvar is faster than \c object_setInstanceVariable if the Ivar
    ///     for the instance variable is already known.
    @available(OSX 10.5, *)
    @inline(__always)
    public func setIvar(_ ivar: ObjectiveC.Ivar, value: Any?) {
        object_setIvar(self.value, ivar, value)
    }
    
    @available(OSX 10.5, *)
    public func setIvar(_ ivar: Ivar, value: Any?) {
        setIvar(ivar.value, value: value)
    }
    
    /// Sets the value of an instance variable in an object.
    ///
    /// - Parameters:
    ///   - ivar: The Ivar describing the instance variable whose value you want to set.
    ///   - value: The new value for the instance variable.
    /// - Note Instance variables with known memory management (such as ARC strong and weak)
    ///     use that memory management. Instance variables with unknown memory management
    ///     are assigned as if they were strong.
    /// - Note \c object_setIvar is faster than \c object_setInstanceVariable if the Ivar
    ///     for the instance variable is already known.
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
    @inline(__always)
    public func setIvar(strongDefault ivar: ObjectiveC.Ivar, _ value: Any?) {
        object_setIvarWithStrongDefault(value, ivar, value)
    }
    
    @available(OSX 10.12, *)
    public func setIvar(strongDefault ivar: Ivar, _ value: Any?) {
        setIvar(ivar.value, value: value)
    }
}
