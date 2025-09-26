class AddressModel {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  AddressModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }
}
