# Flutter Testing Demo App

A comprehensive interactive Flutter testing teaching application with 5 chapters covering all testing concepts.

## Features

- **5 Interactive Chapters** covering Flutter testing concepts
- **Riverpod** state management
- **Thai Language UI** for better accessibility in Thailand
- **Real Working Tests** in the test directory
- **Material 3 Design** with green accent theme
- **Interactive Demo Screens** for hands-on learning

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart     # Home screen with chapter navigation
│   ├── ch1_unit_test_screen.dart      # Unit Test chapter
│   ├── ch2_widget_test_screen.dart    # Widget Testing chapter
│   ├── ch3_integration_test_screen.dart # Integration Testing chapter
│   ├── ch4_mocking_screen.dart        # Mocking & Faking chapter
│   └── ch5_ci_cd_screen.dart          # CI/CD & Coverage chapter
├── providers/
│   ├── test_runner_provider.dart      # Unit test runner with Riverpod
│   └── pipeline_provider.dart         # CI/CD pipeline simulator
├── services/
│   ├── calculator.dart      # Simple calculator for unit testing demo
│   └── api_service.dart     # API service with mocking demo
├── widgets/
│   └── counter_widget.dart  # Counter widget for widget testing
└── models/
    ├── test_result.dart     # Test result data model
    └── pipeline_stage.dart  # Pipeline stage data model

test/
├── unit/
│   ├── calculator_test.dart         # Calculator unit tests
│   └── api_service_test.dart        # API service tests with mocks
├── widget/
│   └── counter_widget_test.dart     # Counter widget tests
└── integration/
    └── app_flow_test.dart           # Full app integration tests
```

## Chapters Overview

### Chapter 1: Unit Test & Basics (บทที่ 1)
Learn the fundamentals of unit testing:
- Introduction to unit tests
- Testing calculator functions (add, subtract, multiply, divide)
- Test assertions and expectations
- Error handling in tests
- Interactive test runner UI

### Chapter 2: Widget Testing (บทที่ 2)
Master UI testing:
- Testing Flutter widgets
- Finding widgets using finders (find.byType, find.byKey, find.text)
- Simulating user interactions (tap, type)
- Verifying widget behavior
- Live counter widget demo

### Chapter 3: Integration Testing (บทที่ 3)
Test complete user flows:
- Multi-step integration tests
- Testing app workflows (Login → Dashboard → Settings → Logout)
- Progress tracking
- Flow diagram visualization

### Chapter 4: Mocking & Faking (บทที่ 4)
Mock external dependencies:
- Real API vs Mock API comparison
- Using mockito for mocking
- Controlling test data
- Benefits of mocking

### Chapter 5: CI/CD & Coverage (บทที่ 5)
Automate testing and deployment:
- CI/CD pipeline visualization
- Pipeline stages (Push → Lint → Tests → Build → Deploy)
- Code coverage reports
- Coverage metrics per file

## Getting Started

### Prerequisites
- Flutter SDK 3.16.0 or higher
- Dart 3.2.0 or higher

### Installation

1. Navigate to the project directory:
```bash
cd /sessions/nifty-peaceful-feynman/mnt/FLUTTER_AI/FLUTTER_TESTING_DEMO
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Running Tests

### Run all tests:
```bash
flutter test
```

### Run specific test file:
```bash
flutter test test/unit/calculator_test.dart
```

### Run tests with coverage:
```bash
flutter test --coverage
```

### Run widget tests only:
```bash
flutter test test/widget/
```

### Run unit tests only:
```bash
flutter test test/unit/
```

### Run integration tests:
```bash
flutter test test/integration/
```

## Test Files

### Unit Tests
- **calculator_test.dart** - Tests for Calculator class
  - Addition, subtraction, multiplication, division
  - Factorial calculation
  - Prime number checking

- **api_service_test.dart** - Tests for API service with mocks
  - Successful API calls
  - Error handling
  - HTTP client mocking

### Widget Tests
- **counter_widget_test.dart** - Tests for Counter widget
  - Initial state
  - Increment/decrement functionality
  - User interactions
  - Callbacks

### Integration Tests
- **app_flow_test.dart** - Full app workflow tests
  - Navigation between screens
  - Chapter access
  - UI element presence

## Services & Models

### Calculator Service
Simple calculator with basic operations:
- add(double a, double b)
- subtract(double a, double b)
- multiply(double a, double b)
- divide(double a, double b) - throws on division by zero
- factorial(int n)
- isPrime(int number)

### API Service
Mock API service for testing:
- fetchUser(int userId)
- fetchAllUsers()
- createUser(String name, String email)

Uses `http.Client` for easy mocking in tests.

### Riverpod Providers
- **testRunnerProvider** - Manages unit test execution state
- **pipelineProvider** - Manages CI/CD pipeline simulation
- **coverageProvider** - Provides coverage metrics

## Styling

- **Color Scheme:** Green accent (Material 3)
- **Theme:** Light and Dark modes supported
- **Language:** Thai (ไทย)
- **Design:** Modern Material Design 3

## Dependencies

- **flutter_riverpod** - State management
- **google_fonts** - Typography
- **flutter_highlight** - Code syntax highlighting
- **fl_chart** - Coverage visualization charts
- **http** - HTTP client for API service
- **mockito** - Mocking library for tests

## Learning Outcomes

After completing this demo app, you will understand:

1. ✅ How to write unit tests in Flutter
2. ✅ How to write widget tests for UI components
3. ✅ How to test complete user flows
4. ✅ How to mock external dependencies
5. ✅ How to set up CI/CD pipelines
6. ✅ How to measure code coverage
7. ✅ Best practices in Flutter testing

## Tips for Learning

1. **Start with Chapter 1** to understand test basics
2. **Run the interactive demos** to see concepts in action
3. **Read the code examples** shown in each chapter
4. **Modify and experiment** with the test files
5. **Run the tests** using `flutter test` command
6. **Check test output** to understand test results

## Troubleshooting

### Tests not running?
```bash
flutter clean
flutter pub get
flutter test
```

### Pub get issues?
```bash
flutter pub cache clean
flutter pub get
```

### Build issues?
```bash
flutter clean
flutter pub get
flutter run
```

## Performance Notes

- Green theme applied throughout for consistent branding
- Riverpod state management for efficient rebuilds
- Mock data for instant responses in demo screens
- Optimized list views with proper keys

## License

Educational demo application for teaching Flutter Testing concepts.

## Author

Created as an interactive teaching tool for Flutter Testing in Thailand.

---

**Happy Testing! สุขสันต์กับการทดสอบ! 🚀**
