//
//  IMP.swift
//  Inspector
//
//

import ObjectiveC.objc
import ObjectiveC.runtime

final public class IMP: Inspectable<ObjectiveC.IMP>  {
    
    public override init(_ value: Element) {
        super.init(value)
    }

    ///  Creates a pointer to a function that will call the block
    ///  when the method is called.
    ///
    /// - Parameter block: The block that implements this method. Its signature should
    ///     be: method_return_type ^(id self, method_args...).
    ///     The selector is not available as a parameter to this block.
    ///     The block is copied with \c Block_copy().
    /// - Note: The IMP that calls this block. Must be disposed of with
    ///     \c imp_removeBlock.
    @available(OSX 10.7, *)
    public convenience init(block: Any) {
        #if swift(>=4.0)
        let impl = imp_implementationWithBlock(block)
        #else
        let impl = imp_implementationWithBlock(block)!
        #endif
        self.init(impl)
    }
    
    /// Return the block associated with an IMP that was created using
    /// \c imp_implementationWithBlock.
    @available(OSX 10.7, *)
    public var block: Any? {
        return imp_getBlock(value)
    }
    
    /// Disassociates a block from an IMP that was created using
    /// \c imp_implementationWithBlock and releases the copy of the
    /// block that was created.
    ///
    /// - Returns: YES if the block was released successfully, NO otherwise.
    ///     (For example, the block might not have been used to create an IMP previously).
    @available(OSX 10.7, *)
    public func removeBlock() -> Bool {
        return imp_removeBlock(value)
    }
}
