import 'package:flutter_test/flutter_test.dart';
import 'package:guias_transportista/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter Test Suite', () {
    test('toDisplayDate formats DateTime into dd/MM/yyyy', () {
      final date = DateTime(2026, 10, 5);
      expect(DateFormatter.toDisplayDate(date), equals('05/10/2026'));
    });

    test('toApiDate formats DateTime into yyyy-MM-dd', () {
      final date = DateTime(2026, 10, 5);
      expect(DateFormatter.toApiDate(date), equals('2026-10-05'));
    });

    test('parseDate correctly parses api and display formats', () {
      final fromApi = DateFormatter.parseDate('2026-10-05');
      expect(fromApi, isNotNull);
      expect(fromApi!.year, equals(2026));
      expect(fromApi.month, equals(10));
      expect(fromApi.day, equals(5));

      final fromDisplay = DateFormatter.parseDate('05/10/2026');
      expect(fromDisplay, isNotNull);
      expect(fromDisplay!.year, equals(2026));
      expect(fromDisplay.month, equals(10));
      expect(fromDisplay.day, equals(5));
    });

    test('formatStringDate converts iso/api string to display format', () {
      expect(DateFormatter.formatStringDate('2026-10-05'), equals('05/10/2026'));
      expect(DateFormatter.formatStringDate(''), equals(''));
    });
  });
}
