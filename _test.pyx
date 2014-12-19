
# distutils: language = c++
# distutils: sources = testclass.cpp


from testclass cimport TestClass
from pytestclass import PyTestClass


def test_the_cppclass():
    """
    Testing the class directly. This is rather dangerous style.
    Notice all the cruft we need to avoid memory leaks. Any C++
    or Python exception can separate the C++ object allocation
    and deallocation. If you use this style it will be very easy
    to create memory leaks. In a program more complicated than this
    trivial code it might be easy to loose track of every possible
    scenario. I.e. Never program like this! It is for the same 
    reason RAII is the preferred style in C++.
    """
   
    cdef TestClass *T
    
    T = new TestClass() # might raise MemoryError
   
    # the MemoryError must be raised outside the 
    # try-finally block where we actually do something
    # with the C++ object
    
    try:
        T.x = 15   # might raise ValueError
        print(T.x) # might e.g. raise ValueError, AttribueError, IOError...
    finally:
        # we need this finally block to ensure del is called
        # even if an exception is raised
        del T
                
            
def test_memory_leak():
    """
    This shows that we can produce a memory leak if
    del is not called on the C++ object. That is, Cython does
    not help us with garbage collection of C++ classes.
    """
    cdef TestClass *T = new TestClass()
        
        
def test_the_wrapped_class():
    """
    Here we wrap the C++ class with an extension class.
    We do not any longer have to worry about memory leaks,
    but the Python GC decides when the C++ object is 
    reclaimed. Also, your Cython code should not rely on a 
    particular GC implementation. If you have a reference
    cycle object destruction will not happen deterministically 
    even with the current CPython.
    """
    T = PyTestClass()
    T.x = 15
    print(T.x)
    T = None
    
        
def test_as_context_manager():
    """
    Here we wrap the C++ class with an extension class that
    supports the context manager protocol. This gives us full 
    RAII-like control over the lifetime of the C++ object. 
    The Python GC only decides when the extension object is 
    reclaimed. The lifetime of the C++ object is manually 
    controlled.
    """
    
    with PyTestClass() as T:
        T.x = 15
        print(T.x)


def test_with_raii():
    """
    Putting the C++ on the stack allows us to precisely control the
    lifetime of the C++ object, but Cython does not yet (as of 0.21)
    support C++ objects as context managers, so the RAII capabilities
    are currenty somewhat limited compared to C++, unless we wrap the
    C++ class with an extension object. This is also safe against
    memory leaks.
    """
    
    # Cython does not support "cdef TestClass T()" so it 
    # is not possible to pass arguments to the constructor
    cdef TestClass T   
    
    # We can also use a pointer
    cdef TestClass *pT = &T
    
    ## Cython generates invalid C++ if you try this.
    ## References are still not implemented correctly.
    # cdef TestClass &rT = T
    
    # either
    T.x = 15
    print(T.x)
    
    # or 
    pT.x = 15
    print(pT.x)
    
    ## Not possible yet because references are incorrectly
    ## implemented
    # rT.x = 15
    # print(rT.x)

    ## In the future, Cython is planning to support this
    ## syntax or something similar, which will solve many of 
    ## the problems metioned above:  
    #
    #  cdef TestClass *T
    #  with new TestClass() as T:
    #     T.x = 15
    #     print(T.x)
    #
    #


