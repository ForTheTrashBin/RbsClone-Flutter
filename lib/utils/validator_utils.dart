String? validateFlags(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Pflichtfeld';
  }

  if (int.tryParse(value) == null) {
    return 'Zahl erforderlich';
  }

  int parsedValue = int.parse(value);

  if ((parsedValue < 0) || (parsedValue > 32767)) {
    return 'Muss [0..32767] sein';
  }

  return null;
}

String? validateRiskType(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Pflichtfeld';
  }

  if (int.tryParse(value) == null) {
    return 'Zahl erforderlich';
  }

  int parsedValue = int.parse(value);

  if ((parsedValue < 0) || (parsedValue > 32767)) {
    return 'Muss [0..32767] sein';
  }

  return null;
}

String? validateIbanLength(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null; // Optional field
  }

  if (int.tryParse(value) == null) {
    return 'Zahl erforderlich';
  }

  int parsedValue = int.parse(value);

  if ((parsedValue < 8) || (parsedValue > 34)) {
    return 'Muss [8..34] sein';
  }

  return null;
}
