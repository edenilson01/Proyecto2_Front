class Usuario {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? clientId;

  Usuario(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.clientId});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    clientId = json['client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['client_id'] = this.clientId;
    return data;
  }
}
