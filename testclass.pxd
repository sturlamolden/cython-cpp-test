
cdef extern from "testclass.h":

    cppclass TestClass:
        int x,y
        TestClass() except +
        int Multiply(int a, int b)

        


        