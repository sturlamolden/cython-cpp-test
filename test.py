
from _test import *

print("\n\n")

print("testing the class directly")
test_the_cppclass()
print("\n")

print("trying to create a memory leak")
test_memory_leak()
print("Did it work?")
print("\n")

print("testing the wrapped class")
test_the_wrapped_class()
print("\n")

print("testing the wrapped class as context manager")
test_as_context_manager()
print("\n")

print("testing with C++ object on the stack")
test_with_raii()
print("\n")


