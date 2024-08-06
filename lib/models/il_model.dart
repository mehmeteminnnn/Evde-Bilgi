class IlModel {
  String name;
  List<County> counties;

  IlModel({
    required this.name,
    required this.counties,
  });

  factory IlModel.fromJson(Map<String, dynamic> json) {
    try {
      var list = json['counties'] as List;
      List<County> countiesList = list.map((i) => County.fromJson(i)).toList();

      return IlModel(
        name: json['name'],
        counties: countiesList,
      );
    } catch (e) {
      print('Error in IlModel.fromJson: $e');
      rethrow;
    }
  }
}

class County {
  String name;
  List<District> districts;

  County({
    required this.name,
    required this.districts,
  });

  factory County.fromJson(Map<String, dynamic> json) {
    try {
      var list = json['districts'] as List;
      List<District> districtsList =
          list.map((i) => District.fromJson(i)).toList();

      return County(
        name: json['name'],
        districts: districtsList,
      );
    } catch (e) {
      print('Error in County.fromJson: $e');
      rethrow;
    }
  }
}

class District {
  String name;
  List<Neighborhood> neighborhoods;

  District({
    required this.name,
    required this.neighborhoods,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    try {
      var list = json['neighborhoods'] as List;
      List<Neighborhood> neighborhoodsList =
          list.map((i) => Neighborhood.fromJson(i)).toList();

      return District(
        name: json['name'],
        neighborhoods: neighborhoodsList,
      );
    } catch (e) {
      print('Error in District.fromJson: $e');
      rethrow;
    }
  }
}

class Neighborhood {
  String name;
  String code;

  Neighborhood({
    required this.name,
    required this.code,
  });

  factory Neighborhood.fromJson(Map<String, dynamic> json) {
    try {
      return Neighborhood(
        name: json['name'],
        code: json['code'],
      );
    } catch (e) {
      print('Error in Neighborhood.fromJson: $e');
      rethrow;
    }
  }
}
