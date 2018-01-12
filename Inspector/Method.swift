//
//  Method.swift
//  Inspector
//
//

import ObjectiveC.runtime

/// An class type that represents an instance Method.
final public class Method: Inspectable<ObjectiveC.Method> {
    
    /// Returns the name of a method.
    public lazy var name: Selector = {
        return Selector(method_getName(self.value))
    }()
    
    /// Returns the implementation of a method.
    /// The implementation can be modified, so it can't be lazy.
    @available(OSX 10.5, *)
    public var implementation: IMP {
        return IMP(method_getImplementation(value))
    }

    /// Returns a string describing a method's parameter and return types.
    @available(OSX 10.5, *)
    public lazy var typeEncoding: String? = {
        let type = method_getTypeEncoding(self.value)
        return type != nil ? String(cString: type!) : nil
    }()
    
    /// Returns the number of arguments accepted by a method.
    @available(OSX 10.0, *)
    public lazy var numberOfArguments: UInt = {
        return UInt(method_getNumberOfArguments(self.value))
    }()
    
    /// Returns a string describing a method's return type.
    @available(OSX 10.5, *)
    public lazy var returnType: String = {
        #if swift(>=4.0)
            let type = method_copyReturnType(self.value)
        #else
            let type = method_copyReturnType(self.value)!
        #endif
        defer {
            free(type)
        }
        return String(cString: type)
    }()
    
    /// Returns a string describing a single parameter type of a method.
    @available(OSX 10.5, *)
    public lazy var argumentType: ((UInt) -> String?) = {
        return { [weak self] in
            precondition($0 < self?.numberOfArguments ?? 0)
            guard
                self != nil,
                let type = method_copyArgumentType(self!.value, UInt32($0))
            else { return nil }
            defer {
                free(type)
            }
            return String(cString: type)
        }
    }()
}

extension Method {
    
    @available(OSX 10.5, *)
    @inline(__always)
    final public func getMethodDescription() -> objc_method_description {
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
    @available(OSX 10.5, *)
    public func setImplementation(_ imp: ObjectiveC.IMP) -> ObjectiveC.IMP {
        return method_setImplementation(value, imp)
    }
    
    @available(OSX 10.5, *)
    public func setImplementation(_ imp: IMP) -> IMP {
        return IMP(setImplementation(imp.value))
    }

    /// Exchanges the implementations of two methods.
    ///
    /// - Parameter m: ObjectiveC.Method to exchange.
    @available(OSX 10.5, *)
    public func exchangeImplementation(_ m: Element) {
        method_exchangeImplementations(value, m)
    }
}

extension Method {
    
    /// Exchanges the implementations of two methods.
    ///
    /// - Parameter m: Method to exchange.
    @available(OSX 10.5, *)
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
