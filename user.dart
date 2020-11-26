import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String password;

  User({this.uid, this.email, this.password});
}

class UserData {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String role;
  String businessName;
  String businessType;
  String streetAddress;
  String city;
  String state;
  String postcode;
  String country;
  String businessTradingCurrency;
  Timestamp createdAt;
  Timestamp updatedAt;

  UserData(
    this.id,
    this.firstName,
    this.businessTradingCurrency,
    this.businessType,
    this.businessName,
    this.city,
    this.country,
    this.createdAt,
    this.lastName,
    this.phoneNumber,
    this.postcode,
    this.role,
    this.state,
    this.streetAddress,
    this.updatedAt,
  );

  UserData.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    phoneNumber = data['phone_number'];
    businessTradingCurrency = data['trading_currency'];
    role = data['role'];
    businessName = data['business_name'];
    businessType = data['business_type'];
    streetAddress = data['street_address'];
    city = data['city'];
    postcode = data['postcode'];
    state = data['state'];
    country = data['country'];
    createdAt = data['created_at'];
    updatedAt = data['updated_at'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'role': role,
      'trading_currency': businessTradingCurrency,
      'business_name': businessName,
      'business_type': businessType,
      'street_address': streetAddress,
      'city': city,
      'postcode': postcode,
      'state': state,
      'country': country,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
