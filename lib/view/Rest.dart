import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


class Rest extends StatefulWidget {
  RestApp createState() => RestApp();
}

class RestApp extends State<Rest> {
  TextEditingController id= TextEditingController();
  TextEditingController code= TextEditingController();
  TextEditingController title= TextEditingController();
  TextEditingController fecha_episodio = TextEditingController();
  TextEditingController episodio = TextEditingController();


  consumirGet(var id) async{
    try {
      Response response = await get(Uri.parse("https://rickandmortyapi.com/api/episode/"+id));
      Map data= jsonDecode(response.body);
      print(response.statusCode.toString());
      if(response.statusCode.toString()=='200'){
        title.text='${data['name']}';
        fecha_episodio.text='${data['air_date']}';
        episodio.text='${data['episode']}';
        code.text=response.statusCode.toString();
      }


    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Rest"),
      ),
      body: SingleChildScrollView(
          child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 50, right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      consumirGet(id.text);
                    },
                    child: Text('HTTP'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: TextField(
                    controller: id,
                    decoration: InputDecoration(labelText: 'Id'),
                    style: TextStyle(color: Color(0xFF0097ff)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: TextField(
                    controller: code,
                    decoration: InputDecoration(labelText: 'Code'),
                    style: TextStyle(color: Color(0xFF0097ff)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: TextField(
                    controller: title,
                    decoration: InputDecoration(labelText: 'Title'),
                    style: TextStyle(color: Color(0xFF0097ff)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: TextField(
                    controller: fecha_episodio,
                    decoration: InputDecoration(labelText: 'Fecha Episodio'),
                    style: TextStyle(color: Color(0xFF0097ff)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: TextField(
                    controller: episodio,
                    decoration: InputDecoration(labelText: 'N° del espisodio'),
                    style: TextStyle(color: Color(0xFF0097ff)),
                  ),
                ),
              ]
          )
      ),
    );
  }
}