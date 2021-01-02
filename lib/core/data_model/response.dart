class Response {
  String status;
  String message;

  Response.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'];

  Map<String,dynamic> toMap(){
    return {
      'status':status,
      'message':message
    };
  }
}
