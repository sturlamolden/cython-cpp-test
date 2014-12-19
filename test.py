
import helloworld

print("\n\n")

print("testing the class directly")
helloworld.test_the_class()
print("\n")

print("trying to create a memory leak")
helloworld.test_memory_leak()
print("Did it work?")
print("\n")

print("testing the wrapped class")
helloworld.test_the_wrapped_class()
print("\n")

print("testing the wrapped class as context manager")
helloworld.test_as_context_manager()
print("\n")

print("testing with C++ object on the stack")
helloworld.test_with_raii()
print("\n")

