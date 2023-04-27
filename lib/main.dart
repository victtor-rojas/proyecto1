import 'dart:html';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:proyecto1/View/Geoposition.dart';
import 'package:proyecto1/view/Registro.dart';
import 'package:proyecto1/view/Rest.dart';
import '../DTO/User.dart';
import 'package:proyecto1/View/Administrador.dart';
import 'package:proyecto1/View/Invitado.dart';
import 'firebase_options.dart';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  Homestrat createState() => Homestrat();
}

class Homestrat extends State<Home>{
  TextEditingController user = TextEditingController();
  TextEditingController paswword = TextEditingController();
  User objUser = User();
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> biometrico() async {
    //print("biométrico");

    // bool flag = true;
    bool authenticated = false;

    const androidString = const AndroidAuthMessages(
      cancelButton: "Cancelar",
      goToSettingsButton: "Ajustes",
      signInTitle: "Ingrese",
      //fingerprintNotRecognized: 'Error de reconocimiento de huella digital',
      goToSettingsDescription: "Confirme su huella",
      //fingerprintSuccess: 'Reconocimiento de huella digital exitoso',
      biometricHint: "Toque el sensor",
      //signInTitle: 'Verificación de huellas digitales',
      biometricNotRecognized: "Huella no reconocida",
      biometricRequiredTitle: "Required Title",
      biometricSuccess: "Huella reconocida",
      //fingerprintRequiredTitle: '¡Ingrese primero la huella digital!',
    );
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    // bool isBiometricSupported = await auth.();
    bool isBiometricSupported = await auth.isDeviceSupported();

    List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    print(canCheckBiometrics); //Returns trueB
    // print("support -->" + isBiometricSupported.toString());
    print(availableBiometrics.toString()); //Returns [BiometricType.fingerprint]
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Autentíquese para acceder",
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
          androidAuthStrings: androidString);
      if (!authenticated) {
        authenticated = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    /* if (!mounted) {
        return;
      }*/

    return authenticated;
  }

  validarDatos() async{
    try{
      CollectionReference ref=
      FirebaseFirestore.instance.collection("Usuarios");
      QuerySnapshot usuario= await ref.get();

      if(usuario.docs.length !=0){
 for(var cursor in usuario.docs){
   if(cursor.get("CorreoUsuario")==user.text){
     print("usuario Encontrado");
     print(cursor.get("NombreUsuario"));
     if(cursor.get("ContraseñaUsuario")==paswword.text){
       print("************************Acceso aceptado***********");
       mensaje('Bienvenido', cursor.get('rol'));
       objUser.nombre = cursor.get("NombreUsuario");
       objUser.id = cursor.get("IdentidadUsuario");
       objUser.role = cursor.get("rol");

     }else
       print('********** Acceso denegado **********');
   }
 }
      }else{
        print("No hay documentos en la coleccion");
      }
      print("Envio correcto");

    }catch(e){
      print("ERROR..."+e.toString());
    }
  }
  void mensaje(String titulo,String contenido) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(contenido),
            actions: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  //Navigator.pop(context);
                  if(objUser.role=='administrador'){
                    //Navigator.push(context, MaterialPageRoute(builder: (_) => Administrador()));
                  }else if(objUser.role=='invitado'){
                    //Navigator.push(context, MaterialPageRoute(builder: (_) => Invitado()));
                  }
                },
                child:
                Text('OK', style: TextStyle(color:Colors.blueGrey)),
              )
            ],
          );
        });
  }

  Widget build(BuildContext context){
    return MaterialApp(
      title: "Bienvenidos",
      home:Scaffold(
        appBar: AppBar(
          title: Text("Ingrese login"),
        ),
        body:SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Container(
                width: 200,
                height: 200,
                child: Image.asset('img/login.png'),
              )),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: user,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Email Usuario',
                      hintText: 'Digite email de Usuario'),
                ),
              ),
        Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          controller: user,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              labelText: 'Email Usuario',
              hintText: 'Digite email de usuario '),
          obscureText: true,
        ),
      ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Geoposition()));

                    paswword.text = sha1.convert(utf8.encode(paswword.text)).toString();
                    print('contrasena original ${paswword.text}');
                    print('crypto SHA-1 :' + paswword.text);
                    print('***** Ingresando *****');
                    validarDatos();
                  },
                  child: Text('Enviar'),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Registro(objUser)));
                  },
                  child: Text('Registrar'),
                ),
              ),
              Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: Colors.black45,
                  ),
                  onPressed: () async {
                    if (await biometrico()){
                      mensaje('Huella', 'HuellaEncontrada');
                    }
                    biometrico();
                  },
                  child: Icon(Icons.fingerprint, size:80),
              ),
              ),
              Padding(padding: EdgeInsets.only(top:20, left:50, right: 10),
                child: ElevatedButton(
                  onPressed: (){

                    Navigator.push(context, MaterialPageRoute(builder: (_)=> Rest()));


                  },
                  child: Text('Rest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

