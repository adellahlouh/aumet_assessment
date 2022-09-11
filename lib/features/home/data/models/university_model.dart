class UniversityModel {
  String? favoriteID ;
  List<String>? domains;
  String? alphaTwoCode;
  String? country;
  List<String>? webPages;
  String? name;
  String? stateProvince;

  UniversityModel({
    this.domains,
    this.alphaTwoCode,
    this.country,
    this.webPages,
    this.name,
    this.stateProvince,
  });

  UniversityModel.fromJson(Map<String, dynamic> json) {
    domains = json['domains'].cast<String>();
    favoriteID = json['favoriteID'];
    alphaTwoCode = json['alpha_two_code'];
    country = json['country'];
    webPages = json['web_pages'].cast<String>();
    name = json['name'];
    stateProvince = json['state-province'];
  }

  Map<String, dynamic> toJson() {
    return {
      'domains': domains,
      'favoriteID': favoriteID,
      'alpha_two_code': alphaTwoCode,
      'country': country,
      'web_pages': webPages,
      'name': name,
      'state-province': stateProvince,
    };
  }
}
