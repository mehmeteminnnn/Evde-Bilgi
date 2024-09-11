class Teacher {
  // Existing fields
  List<String> workingTypes; // "Part-time", "Hourly", etc.
  String dob; // Date of birth
  String teacherId;
  String experienceDescription;
  int maxSalary;
  int minSalary;
  String name;
  String nationality;
 // String phone;
  List<String> positions; // "Shadow Teacher", "Life Coach", etc.
  String selectedCity; // Selected city
  String selectedDistrict; // Selected district
  String selectedExperience; // Experience range

  // Newly added fields
  String? gender;
  String? educationLevel;
  String? medicalEducation;
  String? educationFaculty;
  String? personalCar;
  String? drivingLicense;
  String? passport;
  String? smokingHabit;
  String? workingInCameraEnvironment;
  String? workingInPetEnvironment;
  String? attendedCourses;
  String? spokenLanguages;

  Teacher({required this.teacherId,
    required this.workingTypes,
    required this.dob,
    required this.experienceDescription,
    required this.maxSalary,
    required this.minSalary,
    required this.name,
    required this.nationality,
 
  //  required this.phone,
    required this.positions,
    required this.selectedCity,
    required this.selectedDistrict,
    required this.selectedExperience,
    this.gender,
    this.educationLevel,
    this.medicalEducation,
    this.educationFaculty,
    this.personalCar,
    this.drivingLicense,
    this.passport,
    this.smokingHabit,
    this.workingInCameraEnvironment,
    this.workingInPetEnvironment,
    this.attendedCourses,
    this.spokenLanguages,
  });

  // JSON to model conversion
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(teacherId: json['teacherId'],
      workingTypes: List<String>.from(json['workingTypes']),
      dob: json['dob'],
      experienceDescription: json['experienceDescription'],
      maxSalary: json['maxSalary'],
      minSalary: json['minSalary'],
      name: json['name'],
      nationality: json['nationality'],
    //  phone: json['phone'],
      positions: List<String>.from(json['positions']),
      selectedCity: json['selectedCity'],
      selectedDistrict: json['selectedDistrict'],
      selectedExperience: json['selectedExperience'],
      gender: json['gender'],
      educationLevel: json['educationLevel'],
      medicalEducation: json['medicalEducation'],
      educationFaculty: json['educationFaculty'],
      personalCar: json['personalCar'],
      drivingLicense: json['drivingLicense'],
      passport: json['passport'],
      smokingHabit: json['smokingHabit'],
      workingInCameraEnvironment: json['workingInCameraEnvironment'],
      workingInPetEnvironment: json['workingInPetEnvironment'],
      attendedCourses: json['attendedCourses'],
      spokenLanguages: json['spokenLanguages'],
    );
  }

  // Model to JSON conversion
  Map<String, dynamic> toJson() {
    return {'teacherId': teacherId,
      'workingTypes': workingTypes,
      'dob': dob,
      'experienceDescription': experienceDescription,
      'maxSalary': maxSalary,
      'minSalary': minSalary,
      'name': name,
      'nationality': nationality,
     // 'phone': phone,
      'positions': positions,
      'selectedCity': selectedCity,
      'selectedDistrict': selectedDistrict,
      'selectedExperience': selectedExperience,
      'gender': gender,
      'educationLevel': educationLevel,
      'medicalEducation': medicalEducation,
      'educationFaculty': educationFaculty,
      'personalCar': personalCar,
      'drivingLicense': drivingLicense,
      'passport': passport,
      'smokingHabit': smokingHabit,
      'workingInCameraEnvironment': workingInCameraEnvironment,
      'workingInPetEnvironment': workingInPetEnvironment,
      'attendedCourses': attendedCourses,
      'spokenLanguages': spokenLanguages,
    };
  }
}
