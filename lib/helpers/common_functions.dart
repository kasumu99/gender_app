bool confirmMatricNumber(String matric){
  RegExp regExp = new RegExp(
      r"(P|F)\/(ND|HD)\/\d[0-9]\/[0-9]*",
      caseSensitive: false
  );
  bool matches = regExp.hasMatch(matric);
  if(matches && matric.length == 15){
    return true;
  }else{
    return false;
  }
}