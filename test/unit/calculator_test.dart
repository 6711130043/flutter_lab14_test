import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_demo/services/calculator.dart';

void main() {
  group('Calculator', () {
    late Calculator calc;

    setUp(() {
      calc = Calculator();
    });

    group('Addition', () {
      test('should add two positive numbers', () {
        expect(calc.add(2, 3), equals(5));
      });

      test('should add negative numbers', () {
        expect(calc.add(-2, -3), equals(-5));
      });

      test('should add mixed positive and negative numbers', () {
        expect(calc.add(5, -3), equals(2));
      });

      test('should add zero', () {
        expect(calc.add(5, 0), equals(5));
      });
    });

    group('Subtraction', () {
      test('should subtract two numbers', () {
        expect(calc.subtract(5, 3), equals(2));
      });

      test('should handle negative result', () {
        expect(calc.subtract(3, 5), equals(-2));
      });

      test('should subtract from negative number', () {
        expect(calc.subtract(-5, 3), equals(-8));
      });
    });

    group('Multiplication', () {
      test('should multiply two positive numbers', () {
        expect(calc.multiply(3, 4), equals(12));
      });

      test('should multiply with negative numbers', () {
        expect(calc.multiply(-3, 4), equals(-12));
      });

      test('should multiply by zero', () {
        expect(calc.multiply(5, 0), equals(0));
      });

      test('should multiply decimal numbers', () {
        expect(calc.multiply(2.5, 4), equals(10));
      });
    });

    group('Division', () {
      test('should divide two numbers', () {
        expect(calc.divide(12, 3), equals(4));
      });

      test('should divide with decimal result', () {
        expect(calc.divide(10, 3), closeTo(3.333, 0.001));
      });

      test('should throw ArgumentError when dividing by zero', () {
        expect(
          () => calc.divide(5, 0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw with correct message', () {
        expect(
          () => calc.divide(10, 0),
          throwsA(
            predicate<ArgumentError>((e) => e.message.contains('ไม่สามารถหารด้วยศูนย์')),
          ),
        );
      });
    });

    group('Square', () {
      test('should calculate square of a positive number', () {
        expect(calc.square(4), equals(16));
      });

      test('should calculate square of a negative number', () {
        expect(calc.square(-3), equals(9));
      });

      test('should calculate square of zero', () {
        expect(calc.square(0), equals(0));
      });
    });

    group('Factorial', () {
      test('should calculate factorial of 5', () {
        expect(calc.factorial(5), equals(120));
      });

      test('should return 1 for factorial of 0', () {
        expect(calc.factorial(0), equals(1));
      });

      test('should return 1 for factorial of 1', () {
        expect(calc.factorial(1), equals(1));
      });

      test('should return 2 for factorial of 2', () {
        expect(calc.factorial(2), equals(2));
      });

      test('should throw for negative numbers', () {
        expect(
          () => calc.factorial(-1),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Prime Number Check', () {
      test('should return true for prime number 7', () {
        expect(calc.isPrime(7), isTrue);
      });

      test('should return true for prime number 2', () {
        expect(calc.isPrime(2), isTrue);
      });

      test('should return false for 4', () {
        expect(calc.isPrime(4), isFalse);
      });

      test('should return false for 1', () {
        expect(calc.isPrime(1), isFalse);
      });

      test('should return false for negative numbers', () {
        expect(calc.isPrime(-5), isFalse);
      });

      test('should return true for large prime', () {
        expect(calc.isPrime(97), isTrue);
      });

      test('should return false for large composite', () {
        expect(calc.isPrime(100), isFalse);
      });
    });
  });
}
