
# Using a pxd file gives us a separate namespace for
# the C++ declarations

cdef extern from "testclass.h":

    cppclass TestClass:
        int x,y
        TestClass() except +MemoryError # autoconvert std::bad_alloc
        int Multiply(int a, int b)

        


