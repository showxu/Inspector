//
//  Selector.swift
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

/// An class type that represents an Objective-C declared Selector
final public class Selector: Inspectable<ObjectiveC.Selector>  {
    
    /// Registers a method with the Objective-C runtime system, maps the method
    /// name to a selector, and returns the selector value.
    ///
    /// - Parameter name: A pointer to a C string. Pass the name of the method you wish to register.
    /// - Note You must register a method name with the Objective-C runtime system to obtain the
    ///     method’s selector before you can add the method to a class definition. If the method name
    ///     has already been registered, this function simply returns the selector.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public convenience init(register name: String) {
        self.init(sel_registerName(name.utf8CString.baseAddress!))
    }
    
    /// Registers a method name with the Objective-C runtime system.
    ///
    /// - Parameter str:  A pointer to a C string. Pass the name of the method you wish to register.
    /// - Note: The implementation of this method is identical to the implementation of \c sel_registerName.
    /// - Note Prior to OS X version 10.0, this method tried to find the selector mapped to the given name
    ///     and returned \c NULL if the selector was not found. This was changed for safety, because it was
    ///     observed that many of the callers of this function did not check the return value for \c NULL.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public convenience init(uid str: String) {
        self.init(sel_getUid(str.utf8CString.baseAddress!))
    }
    
    /// Returns the name of the method specified by a given selector.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public var name: String {
        return String(cString: sel_getName(self.value))
    }
    
    /// Returns a Boolean value that indicates whether two selectors are equal.
    ///
    /// - Parameter other: The selector to compare with self.
    /// - Returns: \c YES if \e lhs and \e rhs are equal, otherwise \c NO.
    /// - Note: is equivalent to ==.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public func isEqual(to other: Element) -> Bool {
        return sel_isEqual(value, other)
    }
    
    /// Identifies a selector as being valid or invalid.
    @available(iOS 2.0, macOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public var isMapped: Bool {
        return sel_isMapped(value)
    }
}

extension Selector: ExpressibleByStringLiteral {
}

