import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {  //비동기식
  String url = 'http://jsonplaceholder.typicode.com/todos/1';  //json 주소
  var response = await http.get(url);   //응답
  print(response.statusCode);  //상태 코드 : 200 정상
  print(response.body);  
}



