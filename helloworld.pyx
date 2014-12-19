
# distutils: language = c++
# distutils: sources = testclass.cpp


from testclass cimport TestClass


cdef class PyTestClass:

    cdef:
        TestClass *_thisptr

    def __cinit__(PyTestClass self):
        self._thisptr = NULL
        
    def __init__(PyTestClass self):
        self._thisptr = new TestClass()

    def __dealloc__(PyTestClass self):
        if self._thisptr:
            del self._thisptr
            
    cdef int _check_alive(PyTestClass self) except -1:
        if self._thisptr == NULL:
            raise ValueError("C++ object is deleted")
        else:
            return 0    

    property x:
        
        def __get__(PyTestClass self):
            self._check_alive()
            return self._thisptr.x
        
        def __set__(PyTestClass self, value):
            self._check_alive()
            self._thisptr.x = <int> value

    property y:
    
        def __get__(PyTestClass self):
            self._check_alive()
            return self._thisptr.y
    
        def __set__(PyTestClass self, value):
            self._check_alive()
            self._thisptr.y = <int> value

    def __enter__(PyTestClass self):
        self._check_alive()
        return self
    
    def __exit__(PyTestClass self, exc_tp, exc_val, exc_tb):
        if self._thisptr:
            del self._thisptr 
            self._thisptr = NULL



def test_the_class():
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


    


