import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(RealTimeSubway());

class RealTimeSubway extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  //API 정보
  static const String _urlPrefix = 'http://swopenapi.seoul.go.kr/api/subway/';  //인증키 앞 주소
  static const String _userkey = 'sample';  //인증키
  static const String _urlsuffix = '/json/realtimeStationArrival/0/5/';  //인증키 뒷 주소
  static const String _defaultStation = '신도림';   //받아올 변수값(지하철 명)

  //가져올 정보에 대한 초기화, 가져올 json 데이터와 이름이 같아야 한다.
  String _response = '';
  int _rowNum;
  String _trainLineNm;
  String _subwayHeading;
  String _arylMsg2;

  String _buildUrl(String station){   // url 주소값 문자열 나열
    StringBuffer sb = StringBuffer();
    sb.write(_urlPrefix);
    sb.write(_userkey);
    sb.write(_urlsuffix);
    sb.write(_defaultStation);
    return sb.toString();
  }

  _httpGet(String url) async{  //get으로 받은 주소값을 실행한다. 비동기식
    var response = await http.get(_buildUrl(_defaultStation));  //실행 응답
    String responseBody = response.body;
    
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/%EC%8B%A0%EB%8F%84%EB%A6%BC





