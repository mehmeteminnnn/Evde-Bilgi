import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  List<String> jobTypes;
  String hoursPerDay;
  String urgency;
  String title;
  String details;
  String salary;
  bool isNegotiable;
  String position;
  String city;
  String district;
  String neighborhood;
  Timestamp publishDate;

  JobModel({
    Timestamp? publishDate,
    this.jobTypes = const [],
    this.hoursPerDay = '',
    this.urgency = '',
    this.title = '',
    this.details = '',
    this.salary = '',
    this.isNegotiable = false,
    this.city = '',
    this.district = '',
    this.neighborhood = '',
    this.position = '',
  }) : this.publishDate = publishDate ??
            Timestamp.now(); // Varsayılan olarak şu anki zaman atanıyor.

  // This method converts JobModel to a Map for saving to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'jobTypes': jobTypes,
      'hoursPerDay': hoursPerDay,
      'urgency': urgency,
      'title': title,
      'details': details,
      'salary': salary,
      'isNegotiable': isNegotiable,
      'position': position,
      'city': city,
      'district': district,
      'neighborhood': neighborhood,
      'publishDate': publishDate,
    };
  }

  // This factory method converts Firestore data to JobModel.
  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobTypes: List<String>.from(map['jobTypes']),
      hoursPerDay: map['hoursPerDay'] ?? '',
      urgency: map['urgency'] ?? '',
      title: map['title'] ?? '',
      details: map['details'] ?? '',
      salary: map['salary'] ?? '',
      isNegotiable: map['isNegotiable'] ?? false,
      position: map['position'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      publishDate: map['publishDate'] ?? '',
    );
  }
}
