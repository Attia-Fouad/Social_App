class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;

  PostModel({
    this.uId,
    this.name,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
    };
  }
}
