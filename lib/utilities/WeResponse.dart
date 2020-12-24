import 'dart:convert';

class WebResponse {
  int code;
  String message;
  dynamic data;
  WebResponse({
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'data': data,
    };
  }

  static WebResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WebResponse(
      message: map['message'],
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  static WebResponse fromJson(String source) => fromMap(json.decode(source));
}
