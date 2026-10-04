class Validators {
  Validators._();

  static String? requiredField(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'El campo $fieldName es requerido'
          : 'Este campo es requerido';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su usuario';
    }
    if (value.trim().length < 3) {
      return 'El usuario debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su contraseña';
    }
    if (value.length < 3) {
      return 'La contraseña debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validateRuc(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el RUC';
    }
    final cleanValue = value.trim();
    if (cleanValue.length != 11 || int.tryParse(cleanValue) == null) {
      return 'El RUC debe contener exactamente 11 dígitos numéricos';
    }
    if (!cleanValue.startsWith('10') &&
        !cleanValue.startsWith('20') &&
        !cleanValue.startsWith('15') &&
        !cleanValue.startsWith('17')) {
      return 'El RUC ingresado no tiene un formato válido';
    }
    return null;
  }

  static String? validateDni(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el DNI';
    }
    final cleanValue = value.trim();
    if (cleanValue.length != 8 || int.tryParse(cleanValue) == null) {
      return 'El DNI debe contener exactamente 8 dígitos';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el peso total en KG';
    }
    final cleanValue = value.trim().replaceAll(',', '.');
    final weight = double.tryParse(cleanValue);
    if (weight == null || weight <= 0) {
      return 'Ingrese un peso numérico mayor a 0';
    }
    // Validation for up to 4 decimal places
    final decimalParts = cleanValue.split('.');
    if (decimalParts.length > 1 && decimalParts[1].length > 4) {
      return 'El peso permite un máximo de 4 decimales';
    }
    return null;
  }

  static String? validateSerie(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese la serie';
    }
    if (value.trim().length > 10) {
      return 'La serie no puede superar 10 caracteres';
    }
    return null;
  }

  static String? validateNumero(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el número';
    }
    if (value.trim().length > 15) {
      return 'El número no puede superar 15 caracteres';
    }
    return null;
  }
}
