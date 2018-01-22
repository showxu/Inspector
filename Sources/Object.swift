//
//  Object.swift
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

final class Object: Inspectable<Any> {

    /// Returns the class of an object.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
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
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func setClass(_ cls: Swift.AnyClass) -> Swift.AnyClass? {
        return object_setClass(value, cls)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func setClass(_ cls: Class) -> Class? {
        guard let `class` = setClass(cls.value) else {
            return nil
        }
        return Class(`class`)
    }
    
    /// Returns whether an object is a class object.
    @available(iOS 8.0, macOS 10.10, tvOS 9.0, watchOS 2.0, *)
    public lazy var isClass: Bool = {
        object_isClass(self.value)
    }()
    
    /// Reads the value of an instance variable in an object.
    ///
    /// - Parameter ivar: The Ivar describing the instance variable whose value you want to read.
    /// - Returns: The value of the instance variable specified by \e ivar, or \c nil if \e object is \c nil.
    /// - Note: \c object_getIvar is faster than \c object_getInstanceVariable if the Ivar
    ///     for the instance variable is already known.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func getIvar(_ ivar: ObjectiveC.Ivar) -> Any? {
        return object_getIvar(value, ivar)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
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
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    @inline(__always)
    public func setIvar(_ ivar: ObjectiveC.Ivar, value: Any?) {
        object_setIvar(self.value, ivar, value)
    }
    
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
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
    
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
    public func setIvar(strongDefault ivar: Ivar, _ value: Any?) {
        setIvar(ivar.value, value: value)
    }
}
