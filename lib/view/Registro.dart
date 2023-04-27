import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crypto/crypto.dart';

import '../DTO/User.dart';



class Registro extends StatefulWidget{
  final User cadena;
  Registro(this.cadena);
  @override
  RegistroApp createState()=> RegistroApp();
}


class RegistroApp extends State<Registro>{
  TextEditingController nombre = TextEditingController();
  TextEditingController identidad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController contrasenia = TextEditingController();

  final firebase= FirebaseFirestore.instance;

  insertarDatos ()async{
    try{
      await firebase.collection("Usuarios").doc().set({
        "NombreUsuario":nombre.text,
        "IdentidadUsuario": identidad.text,
        "CorreoUsuario": correo.text,
        "TelefonoUsuario": telefono.text,
        "ContraseñaUsuario": contrasenia.text,
        "Rol":"Invitado",
        "Estado" : true
      });
      print("Envio Correcto");
      mensaje ("Informacion", "Regitro correcto");
    }
    catch(e){
      print("Error en insert........."+ e.toString());
    }
  }


  void mensaje(String titulo, String contenido) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text(titulo), //title trae la variable titulo
            content: Text(contenido), //content trae la variable contenido
            actions: <Widget>[ //permite cualquier contenido de Widget, se puede crear cualquier contenido en este espacio
              FloatingActionButton(
                onPressed: () {

                },
                child:
                Text("OK", style: TextStyle(color: Colors.pinkAccent)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de usuarios"),
        backgroundColor: Colors.lightGreen
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: nombre,
                decoration: InputDecoration(
                  labelText: "Nombre"
                ),
                style: TextStyle(
                  color: Color(0xFF0977ff)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: identidad,
                decoration: InputDecoration(
                    labelText: "Identificacion"
                ),
                style: TextStyle(
                    color: Color(0xFF0977ff)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: correo,
                decoration: InputDecoration(
                    labelText: "Correo electronico"
                ),
                style: TextStyle(
                    color: Color(0xFF0977ff)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: telefono,
                decoration: InputDecoration(
                    labelText: "Telefono"
                ),
                style: TextStyle(
                    color: Color(0xFF0977ff)
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: contrasenia,
                decoration: InputDecoration(
                    hintText: "Contraseña", labelText: "Contraseña"
                ),
                obscureText: true,
                style: TextStyle(
                    color: Color(0xFF0977ff)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20,left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: (){
                    contrasenia.text= sha1.convert(utf8.encode(contrasenia.text)).toString();
                    print('contrasena original ${contrasenia.text}');
                    print('crypto SHA-1 :' + sha1.convert(utf8.encode(contrasenia.text)).toString());
                    insertarDatos();
                    nombre.clear();
                    identidad.clear();
                    correo.clear();
                    telefono.clear();
                    contrasenia.clear();
                  },
                  child: Text("Registrar"),
                ),
            )
          ],
        ),
      ),
    );
  }
}