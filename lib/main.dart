// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kraft',
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final audioName = "dados.mp3";
  final musicName = "daditos";
  final imageURL = "assets/images/and_cinco.png";
  AudioPlayer audioPlayer;
  AudioCache audioCache; //ESTE ES EL CONTROL DEL AUDIO

  //sensores
  void initState() {
    // TODO: implement initState
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
        audioPlayer = AudioPlayer();
        audioCache = AudioCache(fixedPlayer: audioPlayer);
      });
    }); //get the sensor data and set then to the data types
  }

  bool switch_sensor = true;
  double x = 0, y = 0, z = 0;
  String dado1 = "",
      dado2 = "",
      image1 = "assets/images/juegodados.png",
      image2 = "assets/images/juegodados.png";
  String resultado = "";
  bool sw = true;
  Random random = new Random();
  bool enableLanzar = true, enableRestart = false;
  String recuerdonro = "";
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kraft"),
      ),
      body: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          //color: Colors.red,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/canchaverde2.jpg")),
          //shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Jonatan Nicolas Mallea Carrasco",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            Text(
              "Juego del Kraft",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                image_dados(image1),
                image_dados(image2),
              ],
            ),
            Row(
              children: [
                Text("Recuerdo el 1er nro: " + recuerdonro),
              ],
            ),
            Text(
              resultado,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    child: Text("LANZAR"),
                    onPressed: enableLanzar ? _metodoLanzar : null),
                RaisedButton(
                    child: Text("REINICIAR"),
                    onPressed: enableRestart ? _metodoRestart : null),
              ],
            ),
            Table(
              border: TableBorder.all(
                  width: 2.0,
                  color: Colors.blueAccent,
                  style: BorderStyle.solid),
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "eje mov X : ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      movimiento_x(x),
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ])
              ],
            )
          ],
        ),
      ),
    );
  }

  String movimiento_x(double x) {
    setState(() {});
    String mov = "";
    print("valor x: ");
    print(x.toStringAsFixed(0));
    int move = int.parse(x.toStringAsFixed(0));
    if (x < 0.99) {
      mov = "derecha";
    }
    if (x > 0.99) {
      mov = "izquierda";
    }
    if (x < 0.99 && x > -0.99) {
      mov = "quieto";
    }
    if (x < -5.95 || x > 5.95) {
      mov = "brusco";

      if (switch_sensor) {
        audioCache.play(audioName);
        _metodoLanzar();
        if (resultado == "Perdiste!!" || resultado == "Ganaste!!") {
          switch_sensor = false;
        }
      }
    }
    return mov + "(" + move.toString() + ")";
  }

  void _metodoRestart() {
    setState(() {
      switch_sensor = true;
      dado1 = "";
      dado2 = "";
      image1 = "assets/images/juegodados.png";
      image2 = "assets/images/juegodados.png";
      resultado = "";
      enableLanzar = true;
      sw = true;
      recuerdonro = "";
      enableRestart = false;
      print("restart: ");
      print(enableRestart);
    });
  }

  void _metodoLanzar() {
    {
      setState(() {
        print("restart");
        print(enableRestart);
        int random1 = random.nextInt(6) + 1;
        dado1 = random1.toString();
        print("dado1 " + random1.toString());
        int random2 = random.nextInt(6) + 1;
        dado2 = random2.toString();
        print("dado2 " + random2.toString());
        dadosunidos(dado1, dado2, image1, image2);
        resultado = (int.parse(dado1) + int.parse(dado2)).toString();
        print(sw);
        String bandera = "";
        if (sw) {
          recuerdonro = resultado;
          sw = false;
          if (resultado == "7") {
            print("ganaste");
            bandera = "Ganaste!!";
            resultado = bandera;
            enableLanzar = false;
          } else {
            if (resultado == "2") {
              print("perdiste");
              bandera = "Perdiste!!";
              resultado = bandera;
              enableLanzar = false;
            } else {
              resultado = "El Juego es " + resultado;
            }
          }
        } else {
          if ((int.parse(dado1) + int.parse(dado2)).toString() == recuerdonro) {
            bandera = "Ganaste!!";
            resultado = bandera;
            enableLanzar = false;
          } else {
            if ((int.parse(dado1) + int.parse(dado2)).toString() == "7") {
              bandera = "Perdiste!!";
              resultado = bandera;

              enableLanzar = false;
            }
          }
        }
        if (bandera == "Perdiste!!" || bandera == "Ganaste!!") {
          enableRestart = true;
        }
      });
    }
  }

  void dadosunidos(String dato1, String dato2, String url1, String url2) {
    List dados = [
      "assets/images/juegodados.png",
      "assets/images/and_uno.png",
      "assets/images/and_dos.png",
      "assets/images/and_tres.png",
      "assets/images/and_cuatro.png",
      "assets/images/and_cinco.png",
      "assets/images/and_seis.png",
    ];
    switch (int.parse(dato1)) {
      case 1:
        {
          image1 = dados[1];
        }
        break;
      case 2:
        {
          image1 = dados[2];
        }
        break;
      case 3:
        {
          image1 = dados[3];
        }
        break;
      case 4:
        {
          image1 = dados[4];
        }
        break;
      case 5:
        {
          image1 = dados[5];
        }
        break;
      case 6:
        {
          image1 = dados[6];
        }
        break;
      default:
        break;
    }
    switch (int.parse(dato2)) {
      case 1:
        {
          image2 = dados[1];
        }
        break;
      case 2:
        {
          image2 = dados[2];
        }
        break;
      case 3:
        {
          image2 = dados[3];
        }
        break;
      case 4:
        {
          image2 = dados[4];
        }
        break;
      case 5:
        {
          image2 = dados[5];
        }
        break;
      case 6:
        {
          image2 = dados[6];
        }
        break;
      default:
        break;
    }
  }

  Container image_dados(String url) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        //color: Colors.red,
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(url)),
        //shape: BoxShape.circle,
      ),

      // ...
    );
  }
}
