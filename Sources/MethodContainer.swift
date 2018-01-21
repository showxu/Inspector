//
//  MethodContainer.swift
//  Inspector
//
//

import ObjectiveC.runtime

public protocol MethodContainer {
    
}

extension MethodContainer where Self: InspectableProtocol, Self.Element == ObjectiveC.Method {
    
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
