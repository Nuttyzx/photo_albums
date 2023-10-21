import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_albums/models/photo_item.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<Photo_item>? _itemList;
  String? _error; // ถ้าตัวแปรนี้เปน null จะไม่เกิด error แต่ถ้าเปนข้อความ แสดงว่าเป็น error (เป็นตัวแปรดัดจับ error)

  void getPhoto() async { // api
    try{
      setState(() {
        _error = null;//reset clear error ก่อนในแต่ละครั้ง
      });

      //await Future.delayed(Duration(seconds: 3), () {});

      final response = await _dio.get('https://jsonplaceholder.typicode.com/albums'); // link api ที่ทำกาารทดสอบ
      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString()); // list map
      setState(() {
        _itemList = list.map((item) => Photo_item.fromJson(item)).toList();
      }); // List TodoItem
    } catch (e) { //ถ้าเป็น error ขึ้น หรือ exception จะกระโดดมาทำที่ catch
      setState((){
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}'); // ดักจับ error
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto();  //ได้มาเป็น String จาก api
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                getPhoto();
              },
              child: Text('RETRY'))
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    }
    else{
      body = ListView.builder(
        itemCount: _itemList!.length,
        itemBuilder: (context, index) {
          var photoItem = _itemList![index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(children: [
                    Text(photoItem.title),
                  ],),
                  Row(children: [
                    Column(children: [
                      Container(
                          decoration: BoxDecoration(color: Color(0xFFF3C8F3),
                            //border: Border.all(color: Colors.black,width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5.0),
                            child: Text('Album ID: ' + photoItem.id.toString(), style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.normal)) ,
                          )
                      ),
                    ],),
                    SizedBox(width: 5.0),
                    Column(children: [
                      Container(decoration: BoxDecoration(color: Color(
                          0xFFB7E5F6) , borderRadius: BorderRadius.circular(15.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5.0),
                        child: Text(' User ID: ' + photoItem.userId.toString(), style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.normal)),
                      ))
                    ],)
                  ],)
                ],
              ),
            ),
          );
        },
      );
    }
    return Scaffold( // เชื่อมกับหน้า ui
      appBar: AppBar(
        title: Text('Photo Albums'),
      ),
      body: body,
    );
  }
}
