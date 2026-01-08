class myResponse {
  bool success;
  String message;
  dynamic data;

  myResponse({required this.success, this.message = "", this.data});
}
