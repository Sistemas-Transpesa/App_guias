import 'package:flutter_test/flutter_test.dart';
import 'package:guias_transportista/core/utils/validators.dart';

void main() {
  group('Validators Test Suite', () {
    test('validateUsername accepts valid strings and rejects empty/short', () {
      expect(Validators.validateUsername(''), isNotNull);
      expect(Validators.validateUsername('ab'), isNotNull);
      expect(Validators.validateUsername('45892147'), isNull);
      expect(Validators.validateUsername('chofer01'), isNull);
    });

    test('validatePassword rejects empty or short passwords', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword('12'), isNotNull);
      expect(Validators.validatePassword('123456'), isNull);
    });

    test('validateRuc requires 11 valid numeric digits', () {
      expect(Validators.validateRuc(''), isNotNull);
      expect(Validators.validateRuc('2012345678'), isNotNull); // 10 digits
      expect(Validators.validateRuc('201234567890'), isNotNull); // 12 digits
      expect(Validators.validateRuc('20601234567'), isNull); // 11 digits starting with 20
      expect(Validators.validateRuc('10458921471'), isNull); // 11 digits starting with 10
    });

    test('validateDni requires 8 digits', () {
      expect(Validators.validateDni(''), isNotNull);
      expect(Validators.validateDni('1234567'), isNotNull);
      expect(Validators.validateDni('123456789'), isNotNull);
      expect(Validators.validateDni('45892147'), isNull);
    });

    test('validateWeight accepts numbers with up to 4 decimals', () {
      expect(Validators.validateWeight(''), isNotNull);
      expect(Validators.validateWeight('0'), isNotNull);
      expect(Validators.validateWeight('-5'), isNotNull);
      expect(Validators.validateWeight('1500.5'), isNull);
      expect(Validators.validateWeight('28500.1234'), isNull);
      expect(Validators.validateWeight('28500.12345'), isNotNull); // 5 decimals
    });
  });
}
