import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //API에서 제공하는 서로 다른 데이터 형식을 encoding, decoding 해주는 pakage

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
  static const String _urlPrefix =
      'http://swopenapi.seoul.go.kr/api/subway/'; //인증키 앞 주소
  static const String _userkey = 'sample'; //인증키
  static const String _urlsuffix =
      '/json/realtimeStationArrival/0/5/'; //인증키 뒷 주소
  static const String _defaultStation = '신도림'; //받아올 변수값(지하철 명)

  //가져올 정보에 대한 초기화, 가져올 json 데이터와 이름이 같아야 한다.
  String _response = '';

  List<SubwayArrival> _data = []; //get으로 끌어온 데이터들을 배열에 저장.

  String _buildUrl(String station) {
    // url 주소값 문자열 나열
    StringBuffer sb = StringBuffer();
    sb.write(_urlPrefix);
    sb.write(_userkey);
    sb.write(_urlsuffix);
    sb.write(_defaultStation);
    return sb.toString();
  }

  _httpGet(String url) async {
    //get으로 받은 주소값을 실행한다. 비동기식
    var response = await http.get(_buildUrl(_defaultStation)); //실행 응답
    String responseBody = response.body;

    var json = jsonDecode(responseBody);
    //list 변수 이름 지정. 어떤 변수값이 들어올지 모르기 때문에 dynamic 사용.
    List<dynamic> realtimeArrivalList = json['realtimeArrivalList'];

    final int cnt = realtimeArrivalList
        .length; //json으로 파싱된 realtimeArrivalList의 갯수. 갯수만큼 반복을 해줄 것임.
    List<SubwayArrival> list = List.generate(cnt, (int i) {
      Map<String, dynamic> item =
          realtimeArrivalList[i]; //realtimeArrivalList의 i번째 배열가져옴.
      return SubwayArrival(
        item['rowNum'],
        item['subwayId'],
        item['trainLineNm'],
        item['subwayHeading'],
        item['arvlMsg2'],
      );
    });
  }

  @override
  void initState() {
    //화면의 전환 시점이 있을 때마다 초기화
    super.initState();
    _httpGet(_buildUrl(_defaultStation));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('실시간 지하철 정보'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Text('$_rowNum'),
            Text('$_subwayId'),
            Text('$_trainLineNm'),
            Text('$_subwayHeading'),
            Text('$_arylMsg2'),
          ],
        ),
      ),
    );
  }
}

class SubwayArrival {
  int _rowNum;
  String _subwayId;
  String _trainLineNm;
  String _subwayHeading;
  String _arylMsg2;

  SubwayArrival(
      this._rowNum, this._subwayId, this._subwayHeading, this._arylMsg2, this._trainLineNm);

  //외부도메인을 끌어서 변수 선언
  int get rowNum => _rowNum;

  String get subwayId => _subwayId;

  String get trainLineNm => _trainLineNm;

  String get subwayHeading => _subwayHeading;

  String get arylMsg2 => _arylMsg2;
}
