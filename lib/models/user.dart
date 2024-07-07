class User {
  int? id = 0;
  String? email = '';
  String? firstName = '';
  String? lastName = '';
  int? age;
  String? gender = '';
  bool? isVerified;
  bool? isAbsent;
  String? picture;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.age,
      this.gender,
      this.isVerified,
      this.isAbsent,
      this.picture});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    age = json['age'];
    gender = json['gender'];
    isVerified = json['is_verified'];
    isAbsent = json['is_absent'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['isVerified'] = this.isVerified;
    data['isAbsent'] = this.isAbsent;
    data['picture'] = this.picture;
    return data;
  }
}