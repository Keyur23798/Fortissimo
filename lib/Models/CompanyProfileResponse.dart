class CompanyProfileResponse {
  int? status;
  String? message;
  List<Data>? data;

  CompanyProfileResponse({
    this.status,
    this.message,
    this.data});

  CompanyProfileResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  int? id;
  String? companyName;
  String? companyEmail;
  String? aboutUs;
  String? termsConditions;
  String? privacyPolicy;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.companyName,
    this.companyEmail,
    this.aboutUs,
    this.termsConditions,
    this.privacyPolicy,
    this.createdAt,
    this.updatedAt});

  Data.fromJson(dynamic json) {
    id = json["id"];
    companyName = json["company_name"];
    companyEmail = json["company_email"];
    aboutUs = json["about_us"];
    termsConditions = json["terms_conditions"];
    privacyPolicy = json["privacy_policy"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["company_name"] = companyName;
    map["company_email"] = companyEmail;
    map["about_us"] = aboutUs;
    map["terms_conditions"] = termsConditions;
    map["privacy_policy"] = privacyPolicy;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}