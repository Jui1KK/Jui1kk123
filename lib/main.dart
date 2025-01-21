import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlineapp_siwat_secb/showproductgrid.dart';
import 'addproduct.dart';
import 'showproducttype.dart';
// Main entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAlyVbxrJ7sgSu-DCdZBgDhJxjvL2lteWE",
            authDomain: "rmutt-secb.firebaseapp.com",
            databaseURL: "https://rmutt-secb-default-rtdb.firebaseio.com",
            projectId: "rmutt-secb",
            storageBucket: "rmutt-secb.firebasestorage.app",
            messagingSenderId: "442089263032",
            appId: "1:442089263032:web:f39ef801bae0a0e440494d",
            measurementId: "G-C08HX3MZP0"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// Stateless widget for the main app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

// Stateful widget for the main screen
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/image/121.png'),
        SizedBox(width: 5), // Optional, to add some spacing between images
        Image.asset('assets/image/123.png'),
        SizedBox(width: 5),
        Image.asset('assets/image/12.png'),
      ],
    ),
  ),
  title: Text(
    'จัดการข้อมูล',
    style: TextStyle(
      color: Color.fromARGB(221, 255, 255, 255),
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
  ),
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.purple,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => addproduct(),
                          ),
                        );
                      },
                      child: Text('จัดการข้อมูลสินค้า'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => showproductgrid(), //รอเปลี่ยนนนนนน
                          ),
                        );
                      },
                      child: Text('แสดงข้อมูลสินค้า'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => showproducttype(), //รอเปลี่ยนนนนนน
                          ),
                        );
                      },
                      child: Text('ประเภทสินค้า'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}