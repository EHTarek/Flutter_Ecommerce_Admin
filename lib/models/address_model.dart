class AddressModel {
  String addressLine1;
  String? addressLine2;
  String city;
  String zipcode;

  AddressModel({
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.zipcode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'zipcode': zipcode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
    addressLine1: map['addressLine1'],
    addressLine2: map['addressLine2'],
    city: map['city'],
    zipcode: map['zipcode'],
  );
}
