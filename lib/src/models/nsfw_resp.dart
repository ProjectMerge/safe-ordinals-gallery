
class NSFWResponse {
  String? message;
  bool? nsfwPic;
  bool? nsfwText;
  String? status;

  NSFWResponse({this.message, this.nsfwPic, this.nsfwText, this.status});

  NSFWResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    nsfwPic = json['nsfwPic'];
    nsfwText = json['nsfwText'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['nsfwPic'] = nsfwPic;
    data['nsfwText'] = nsfwText;
    data['status'] = status;
    return data;
  }
}