class NSFWResponse {
  String? status;
  String? message;
  bool? nsfwText;
  bool? nsfwPic;
  String? base64;
  String? filename;
  bool? exists;

  NSFWResponse({this.status, this.message, this.nsfwText, this.nsfwPic, this.base64, this.filename});

  NSFWResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    nsfwText = json['nsfwText'];
    nsfwPic = json['nsfwPic'];
    base64 = json['base64'];
    filename = json['filename'];
    exists = json['exists'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['nsfwText'] = nsfwText;
    data['nsfwPic'] = nsfwPic;
    data['base64'] = base64;
    data['filename'] = filename;
    data['exists'] = exists;
    return data;
  }
}
