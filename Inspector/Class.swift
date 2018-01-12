//
//  Class.swift
//  Inspector
//
//

/// An class type that represents an Objective-C class.
final public class Class: Inspectable<Swift.AnyClass> {
    
    /**
     * Returns the class definition of a specified class.
     *
     * @param name The name of the class to look up.
     *
     * @return The Class object for the named class, or \c nil
     *  if the class is not registered with the Objective-C runtime.
     *
     * @note \c objc_getClass is different from \c objc_lookUpClass in that if the class
     *  is not registered, \c objc_getClass calls the class handler callback and then checks
     *  a second time to see whether the class is registered. \c objc_lookUpClass does
     *  not call the class handler callback.
     *
     * @warning Earlier implementations of this function (prior to OS X v10.0)
     *  terminate the program if the class does not exist.
     */
    @available(iOS 2.0, *)
    public func objc_getClass(_ name: UnsafePointer<Int8>) -> Any!
    
    /**
     * Returns the metaclass definition of a specified class.
     *
     * @param name The name of the class to look up.
     *
     * @return The \c Class object for the metaclass of the named class, or \c nil if the class
     *  is not registered with the Objective-C runtime.
     *
     * @note If the definition for the named class is not registered, this function calls the class handler
     *  callback and then checks a second time to see if the class is registered. However, every class
     *  definition must have a valid metaclass definition, and so the metaclass definition is always returned,
     *  whether it’s valid or not.
     */
    @available(iOS 2.0, *)
    public func objc_getMetaClass(_ name: UnsafePointer<Int8>) -> Any!
    
    /**
     * Returns the class definition of a specified class.
     *
     * @param name The name of the class to look up.
     *
     * @return The Class object for the named class, or \c nil if the class
     *  is not registered with the Objective-C runtime.
     *
     * @note \c objc_getClass is different from this function in that if the class is not
     *  registered, \c objc_getClass calls the class handler callback and then checks a second
     *  time to see whether the class is registered. This function does not call the class handler callback.
     */
    @available(iOS 2.0, *)
    public func objc_lookUpClass(_ name: UnsafePointer<Int8>) -> Swift.AnyClass?
    
    /**
     * Returns the class definition of a specified class.
     *
     * @param name The name of the class to look up.
     *
     * @return The Class object for the named class.
     *
     * @note This function is the same as \c objc_getClass, but kills the process if the class is not found.
     * @note This function is used by ZeroLink, where failing to find a class would be a compile-time link error without ZeroLink.
     */
    @available(iOS 2.0, *)
    public func objc_getRequiredClass(_ name: UnsafePointer<Int8>) -> Swift.AnyClass
    
    /**
     * Obtains the list of registered class definitions.
     *
     * @param buffer An array of \c Class values. On output, each \c Class value points to
     *  one class definition, up to either \e bufferCount or the total number of registered classes,
     *  whichever is less. You can pass \c NULL to obtain the total number of registered class
     *  definitions without actually retrieving any class definitions.
     * @param bufferCount An integer value. Pass the number of pointers for which you have allocated space
     *  in \e buffer. On return, this function fills in only this number of elements. If this number is less
     *  than the number of registered classes, this function returns an arbitrary subset of the registered classes.
     *
     * @return An integer value indicating the total number of registered classes.
     *
     * @note The Objective-C runtime library automatically registers all the classes defined in your source code.
     *  You can create class definitions at runtime and register them with the \c objc_addClass function.
     *
     * @warning You cannot assume that class objects you get from this function are classes that inherit from \c NSObject,
     *  so you cannot safely call any methods on such classes without detecting that the method is implemented first.
     */
    @available(iOS 2.0, *)
    public func objc_getClassList(_ buffer: AutoreleasingUnsafeMutablePointer<Swift.AnyClass>?, _ bufferCount: Int32) -> Int32
    
    /**
     * Creates and returns a list of pointers to all registered class definitions.
     *
     * @param outCount An integer pointer used to store the number of classes returned by
     *  this function in the list. It can be \c nil.
     *
     * @return A nil terminated array of classes. It must be freed with \c free().
     *
     * @see objc_getClassList
     */
    @available(iOS 3.1, *)
    public func objc_copyClassList(_ outCount: UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Swift.AnyClass>?
    
    /* Working with Classes */
    
    /**
     * Returns the name of a class.
     *
     * @param cls A class object.
     *
     * @return The name of the class, or the empty string if \e cls is \c Nil.
     */
    @available(iOS 2.0, *)
    public func class_getName(_ cls: Swift.AnyClass?) -> UnsafePointer<Int8>
    
    /**
     * Returns a Boolean value that indicates whether a class object is a metaclass.
     *
     * @param cls A class object.
     *
     * @return \c YES if \e cls is a metaclass, \c NO if \e cls is a non-meta class,
     *  \c NO if \e cls is \c Nil.
     */
    @available(iOS 2.0, *)
    public func class_isMetaClass(_ cls: Swift.AnyClass?) -> Bool
    
    /**
     * Returns the superclass of a class.
     *
     * @param cls A class object.
     *
     * @return The superclass of the class, or \c Nil if
     *  \e cls is a root class, or \c Nil if \e cls is \c Nil.
     *
     * @note You should usually use \c NSObject's \c superclass method instead of this function.
     */
    @available(iOS 2.0, *)
    public func class_getSuperclass(_ cls: Swift.AnyClass?) -> Swift.AnyClass?
    
    /**
     * Sets the superclass of a given class.
     *
     * @param cls The class whose superclass you want to set.
     * @param newSuper The new superclass for cls.
     *
     * @return The old superclass for cls.
     *
     * @warning You should not use this function.
     */
    
    /**
     * Returns the version number of a class definition.
     *
     * @param cls A pointer to a \c Class data structure. Pass
     *  the class definition for which you wish to obtain the version.
     *
     * @return An integer indicating the version number of the class definition.
     *
     * @see class_setVersion
     */
    @available(iOS 2.0, *)
    public func class_getVersion(_ cls: Swift.AnyClass?) -> Int32
    
    /**
     * Sets the version number of a class definition.
     *
     * @param cls A pointer to an Class data structure.
     *  Pass the class definition for which you wish to set the version.
     * @param version An integer. Pass the new version number of the class definition.
     *
     * @note You can use the version number of the class definition to provide versioning of the
     *  interface that your class represents to other classes. This is especially useful for object
     *  serialization (that is, archiving of the object in a flattened form), where it is important to
     *  recognize changes to the layout of the instance variables in different class-definition versions.
     * @note Classes derived from the Foundation framework \c NSObject class can set the class-definition
     *  version number using the \c setVersion: class method, which is implemented using the \c class_setVersion function.
     */
    @available(iOS 2.0, *)
    public func class_setVersion(_ cls: Swift.AnyClass?, _ version: Int32)
    
    /**
     * Returns the size of instances of a class.
     *
     * @param cls A class object.
     *
     * @return The size in bytes of instances of the class \e cls, or \c 0 if \e cls is \c Nil.
     */
    @available(iOS 2.0, *)
    public func class_getInstanceSize(_ cls: Swift.AnyClass?) -> Int
    
    /**
     * Returns the \c Ivar for a specified instance variable of a given class.
     *
     * @param cls The class whose instance variable you wish to obtain.
     * @param name The name of the instance variable definition to obtain.
     *
     * @return A pointer to an \c Ivar data structure containing information about
     *  the instance variable specified by \e name.
     */
    @available(iOS 2.0, *)
    public func class_getInstanceVariable(_ cls: Swift.AnyClass?, _ name: UnsafePointer<Int8>) -> Ivar?
    
    /**
     * Returns the Ivar for a specified class variable of a given class.
     *
     * @param cls The class definition whose class variable you wish to obtain.
     * @param name The name of the class variable definition to obtain.
     *
     * @return A pointer to an \c Ivar data structure containing information about the class variable specified by \e name.
     */
    @available(iOS 2.0, *)
    public func class_getClassVariable(_ cls: Swift.AnyClass?, _ name: UnsafePointer<Int8>) -> Ivar?
    
    /**
     * Describes the instance variables declared by a class.
     *
     * @param cls The class to inspect.
     * @param outCount On return, contains the length of the returned array.
     *  If outCount is NULL, the length is not returned.
     *
     * @return An array of pointers of type Ivar describing the instance variables declared by the class.
     *  Any instance variables declared by superclasses are not included. The array contains *outCount
     *  pointers followed by a NULL terminator. You must free the array with free().
     *
     *  If the class declares no instance variables, or cls is Nil, NULL is returned and *outCount is 0.
     */
    @available(iOS 2.0, *)
    public func class_copyIvarList(_ cls: Swift.AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Ivar>?
    
    /**
     * Returns a specified instance method for a given class.
     *
     * @param cls The class you want to inspect.
     * @param name The selector of the method you want to retrieve.
     *
     * @return The method that corresponds to the implementation of the selector specified by
     *  \e name for the class specified by \e cls, or \c NULL if the specified class or its
     *  superclasses do not contain an instance method with the specified selector.
     *
     * @note This function searches superclasses for implementations, whereas \c class_copyMethodList does not.
     */
    @available(iOS 2.0, *)
    public func class_getInstanceMethod(_ cls: Swift.AnyClass?, _ name: Selector) -> Method?
    
    /**
     * Returns a pointer to the data structure describing a given class method for a given class.
     *
     * @param cls A pointer to a class definition. Pass the class that contains the method you want to retrieve.
     * @param name A pointer of type \c SEL. Pass the selector of the method you want to retrieve.
     *
     * @return A pointer to the \c Method data structure that corresponds to the implementation of the
     *  selector specified by aSelector for the class specified by aClass, or NULL if the specified
     *  class or its superclasses do not contain an instance method with the specified selector.
     *
     * @note Note that this function searches superclasses for implementations,
     *  whereas \c class_copyMethodList does not.
     */
    @available(iOS 2.0, *)
    public func class_getClassMethod(_ cls: Swift.AnyClass?, _ name: Selector) -> Method?
    
    /**
     * Returns the function pointer that would be called if a
     * particular message were sent to an instance of a class.
     *
     * @param cls The class you want to inspect.
     * @param name A selector.
     *
     * @return The function pointer that would be called if \c [object name] were called
     *  with an instance of the class, or \c NULL if \e cls is \c Nil.
     *
     * @note \c class_getMethodImplementation may be faster than \c method_getImplementation(class_getInstanceMethod(cls, name)).
     * @note The function pointer returned may be a function internal to the runtime instead of
     *  an actual method implementation. For example, if instances of the class do not respond to
     *  the selector, the function pointer returned will be part of the runtime's message forwarding machinery.
     */
    @available(iOS 2.0, *)
    public func class_getMethodImplementation(_ cls: Swift.AnyClass?, _ name: Selector) -> IMP?
    
    /**
     * Returns the function pointer that would be called if a particular
     * message were sent to an instance of a class.
     *
     * @param cls The class you want to inspect.
     * @param name A selector.
     *
     * @return The function pointer that would be called if \c [object name] were called
     *  with an instance of the class, or \c NULL if \e cls is \c Nil.
     */
    @available(iOS 2.0, *)
    public func class_getMethodImplementation_stret(_ cls: Swift.AnyClass?, _ name: Selector) -> IMP?
    
    /**
     * Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
     *
     * @param cls The class you want to inspect.
     * @param sel A selector.
     *
     * @return \c YES if instances of the class respond to the selector, otherwise \c NO.
     *
     * @note You should usually use \c NSObject's \c respondsToSelector: or \c instancesRespondToSelector:
     *  methods instead of this function.
     */
    @available(iOS 2.0, *)
    public func class_respondsToSelector(_ cls: Swift.AnyClass?, _ sel: Selector) -> Bool
    
    /**
     * Describes the instance methods implemented by a class.
     *
     * @param cls The class you want to inspect.
     * @param outCount On return, contains the length of the returned array.
     *  If outCount is NULL, the length is not returned.
     *
     * @return An array of pointers of type Method describing the instance methods
     *  implemented by the class—any instance methods implemented by superclasses are not included.
     *  The array contains *outCount pointers followed by a NULL terminator. You must free the array with free().
     *
     *  If cls implements no instance methods, or cls is Nil, returns NULL and *outCount is 0.
     *
     * @note To get the class methods of a class, use \c class_copyMethodList(object_getClass(cls), &count).
     * @note To get the implementations of methods that may be implemented by superclasses,
     *  use \c class_getInstanceMethod or \c class_getClassMethod.
     */
    @available(iOS 2.0, *)
    public func class_copyMethodList(_ cls: Swift.AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Method>?
    
    /**
     * Returns a Boolean value that indicates whether a class conforms to a given protocol.
     *
     * @param cls The class you want to inspect.
     * @param protocol A protocol.
     *
     * @return YES if cls conforms to protocol, otherwise NO.
     *
     * @note You should usually use NSObject's conformsToProtocol: method instead of this function.
     */
    @available(iOS 2.0, *)
    public func class_conformsToProtocol(_ cls: Swift.AnyClass?, _ protocol: Protocol?) -> Bool
    
    /**
     * Describes the protocols adopted by a class.
     *
     * @param cls The class you want to inspect.
     * @param outCount On return, contains the length of the returned array.
     *  If outCount is NULL, the length is not returned.
     *
     * @return An array of pointers of type Protocol* describing the protocols adopted
     *  by the class. Any protocols adopted by superclasses or other protocols are not included.
     *  The array contains *outCount pointers followed by a NULL terminator. You must free the array with free().
     *
     *  If cls adopts no protocols, or cls is Nil, returns NULL and *outCount is 0.
     */
    @available(iOS 2.0, *)
    public func class_copyProtocolList(_ cls: Swift.AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?
    
    /**
     * Returns a property with a given name of a given class.
     *
     * @param cls The class you want to inspect.
     * @param name The name of the property you want to inspect.
     *
     * @return A pointer of type \c objc_property_t describing the property, or
     *  \c NULL if the class does not declare a property with that name,
     *  or \c NULL if \e cls is \c Nil.
     */
    @available(iOS 2.0, *)
    public func class_getProperty(_ cls: Swift.AnyClass?, _ name: UnsafePointer<Int8>) -> objc_property_t?
    
    /**
     * Describes the properties declared by a class.
     *
     * @param cls The class you want to inspect.
     * @param outCount On return, contains the length of the returned array.
     *  If \e outCount is \c NULL, the length is not returned.
     *
     * @return An array of pointers of type \c objc_property_t describing the properties
     *  declared by the class. Any properties declared by superclasses are not included.
     *  The array contains \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free().
     *
     *  If \e cls declares no properties, or \e cls is \c Nil, returns \c NULL and \c *outCount is \c 0.
     */
    @available(iOS 2.0, *)
    public func class_copyPropertyList(_ cls: Swift.AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?
    
    /**
     * Returns a description of the \c Ivar layout for a given class.
     *
     * @param cls The class to inspect.
     *
     * @return A description of the \c Ivar layout for \e cls.
     */
    @available(iOS 2.0, *)
    public func class_getIvarLayout(_ cls: Swift.AnyClass?) -> UnsafePointer<UInt8>?
    
    /**
     * Returns a description of the layout of weak Ivars for a given class.
     *
     * @param cls The class to inspect.
     *
     * @return A description of the layout of the weak \c Ivars for \e cls.
     */
    @available(iOS 2.0, *)
    public func class_getWeakIvarLayout(_ cls: Swift.AnyClass?) -> UnsafePointer<UInt8>?
    
    /**
     * Adds a new method to a class with a given name and implementation.
     *
     * @param cls The class to which to add a method.
     * @param name A selector that specifies the name of the method being added.
     * @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
     * @param types An array of characters that describe the types of the arguments to the method.
     *
     * @return YES if the method was added successfully, otherwise NO
     *  (for example, the class already contains a method implementation with that name).
     *
     * @note class_addMethod will add an override of a superclass's implementation,
     *  but will not replace an existing implementation in this class.
     *  To change an existing implementation, use method_setImplementation.
     */
    @available(iOS 2.0, *)
    public func class_addMethod(_ cls: Swift.AnyClass?, _ name: Selector, _ imp: IMP, _ types: UnsafePointer<Int8>?) -> Bool
    
    /**
     * Replaces the implementation of a method for a given class.
     *
     * @param cls The class you want to modify.
     * @param name A selector that identifies the method whose implementation you want to replace.
     * @param imp The new implementation for the method identified by name for the class identified by cls.
     * @param types An array of characters that describe the types of the arguments to the method.
     *  Since the function must take at least two arguments—self and _cmd, the second and third characters
     *  must be “@:” (the first character is the return type).
     *
     * @return The previous implementation of the method identified by \e name for the class identified by \e cls.
     *
     * @note This function behaves in two different ways:
     *  - If the method identified by \e name does not yet exist, it is added as if \c class_addMethod were called.
     *    The type encoding specified by \e types is used as given.
     *  - If the method identified by \e name does exist, its \c IMP is replaced as if \c method_setImplementation were called.
     *    The type encoding specified by \e types is ignored.
     */
    @available(iOS 2.0, *)
    public func class_replaceMethod(_ cls: Swift.AnyClass?, _ name: Selector, _ imp: IMP, _ types: UnsafePointer<Int8>?) -> IMP?
    
    /**
     * Adds a new instance variable to a class.
     *
     * @return YES if the instance variable was added successfully, otherwise NO
     *         (for example, the class already contains an instance variable with that name).
     *
     * @note This function may only be called after objc_allocateClassPair and before objc_registerClassPair.
     *       Adding an instance variable to an existing class is not supported.
     * @note The class must not be a metaclass. Adding an instance variable to a metaclass is not supported.
     * @note The instance variable's minimum alignment in bytes is 1<<align. The minimum alignment of an instance
     *       variable depends on the ivar's type and the machine architecture.
     *       For variables of any pointer type, pass log2(sizeof(pointer_type)).
     */
    @available(iOS 2.0, *)
    public func class_addIvar(_ cls: Swift.AnyClass?, _ name: UnsafePointer<Int8>, _ size: Int, _ alignment: UInt8, _ types: UnsafePointer<Int8>?) -> Bool
    
    /**
     * Adds a protocol to a class.
     *
     * @param cls The class to modify.
     * @param protocol The protocol to add to \e cls.
     *
     * @return \c YES if the method was added successfully, otherwise \c NO
     *  (for example, the class already conforms to that protocol).
     */
    @available(iOS 2.0, *)
    public func class_addProtocol(_ cls: Swift.AnyClass?, _ protocol: Protocol) -> Bool
    
    /**
     * Adds a property to a class.
     *
     * @param cls The class to modify.
     * @param name The name of the property.
     * @param attributes An array of property attributes.
     * @param attributeCount The number of attributes in \e attributes.
     *
     * @return \c YES if the property was added successfully, otherwise \c NO
     *  (for example, the class already has that property).
     */
    @available(iOS 4.3, *)
    public func class_addProperty(_ cls: Swift.AnyClass?, _ name: UnsafePointer<Int8>, _ attributes: UnsafePointer<objc_property_attribute_t>?, _ attributeCount: UInt32) -> Bool
    
    /**
     * Replace a property of a class.
     *
     * @param cls The class to modify.
     * @param name The name of the property.
     * @param attributes An array of property attributes.
     * @param attributeCount The number of attributes in \e attributes.
     */
    @available(iOS 4.3, *)
    public func class_replaceProperty(_ cls: Swift.AnyClass?, _ name: UnsafePointer<Int8>, _ attributes: UnsafePointer<objc_property_attribute_t>?, _ attributeCount: UInt32)
    
    /**
     * Sets the Ivar layout for a given class.
     *
     * @param cls The class to modify.
     * @param layout The layout of the \c Ivars for \e cls.
     */
    @available(iOS 2.0, *)
    public func class_setIvarLayout(_ cls: Swift.AnyClass?, _ layout: UnsafePointer<UInt8>?)
    
    /**
     * Sets the layout for weak Ivars for a given class.
     *
     * @param cls The class to modify.
     * @param layout The layout of the weak Ivars for \e cls.
     */
    @available(iOS 2.0, *)
    public func class_setWeakIvarLayout(_ cls: Swift.AnyClass?, _ layout: UnsafePointer<UInt8>?)
    
    /**
     * Used by CoreFoundation's toll-free bridging.
     * Return the id of the named class.
     *
     * @return The id of the named class, or an uninitialized class
     *  structure that will be used for the class when and if it does
     *  get loaded.
     *
     * @warning Do not call this function yourself.
     */
    
    /* Instantiating Classes */
    
    /**
     * Creates an instance of a class, allocating memory for the class in the
     * default malloc memory zone.
     *
     * @param cls The class that you wish to allocate an instance of.
     * @param extraBytes An integer indicating the number of extra bytes to allocate.
     *  The additional bytes can be used to store additional instance variables beyond
     *  those defined in the class definition.
     *
     * @return An instance of the class \e cls.
     */
    @available(iOS 2.0, *)
    public func class_createInstance(_ cls: Swift.AnyClass?, _ extraBytes: Int) -> Any?
    
    /**
     * Creates an instance of a class at the specific location provided.
     *
     * @param cls The class that you wish to allocate an instance of.
     * @param bytes The location at which to allocate an instance of \e cls.
     *  Must point to at least \c class_getInstanceSize(cls) bytes of well-aligned,
     *  zero-filled memory.
     *
     * @return \e bytes on success, \c nil otherwise. (For example, \e cls or \e bytes
     *  might be \c nil)
     *
     * @see class_createInstance
     */
    
    /**
     * Destroys an instance of a class without freeing memory and removes any
     * associated references this instance might have had.
     *
     * @param obj The class instance to destroy.
     *
     * @return \e obj. Does nothing if \e obj is nil.
     *
     * @note CF and other clients do call this under GC.
     */
    
    /* Adding Classes */
    
    /**
     * Creates a new class and metaclass.
     *
     * @param superclass The class to use as the new class's superclass, or \c Nil to create a new root class.
     * @param name The string to use as the new class's name. The string will be copied.
     * @param extraBytes The number of bytes to allocate for indexed ivars at the end of
     *  the class and metaclass objects. This should usually be \c 0.
     *
     * @return The new class, or Nil if the class could not be created (for example, the desired name is already in use).
     *
     * @note You can get a pointer to the new metaclass by calling \c object_getClass(newClass).
     * @note To create a new class, start by calling \c objc_allocateClassPair.
     *  Then set the class's attributes with functions like \c class_addMethod and \c class_addIvar.
     *  When you are done building the class, call \c objc_registerClassPair. The new class is now ready for use.
     * @note Instance methods and instance variables should be added to the class itself.
     *  Class methods should be added to the metaclass.
     */
    @available(iOS 2.0, *)
    public func objc_allocateClassPair(_ superclass: Swift.AnyClass?, _ name: UnsafePointer<Int8>, _ extraBytes: Int) -> Swift.AnyClass?
    
    /**
     * Registers a class that was allocated using \c objc_allocateClassPair.
     *
     * @param cls The class you want to register.
     */
    @available(iOS 2.0, *)
    public func objc_registerClassPair(_ cls: Swift.AnyClass)
    
    /**
     * Used by Foundation's Key-Value Observing.
     *
     * @warning Do not call this function yourself.
     */
    @available(iOS 2.0, *)
    public func objc_duplicateClass(_ original: Swift.AnyClass, _ name: UnsafePointer<Int8>, _ extraBytes: Int) -> Swift.AnyClass
    
    /**
     * Destroy a class and its associated metaclass.
     *
     * @param cls The class to be destroyed. It must have been allocated with
     *  \c objc_allocateClassPair
     *
     * @warning Do not call if instances of this class or a subclass exist.
     */
    @available(iOS 2.0, *)
    public func objc_disposeClassPair(_ cls: Swift.AnyClass)
}

