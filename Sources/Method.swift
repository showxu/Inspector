//
//  Method.swift
//  Inspector
//
//

import ObjectiveC.runtime


/// An class type that represents an instance Method.
final public class Method: Inspectable<ObjectiveC.Method> {
    

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
