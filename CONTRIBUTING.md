# Contributing to Queue Theory Calculator

First off, thank you for considering contributing to Queue Theory Calculator! 🎉

## 🌟 How Can I Contribute?

### Reporting Bugs 🐛

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected vs actual behavior**
- **Screenshots** if applicable
- **Environment details** (OS, browser, Flutter version, etc.)

**Template:**
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- Platform: [Mobile/Web]
- OS: [e.g., Android 13, iOS 16, Windows 11]
- Version: [e.g., 1.0.2]
```

### Suggesting Features 💡

Feature requests are welcome! Please include:

- **Clear description** of the feature
- **Use case** - why this feature is useful
- **Possible implementation** approach (optional)
- **Examples** from other apps (optional)

### Pull Requests 🚀

1. **Fork the repo** and create your branch from `main`
2. **Make your changes** with clear commit messages
3. **Test your changes** thoroughly
4. **Update documentation** if needed
5. **Submit the pull request**

#### PR Guidelines:

- One feature/fix per PR
- Follow existing code style
- Add tests for new features
- Update README.md if needed
- Keep commits atomic and well-described

**Good commit message:**
```
Add CSV export feature to web app

- Implemented export functionality in results page
- Added CSV generation utility
- Updated documentation
- Closes #123
```

**Bad commit message:**
```
Fixed stuff
```

## 💻 Development Setup

### Prerequisites

```bash
# Flutter (for mobile)
flutter --version  # Should be 3.0+

# Python (for scripts)
python --version   # Should be 3.6+

# Git
git --version
```

### Local Development

1. **Clone your fork:**
```bash
git clone https://github.com/YOUR_USERNAME/queue-theory-calculator.git
cd queue-theory-calculator
```

2. **Create a branch:**
```bash
git checkout -b feature/your-feature-name
```

3. **Set up development environment:**

**For Mobile:**
```bash
cd mobile
flutter pub get
flutter run
```

**For Web:**
```bash
cd web
# Open index.html in browser or use local server
python -m http.server 8000
```

**For Python:**
```bash
cd python
pip install -r requirements.txt
python simple_calculator.py
```

4. **Make your changes and test:**
```bash
# Flutter tests
cd mobile && flutter test

# Python tests  
cd python && pytest
```

5. **Commit and push:**
```bash
git add .
git commit -m "Your descriptive commit message"
git push origin feature/your-feature-name
```

6. **Create Pull Request** on GitHub

## 📝 Code Style Guide

### Flutter/Dart

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter format .` before committing
- Maximum line length: 80 characters
- Use meaningful variable names
- Add comments for complex logic

**Example:**
```dart
// Good
class QueueCalculator {
  final double arrivalRate;
  final double serviceRate;
  
  QueueCalculator({
    required this.arrivalRate,
    required this.serviceRate,
  });
  
  /// Calculates optimal staffing based on target wait time
  int calculateOptimalStaff(double targetWaitMinutes) {
    // Implementation
  }
}

// Bad
class QC {
  var a;
  var s;
  
  int calc(var t) {
    // Implementation
  }
}
```

### Python

- Follow [PEP 8](https://pep8.org/)
- Use `black` for formatting
- Add type hints
- Document functions with docstrings

**Example:**
```python
# Good
def calculate_wait_time(
    arrival_rate: float,
    service_rate: float,
    num_servers: int
) -> float:
    """
    Calculate average wait time using Erlang C formula.
    
    Args:
        arrival_rate: Customers arriving per hour
        service_rate: Customers served per hour per server
        num_servers: Number of servers available
        
    Returns:
        Average wait time in minutes
    """
    # Implementation
    pass

# Bad
def calc(a, s, n):
    # Implementation
    pass
```

### JavaScript/HTML/CSS

- Use ES6+ features
- Consistent indentation (2 spaces)
- Meaningful variable names
- Comments for complex logic

**Example:**
```javascript
// Good
const calculateOptimalStaffing = (arrivalRate, serviceRate, targetWait) => {
  const minServers = Math.ceil(arrivalRate / serviceRate);
  // ... more logic
  return optimalStaffing;
};

// Bad
function calc(a,s,t) {
  var x = a/s;
  return x;
}
```

## 🧪 Testing Guidelines

### What to Test

- All new features
- Bug fixes
- Edge cases
- Error handling

### Writing Tests

**Flutter:**
```dart
testWidgets('Calculator shows results after calculation', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Enter values
  await tester.enterText(find.byKey(Key('arrivalRate')), '40');
  await tester.enterText(find.byKey(Key('serviceRate')), '20');
  
  // Tap calculate
  await tester.tap(find.byKey(Key('calculateButton')));
  await tester.pump();
  
  // Verify results shown
  expect(find.text('Optimal Staffing'), findsOneWidget);
});
```

**Python:**
```python
def test_calculate_minimum_servers():
    """Test minimum server calculation"""
    model = QueueTheoryStaffing(arrival_rate=40, service_rate=20)
    assert model.calculate_minimum_servers() == 2

def test_invalid_input_raises_error():
    """Test that invalid input raises appropriate error"""
    with pytest.raises(ValueError):
        model = QueueTheoryStaffing(arrival_rate=-10, service_rate=20)
```

## 📚 Documentation

### Code Documentation

- Add comments for complex algorithms
- Document public APIs
- Include usage examples

### README Updates

Update README.md if you:
- Add new features
- Change installation steps
- Modify architecture
- Add dependencies

### API Documentation

If adding API endpoints, document:
- Endpoint URL
- HTTP method
- Request parameters
- Response format
- Example usage
- Error codes

## 🎯 Priority Areas

We especially need help with:

1. **Testing** - More unit and integration tests
2. **iOS Support** - iOS-specific testing and fixes
3. **Internationalization** - Translations to other languages
4. **Performance** - Optimization for large datasets
5. **Documentation** - Tutorials, guides, examples
6. **UI/UX** - Design improvements and accessibility

## 🤝 Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior includes:**
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

## 📞 Getting Help

- **Questions?** Open a [Discussion](https://github.com/yourusername/queue-theory-calculator/discussions)
- **Bug?** Open an [Issue](https://github.com/yourusername/queue-theory-calculator/issues)
- **Want to chat?** Join our [Discord/Slack] (if you create one)

## 🎉 Recognition

Contributors will be:
- Listed in README.md
- Mentioned in release notes
- Given credit in commit messages
- Thanked profusely! 🙏

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! Every contribution, no matter how small, is valuable and appreciated. 💚
