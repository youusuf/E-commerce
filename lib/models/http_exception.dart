class HTTPException implements Exception{


  final String message;
  HTTPException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }





}