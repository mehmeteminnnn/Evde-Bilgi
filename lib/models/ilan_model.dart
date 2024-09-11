import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  List<String> jobTypes;
  String hoursPerDay;
  List<String> workingDays;
  String title;
  String details;
  String salary;
  bool isNegotiable;
  String position;
  String city;
  String district;
  String neighborhood;
  Timestamp publishDate;
  String userId;

  // Yeni eklenen alanlar
  String fullName;
  String email;
  String phoneNumber;
  String address;

  JobModel({
    Timestamp? publishDate,
    this.jobTypes = const [],
    this.hoursPerDay = '',
    this.workingDays = const [],
    this.title = '',
    this.details = '',
    this.salary = '',
    this.isNegotiable = false,
    this.position = '',
    this.city = '',
    this.district = '',
    this.neighborhood = '',
    this.userId = '',
    this.fullName = '', // Varsayılan değer
    this.email = '', // Varsayılan değer
    this.phoneNumber = '', // Varsayılan değer
    this.address = '', // Varsayılan değer
  }) : this.publishDate = publishDate ?? Timestamp.now();

  // Bu method JobModel'i Firestore'a kaydedilmek üzere Map'e dönüştürür.
  Map<String, dynamic> toMap() {
    return {
      'jobTypes': jobTypes,
      'hoursPerDay': hoursPerDay,
      'workingDays': workingDays,
      'title': title,
      'details': details,
      'salary': salary,
      'isNegotiable': isNegotiable,
      'position': position,
      'city': city,
      'district': district,
      'neighborhood': neighborhood,
      'publishDate': publishDate,
      'userId': userId,
      'fullName': fullName, // Yeni alan
      'email': email, // Yeni alan
      'phoneNumber': phoneNumber, // Yeni alan
      'address': address, // Yeni alan
    };
  }

  // Bu factory method Firestore verilerini JobModel'e dönüştürür.
  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobTypes: List<String>.from(map['jobTypes'] ?? []),
      hoursPerDay: map['hoursPerDay'] ?? '',
      workingDays: List<String>.from(map['workingDays'] ?? []),
      title: map['title'] ?? '',
      details: map['details'] ?? '',
      salary: map['salary'] ?? '',
      isNegotiable: map['isNegotiable'] ?? false,
      position: map['position'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      publishDate: map['publishDate'] ?? Timestamp.now(),
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '', // Yeni alan
      email: map['email'] ?? '', // Yeni alan
      phoneNumber: map['phoneNumber'] ?? '', // Yeni alan
      address: map['address'] ?? '', // Yeni alan
    );
  }
}
