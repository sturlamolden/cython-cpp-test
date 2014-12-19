
# Using a pxd file gives us a separate namespace for
# the C++ declarations

cdef extern from "testclass.h":

    cppclass TestClass:
        int x,y
        TestClass() except +  # NB! std::bad_alloc will be converted to MemoryError
        int Multiply(int a, int b)





