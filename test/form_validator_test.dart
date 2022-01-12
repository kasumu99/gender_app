import 'package:flutter_test/flutter_test.dart';
import 'package:gender_app/helpers/common_functions.dart';

void main(){
  test('Test matric number regex', (){
    var result = confirmMatricNumber("P/HD/12/3210006");
    expect(result, true);
  });
}