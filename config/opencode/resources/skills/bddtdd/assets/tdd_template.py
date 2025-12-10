
## tdd_template.py Content
```python
import pytest

# RED: Failing test stub (write this first)
def test_<behavior>_fails():
    # Arrange: Setup based on Given
    # <placeholder for setup, e.g., obj = SomeClass()>
    
    # Act: Based on When
    # <placeholder for action, e.g., result = obj.some_method()>
    
    # Assert: Based on Then (this should fail initially)
    assert False, "Implement to make this pass"  # Replace with actual assertion, e.g., assert result == expected

# GREEN: Minimal implementation to pass the test
class SomeClass:
    def some_method(self):
        return <minimal value to pass, e.g., expected>  # Keep minimal; no extras

# REFACTOR: Optimized version (keep tests green)
class SomeClass:
    def some_method(self):
        # Optimized logic here, e.g., with better structure or efficiency
        <refactored code>
        return expected
