import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(RealtimeSubway());

class RealtimeSubway extends StatelessWidget {
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
  static const String _urlPrefix = 'http://swopenapi.seoul.go.kr/api/subway/';
  static const String _userKey = '45465977496d617235394b6372616a';
  static const String _urlSuffix = '/json/realtimeStationArrival/0/5/';
  static const String _defaultStation = '신논현';

  String _response = '';
  final _stationController = TextEditingController();
  bool _validation = false;
  bool _isLoading = false;

//  void main() async{
//    String url = '';
//    var response = await http.get(url);
//    print(response.body);
//  }

  List<SubwayArrival> _data = [];

  List<Card> _buildCards() {
    List<Card> res = [];
    for (SubwayArrival info in _data) {
      Card card = Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (info._subwayId == '1001')
                  CircleAvatar(
                    child: Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Colors.blue,
                  ),
                if (info._subwayId == '1002')
                  CircleAvatar(
                    child: Text(
                      '2',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                    radius: 15,
                  ),
                if (info._subwayId == '1003')
                  CircleAvatar(
                    child: Text(
                      '3',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color(0xFFEF7C1C),
                    radius: 15,
                  ),
                if (info._subwayId == '1004')
                  CircleAvatar(
                    child: Text(
                      '4',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Color(0xFF32A1C8),
                  ),
                if (info._subwayId == '1005')
                  CircleAvatar(
                    child: Text(
                      '5',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Color(0xFF8B50A4),
                  ),
                if (info._subwayId == '1006')
                  CircleAvatar(
                    child: Text(
                      '6',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Color(0xFFC55C1D),
                  ),
                if (info._subwayId == '1007')
                  CircleAvatar(
                    child: Text(
                      '7',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Color(0xFF54640D),
                  ),
                if (info._subwayId == '1008')
                  CircleAvatar(
                    child: Text(
                      '8',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Color(0xFFF51361),
                  ),
                if (info._subwayId == '1009')
                  CircleAvatar(
                    child: Text(
                      '9',
                      style: TextStyle(color: Colors.white),
                    ),
                    radius: 15,
                    backgroundColor: Color(0xFFAA9872),
                  ),
                SizedBox(height: 15.0),
                Text('도착지 방면 : ' + info._trainLineNm),
                SizedBox(height: 15.0),
                Text('내리는 문 방향 : ' + info._subwayHeading),
                SizedBox(height: 15.0),
                Text('이전 열차 위치 : ' + info._arvlMsg2),
              ],
            ),
          ),
        ),
      );
      res.add(card);
    }
    return res;
  }

  String _buildUrl(String station) {
    StringBuffer sb = StringBuffer();
    sb.write(_urlPrefix);
    sb.write(_userKey);
    sb.write(_urlSuffix);
    sb.write(station);
    return sb.toString();
  }

  _onClick() {
    _getInfo();
    _stationController.text = '';
  }

  _getInfo() async {
    setState(() {
      _isLoading = true;
    });

    String station = _stationController.text;

    var response = await http.get(_buildUrl(station));
    String responseBody = response.body;

    var json = jsonDecode(responseBody);
    List<dynamic> realtimeArrivalList = json['realtimeArrivalList'];

    final int cnt = realtimeArrivalList.length;

    List<SubwayArrival> list = List.generate(cnt, (int i) {
      Map<String, dynamic> item = realtimeArrivalList[i];
      return SubwayArrival(
        item['rowNum'],
        item['subwayId'],
        item['trainLineNm'],
        item['subwayHeading'],
        item['arvlMsg2'],
      );
    });

    SubwayArrival result = list[0];

    setState(() {
      if(station == ''){
        _data = [];
      } else {
        _data = list;
      }

      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  @override
  void dispose() {
    _stationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width * 0.55;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('실시간 지하철 정보'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color:Colors.blue),
                    ),
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text('역명'),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: width,
                        child: TextField(
                          controller: _stationController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left:15.0, top:1.0, bottom:1.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width:2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.blue),
                            ),
                            errorText: _validation ? '역명을 입력해 주세요!' : null,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      RaisedButton(
                        child: Text('조회', style: TextStyle(color: Colors.white),),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            _stationController.text.isEmpty
                                ? _validation = true
                                : _validation = false;
                          });
                          _onClick();
                        },
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: _buildCards(),
                  ),
                )
              ],
            ),
    );
  }
}

class SubwayArrival {
  int _rowNum;
  String _subwayId;
  String _trainLineNm;
  String _subwayHeading;
  String _arvlMsg2;

  SubwayArrival(this._rowNum, this._subwayId, this._trainLineNm,
      this._subwayHeading, this._arvlMsg2);

  int get rowNum => _rowNum;

  String get subwayId => _subwayId;

  String get trainLineNm => _trainLineNm;

  String get subwayHeading => _subwayHeading;

  String get arvlMsg2 => _arvlMsg2;
}
