/// Simple Calculator service for unit testing demonstration
class Calculator {
  /// Add two numbers
  double add(double a, double b) => a + b;

  /// Subtract b from a
  double subtract(double a, double b) => a - b;

  /// Multiply two numbers
  double multiply(double a, double b) => a * b;

  /// Divide a by b - throws ArgumentError if b is 0
  double divide(double a, double b) {
    if (b == 0) throw ArgumentError('ไม่สามารถหารด้วยศูนย์');
    return a / b;
  }

  /// Calculate the square of a number
  double square(double a) => a * a;

  /// Calculate factorial
  int factorial(int n) {
    if (n < 0) throw ArgumentError('ต้องเป็นตัวเลขบวก');
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
  }

  /// Check if a number is prime
  bool isPrime(int number) {
    if (number < 2) return false;
    for (int i = 2; i <= number ~/ 2; i++) {
      if (number % i == 0) return false;
    }
    return true;
  }
}
