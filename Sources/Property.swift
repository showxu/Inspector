//
//  Property.swift
//  Inspector
//
//

import ObjectiveC

/// An class type that represents an Objective-C declared property.
final public class Property: Inspectable<ObjectiveC.objc_property_t> {
    
    /// Returns the name of a property.
    @available(OSX 10.5, *)
    public lazy var name: String = {
        return String(cString: property_getName(self.value))
    }()
 
    /// Returns the attribute string of a property.
    /// The format of the attribute string is described in Declared Properties in Objective-C Runtime Programming Guide.
    @available(OSX 10.5, *)
    public lazy var attributes: String? = {
        guard let attrs = property_getAttributes(self.value) else {
            return nil
        }
        return String(cString: attrs)
    }()
    
    /// Returns an array of property attributes for a property.
    @available(OSX 10.7, *)
    public var attributeList: [objc_property_attribute_t]? {
        var outCount: UInt32 = 0
        guard let list = property_copyAttributeList(value, &outCount) else {
            return nil
        }
        defer {
            free(list)
        }
        var count = Int(outCount)
        var buffer = Array(repeating: list.pointee, count: count)
        while count >= 0 {
            buffer[count] = list[count]
            count -= 1
        }
        return buffer
    }

    /// Returns the value of a property attribute given the attribute name.
    @available(OSX 10.7, *)
    public lazy var attributeValue: ((String) -> String?) = {
        return { [weak self] in
            guard
                self != nil,
                let value = property_copyAttributeValue(self!.value, $0.utf8CString.baseAddress!)
            else { return nil }
            defer {
                free(value)
            }
            return String(cString: value)
        }
    }()
}
