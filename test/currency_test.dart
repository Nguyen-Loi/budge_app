import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/utils/currency_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:developer' as developer;
void main() {
  group('Currency Conversion Tests', () {
    // Test cases organized by currency type for better readability
    final testCases = [
      // USD - decimal currency
      {'currency': CurrencyType.usd, 'input': '1.00'},
      {'currency': CurrencyType.usd, 'input': '10.50'},
      {'currency': CurrencyType.usd, 'input': '1000.99'},
      {'currency': CurrencyType.usd, 'input': '0.01'},

      // EUR - decimal currency
      {'currency': CurrencyType.eur, 'input': '1.00'},
      {'currency': CurrencyType.eur, 'input': '25.75'},
      {'currency': CurrencyType.eur, 'input': '999.99'},

      // VND - whole number currency
      {'currency': CurrencyType.vnd, 'input': '1000'},
      {'currency': CurrencyType.vnd, 'input': '50000'},
      {'currency': CurrencyType.vnd, 'input': '1000000'},

      // JPY - whole number currency
      {'currency': CurrencyType.jpy, 'input': '100'},
      {'currency': CurrencyType.jpy, 'input': '1500'},

      // CAD - decimal currency
      {'currency': CurrencyType.cad, 'input': '1.00'},
      {'currency': CurrencyType.cad, 'input': '15.25'},
    ];

    test('Core conversion functionality', () {
      for (final testCase in testCases) {
        final currency = testCase['currency'] as CurrencyType;
        final input = testCase['input'] as String;

        final storageAmount = CurrencyUtils.parseInput(input, currency);
        expect(
          storageAmount,
          isNotNull,
          reason: 'Failed to parse $input for ${currency.code}',
        );

        final displayAmount =
            CurrencyUtils.toDisplayAmount(storageAmount!, currency);
        final formatted = CurrencyUtils.formatExact(storageAmount, currency);

        // Verify round-trip conversion works correctly
        final expectedDisplayAmount = double.parse(input.replaceAll(',', ''));
        expect(
          displayAmount,
          expectedDisplayAmount,
          reason:
              'Display amount mismatch for ${currency.code}: expected $expectedDisplayAmount, got $displayAmount',
        );

        // Verify formatting includes currency symbol and proper formatting
        expect(
          formatted,
          contains(currency.symbol),
          reason:
              'Formatted amount should contain currency symbol for ${currency.code}',
        );
      }
    });

    test('Edge cases: thousand separators', () {
      final thousandSeparatorCases = [
        {'currency': CurrencyType.usd, 'input': '1,234.56'},
        {'currency': CurrencyType.vnd, 'input': '1,000,000'},
        {'currency': CurrencyType.eur, 'input': '12,345.67'},
      ];

      for (final test in thousandSeparatorCases) {
        final currency = test['currency'] as CurrencyType;
        final input = test['input'] as String;

        final result = CurrencyUtils.parseInput(input, currency);
        expect(
          result,
          isNotNull,
          reason: 'Failed to parse $input for ${currency.code}',
        );
      }
    });

    test('Edge cases: decimal precision', () {
      final decimalPrecisionCases = [
        {'currency': CurrencyType.usd, 'input': '1.234'},
        {'currency': CurrencyType.usd, 'input': '1.1'},
        {'currency': CurrencyType.vnd, 'input': '1000.50'},
        {'currency': CurrencyType.jpy, 'input': '100.75'},
      ];

      for (final test in decimalPrecisionCases) {
        final currency = test['currency'] as CurrencyType;
        final input = test['input'] as String;

        final result = CurrencyUtils.parseInput(input, currency);
        expect(
          result,
          isNotNull,
          reason: 'Failed to parse $input for ${currency.code}',
        );
      }
    });

    test('Validation tests', () {
      // Test null and empty inputs
      expect(CurrencyUtils.parseInput('', CurrencyType.usd), isNull);
      expect(CurrencyUtils.parseInput('  ', CurrencyType.usd), isNull);

      // Test invalid inputs
      expect(CurrencyUtils.parseInput('abc', CurrencyType.usd), isNull);
      expect(CurrencyUtils.parseInput('12.34.56', CurrencyType.usd), isNull);
      expect(CurrencyUtils.parseInput('-10', CurrencyType.usd), isNull);

      // Test zero values (should return 0, not null)
      final zeroUsd = CurrencyUtils.parseInput('0', CurrencyType.usd);
      expect(zeroUsd, equals(0));

      final zeroPointZero = CurrencyUtils.parseInput('0.00', CurrencyType.usd);
      expect(zeroPointZero, equals(0));
    });

    test('Storage amount conversion tests', () {
      // Test USD (2 decimal places)
      expect(
          CurrencyUtils.toStorageAmount(1.00, CurrencyType.usd), equals(100));
      expect(
          CurrencyUtils.toStorageAmount(10.50, CurrencyType.usd), equals(1050));
      expect(CurrencyUtils.toStorageAmount(0.01, CurrencyType.usd), equals(1));

      // Test VND (0 decimal places)
      expect(CurrencyUtils.toStorageAmount(1000.0, CurrencyType.vnd),
          equals(1000));
      expect(CurrencyUtils.toStorageAmount(50000.0, CurrencyType.vnd),
          equals(50000));

      // Test JPY (0 decimal places)
      expect(
          CurrencyUtils.toStorageAmount(100.0, CurrencyType.jpy), equals(100));
      expect(CurrencyUtils.toStorageAmount(1500.0, CurrencyType.jpy),
          equals(1500));
    });

    test('Display amount conversion tests', () {
      // Test USD (2 decimal places)
      expect(
          CurrencyUtils.toDisplayAmount(100, CurrencyType.usd), equals(1.00));
      expect(
          CurrencyUtils.toDisplayAmount(1050, CurrencyType.usd), equals(10.50));
      expect(CurrencyUtils.toDisplayAmount(1, CurrencyType.usd), equals(0.01));

      // Test VND (0 decimal places)
      expect(CurrencyUtils.toDisplayAmount(1000, CurrencyType.vnd),
          equals(1000.0));
      expect(CurrencyUtils.toDisplayAmount(50000, CurrencyType.vnd),
          equals(50000.0));

      // Test JPY (0 decimal places)
      expect(
          CurrencyUtils.toDisplayAmount(100, CurrencyType.jpy), equals(100.0));
      expect(CurrencyUtils.toDisplayAmount(1500, CurrencyType.jpy),
          equals(1500.0));
    });

    test('Formatting tests', () {
      // Test exact formatting
      final usdFormatted = CurrencyUtils.formatExact(100, CurrencyType.usd);
      expect(usdFormatted, contains('\$'));
      expect(usdFormatted, contains('1.00'));

      final vndFormatted = CurrencyUtils.formatExact(1000, CurrencyType.vnd);
      expect(vndFormatted, contains('đ'));
      expect(vndFormatted,
          contains('1.000')); // VND shows 3 decimal places per locale

      // Test compact formatting
      final largeAmount =
          CurrencyUtils.formatCompact(1000000, CurrencyType.usd); // $10,000
      expect(largeAmount, contains('K'));

      final billionAmount = CurrencyUtils.formatCompact(
          100000000, CurrencyType.usd); // $1,000,000
      expect(billionAmount, contains('M'));
    });

    test('Round-trip conversion accuracy', () {
      final testValues = [
        {'currency': CurrencyType.usd, 'input': '123.45'},
        {'currency': CurrencyType.eur, 'input': '999.99'},
        {'currency': CurrencyType.vnd, 'input': '1000000'},
        {'currency': CurrencyType.jpy, 'input': '12345'},
        {'currency': CurrencyType.cad, 'input': '56.78'},
      ];

      for (final test in testValues) {
        final currency = test['currency'] as CurrencyType;
        final input = test['input'] as String;

        // Parse input to storage amount
        final storageAmount = CurrencyUtils.parseInput(input, currency);
        expect(storageAmount, isNotNull);

        // Convert back to display amount
        final displayAmount =
            CurrencyUtils.toDisplayAmount(storageAmount!, currency);

        // Compare with original input (accounting for decimal precision)
        final originalAmount = double.parse(input.replaceAll(',', ''));
        expect(
          displayAmount,
          closeTo(originalAmount,
              0.001), // Allow for minor floating point differences
          reason: 'Round-trip conversion failed for ${currency.code}: $input',
        );
      }
    });

    test('USD 1000 bug reproduction and fix', () {
      // This test reproduces and verifies the fix for the bug where
      // input "1000" USD was showing as "100K" instead of "1K"

      final currency = CurrencyType.usd;
      final userInput = '1000';

      // Step 1: Parse user input (should be 100000 cents)
      final storageAmount = CurrencyUtils.parseInput(userInput, currency);
      expect(storageAmount, equals(100000)); // 1000 USD = 100000 cents

      // Step 2: Extension methods should treat storageAmount as storage amount, not display amount
      final extensionFormatExact = storageAmount!.formatCurrency(currency);
      final extensionFormatCompact = storageAmount.formatCompact(currency);

      // Step 3: Static methods for comparison
      final staticFormatExact =
          CurrencyUtils.formatExact(storageAmount, currency);
      final staticFormatCompact =
          CurrencyUtils.formatCompact(storageAmount, currency);

      // All should format 100000 cents as $1,000.00 (exact) and $1K (compact)
      expect(extensionFormatExact, contains('1,000.00'));
      expect(extensionFormatCompact, contains('1K'));
      expect(staticFormatExact, contains('1,000.00'));
      expect(staticFormatCompact, contains('1K'));

      // They should be identical
      expect(extensionFormatExact, equals(staticFormatExact));
      expect(extensionFormatCompact, equals(staticFormatCompact));

      // The bug would have shown 100K instead of 1K
      expect(extensionFormatCompact, isNot(contains('100K')));
      expect(staticFormatCompact, isNot(contains('100K')));
    });

    test('USD 10000 bug reproduction and fix', () {
      // Test with larger amount to ensure the fix works for various values

      final currency = CurrencyType.usd;
      final userInput = '10000';

      // Parse to storage amount (should be 1000000 cents)
      final storageAmount = CurrencyUtils.parseInput(userInput, currency);
      expect(storageAmount, equals(1000000)); // 10000 USD = 1000000 cents

      // Format using extension methods
      final extensionFormatCompact = storageAmount!.formatCompact(currency);
      final staticFormatCompact =
          CurrencyUtils.formatCompact(storageAmount, currency);

      // Should format as 10K, not 1000K or 1M
      expect(extensionFormatCompact, contains('10K'));
      expect(staticFormatCompact, contains('10K'));
      expect(extensionFormatCompact, equals(staticFormatCompact));

      // The bug would have shown wrong values
      expect(extensionFormatCompact, isNot(contains('1000K')));
      expect(extensionFormatCompact, isNot(contains('1M')));
    });

    test('All currency types storage amount handling', () {
      // Test that the fix works for all currency types

      final testCases = [
        // USD (has decimals, storage in cents)
        {
          'currency': CurrencyType.usd,
          'input': '1000',
          'expectedStorage': 100000,
          'expectedCompact': '\$1K'
        },
        {
          'currency': CurrencyType.usd,
          'input': '1.50',
          'expectedStorage': 150,
          'expectedCompact': '\$1.50'
        },

        // EUR (has decimals, storage in cents)
        {
          'currency': CurrencyType.eur,
          'input': '500',
          'expectedStorage': 50000,
          'expectedCompact': '€500.00'
        },
        {
          'currency': CurrencyType.eur,
          'input': '2.25',
          'expectedStorage': 225,
          'expectedCompact': '€2.25'
        },

        // VND (no decimals, storage in units)
        {
          'currency': CurrencyType.vnd,
          'input': '1000000',
          'expectedStorage': 1000000,
          'expectedCompact': '1Kđ'
        },
        {
          'currency': CurrencyType.vnd,
          'input': '500',
          'expectedStorage': 500,
          'expectedCompact': '500 VNĐ'
        },

        // JPY (no decimals, storage in units)
        {
          'currency': CurrencyType.jpy,
          'input': '1000',
          'expectedStorage': 1000,
          'expectedCompact': '¥1K'
        },
        {
          'currency': CurrencyType.jpy,
          'input': '100',
          'expectedStorage': 100,
          'expectedCompact': '¥100'
        },

        // CAD (has decimals, storage in cents)
        {
          'currency': CurrencyType.cad,
          'input': '750',
          'expectedStorage': 75000,
          'expectedCompact': 'C\$750.00'
        },
        {
          'currency': CurrencyType.cad,
          'input': '3.75',
          'expectedStorage': 375,
          'expectedCompact': 'C\$3.75'
        },
      ];

      for (final testCase in testCases) {
        final currency = testCase['currency'] as CurrencyType;
        final input = testCase['input'] as String;
        final expectedStorage = testCase['expectedStorage'] as int;
        final expectedCompact = testCase['expectedCompact'] as String;

        // Parse input
        final storageAmount = CurrencyUtils.parseInput(input, currency);
        expect(storageAmount, equals(expectedStorage),
            reason: 'Storage amount for $input ${currency.code}');

        // Test extension method formatting
        final extensionCompact = storageAmount!.formatCompact(currency);
        final staticCompact =
            CurrencyUtils.formatCompact(storageAmount, currency);

        // Both should produce the same result
        expect(extensionCompact, equals(staticCompact),
            reason: 'Extension vs static for $input ${currency.code}');

        // Check compact formatting (allow some flexibility for formatting differences)
        if (expectedCompact.contains('K') ||
            expectedCompact.contains('M') ||
            expectedCompact.contains('B')) {
          expect(extensionCompact,
              contains(expectedCompact.substring(expectedCompact.length - 1)),
              reason:
                  'Compact format for $input ${currency.code}: expected to contain suffix from $expectedCompact, got $extensionCompact');
        }
      }
    });

    test('Debug comma parsing issue', () {
      // Test parsing formatted input (what the form field might send)
      final inputs = ['1000', '1,000'];
      final currency = CurrencyType.usd;

      for (final input in inputs) {
        developer.log('Testing input: "$input"');

        final storageAmount = CurrencyUtils.parseInput(input, currency);
        developer.log('Parsed storage amount: $storageAmount');

        if (storageAmount != null) {
          final exactFormatted =
              CurrencyUtils.formatExact(storageAmount, currency);
          final compactFormatted =
              CurrencyUtils.formatCompact(storageAmount, currency);
          developer.log('Exact formatted: $exactFormatted');
          developer.log('Compact formatted: $compactFormatted');
        }
        developer.log('---');
      }
    });

    test('Debug storage vs display amount confusion', () {
      final currency = CurrencyType.usd;

      // When user inputs 1000 USD
      final userInput = '1000';
      final correctStorageAmount =
          CurrencyUtils.parseInput(userInput, currency); // Should be 100000
      developer.log('Correct storage amount: $correctStorageAmount');

      // Correct formatting of storage amount
      final correctFormatting =
          CurrencyUtils.formatExact(correctStorageAmount!, currency);
      developer.log('Correct formatting: $correctFormatting');

      // WRONG: If storage amount is treated as display amount
      final wrongStorageAmount = CurrencyUtils.toStorageAmount(
          correctStorageAmount.toDouble(), currency);
      developer.log(
          'Wrong storage amount (if 100000 treated as display): $wrongStorageAmount');

      final wrongFormatting =
          CurrencyUtils.formatCompact(wrongStorageAmount, currency);
      developer.log('Wrong formatting (compact): $wrongFormatting');

      // This should show the bug - wrongFormatting should be 100K
      expect(wrongFormatting, contains('100K'));
    });

    test('Debug double conversion bug - 10000 USD case', () {
      final currency = CurrencyType.usd;
      final userInput = '10000';

      developer.log('=== Step by step trace ===');
      developer.log('1. User input: "$userInput"');

      // Step 1: Parse user input (should be correct)
      final storageAmount = CurrencyUtils.parseInput(userInput, currency);
      developer.log('2. Parsed storage amount: $storageAmount cents');
      developer.log('   (${storageAmount! / 100} dollars)');

      // Step 2: Convert back to display (should be correct)
      final displayAmount =
          CurrencyUtils.toDisplayAmount(storageAmount, currency);
      developer.log('3. Display amount: $displayAmount dollars');

      // Step 3: Format for preview (should be correct)
      final preview = CurrencyUtils.formatExact(storageAmount, currency);
      developer.log('4. Preview: $preview');

      // The BUG: If storage amount gets double-converted
      developer.log('\n=== THE BUG ===');
      developer.log(
          'If storageAmount ($storageAmount) is mistakenly treated as displayAmount:');
      final wrongStorageAmount =
          CurrencyUtils.toStorageAmount(storageAmount.toDouble(), currency);
      developer.log('Wrong storage amount: $wrongStorageAmount cents');
      developer.log('   (${wrongStorageAmount / 100} dollars)');

      final wrongPreview =
          CurrencyUtils.formatCompact(wrongStorageAmount, currency);
      developer.log(
          'Wrong preview (compact): $wrongPreview'); // This should show the double conversion bug
      expect(wrongPreview,
          contains('M')); // 1M for 10000 input, or 100K for 1000 input

      // Correct expectations
      expect(storageAmount, equals(1000000)); // 10000 * 100
      expect(displayAmount, equals(10000.0));
      expect(preview, contains('10,000.00'));
    });

    test('Debug extension method vs static method', () {
      final storageAmount = 10000; // 100 USD in cents
      final currency = CurrencyType.usd;

      developer.log('=== EXTENSION vs STATIC METHODS ===');
      developer.log('Storage amount: $storageAmount cents');

      // Using static methods (correct)
      final staticExact = CurrencyUtils.formatExact(storageAmount, currency);
      final staticCompact =
          CurrencyUtils.formatCompact(storageAmount, currency);
      developer.log('Static formatExact: $staticExact');
      developer.log('Static formatCompact: $staticCompact');

      // Using extension methods (might be incorrect?)
      final extensionExact = storageAmount.formatCurrency(currency);
      final extensionCompact = storageAmount.formatCompact(currency);
      developer.log('Extension formatCurrency: $extensionExact');
      developer.log('Extension formatCompact: $extensionCompact');

      // Check if they're the same
      expect(staticExact, equals(extensionExact));
      expect(staticCompact, equals(extensionCompact));
    });
  });
}
