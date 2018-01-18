//
//  IMP.swift
//  Inspector
//
//

import ObjectiveC.objc
import ObjectiveC.runtime

final public class IMP: Inspectable<ObjectiveC.IMP>, ExpressibleByBlockLiteral {
}

extension IMP: CustomStringConvertible, CustomDebugStringConvertible {
}
