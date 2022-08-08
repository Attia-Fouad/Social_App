class SocialUserModel {
  String? name;
  String? phone;
  String? email;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  SocialUserModel({
    this.uId,
    this.email,
    this.name,
    this.phone,
    this.image,
    this.cover,
    this.bio,
    this.isEmailVerified,
  });

  SocialUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uId = json['uId'];
    name = json['name'];
    phone = json['phone'];
    bio = json['bio'];
    image = json['image'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'uId': uId,
      'email': email,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
