class Person {
  String? name;
  String mobileNumber;
  String whatsappNumber;
  DateTime? dob;
  PlaceOfBirth? placeOfBirth;
  int seriesNumber;

  Person({
    this.name,
    required this.mobileNumber,
    required this.whatsappNumber,
    this.dob,
    this.placeOfBirth,
    this.seriesNumber = 1,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      mobileNumber: json['mobile_number'],
      whatsappNumber: json['whatsapp_number'],
      dob: json['dob'],
      placeOfBirth: json['place_of_birth'] != null
          ? PlaceOfBirth.fromJson(json['place_of_birth'])
          : null,
      seriesNumber: json['series_number'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile_number': mobileNumber,
      'whatsapp_number': whatsappNumber,
      'dob': dob,
      'place_of_birth': placeOfBirth?.toJson(),
      'series_number': seriesNumber,
    };
  }
}

class PlaceOfBirth {
  String? district;
  String? city;
  String? state;
  String? country;

  PlaceOfBirth({this.district, this.city, this.state, this.country = "India"});

  factory PlaceOfBirth.fromJson(Map<String, dynamic> json) {
    return PlaceOfBirth(
      district: json['district'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}
