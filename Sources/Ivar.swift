//
//  Ivar.swift
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

/// An class type that represents an instance variable.
final public class Ivar: Inspectable<ObjectiveC.Ivar> {
    
    /// Returns the name of an instance variable.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public lazy var name: String? = {
        let name = ivar_getName(self.value)
        return name != nil ? String(cString: name!) : nil
    }()
    
    /// Returns the offset of an instance variable.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public lazy var offset: Int = {
        return ivar_getOffset(self.value)
    }()
    
    /// Returns the type string of an instance variable.
    @available(iOS 2.0, macOS 10.5, tvOS 9.0, watchOS 2.0, *)
    public lazy var typeEncoding: String? = {
        let encode = ivar_getTypeEncoding(self.value)
        return encode != nil ? String(cString: encode!) : nil
    }()
}

extension Ivar: CustomStringConvertible {
    
    public var description: String {
        return """
            Ivar: \(String(describing: name))
            Encoding: \(String(describing: typeEncoding))
            Offset: \(offset)
            """
    }
}

extension Ivar: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}

