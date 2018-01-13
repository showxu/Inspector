//
//  String+Inspector.swift
//  Inspector
//
//

extension String {
    
    @_inlineable
    public var subString: Substring {
        return self[...]
    }
}
