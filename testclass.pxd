
# Using a .pxd file gives us a separate namespace for
# the C++ declarations. Using a .pxd file also allows
# us to reuse the declaration in multiple .pyx modules.

cdef extern from "testclass.h":

    cppclass TestClass:
        int x,y
        TestClass() except +  # NB! std::bad_alloc will be converted to MemoryError
        int Multiply(int a, int b)





