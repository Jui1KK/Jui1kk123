import 'package:flutter/material.dart';
import 'showfiltertype.dart'; // Import หน้าแสดงรายการสินค้า

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(221, 188, 51, 51)),
        useMaterial3: true,
      ),
      home: showproducttype(), // เรียกหน้าแสดงประเภทสินค้า
    );
  }
}

class showproducttype extends StatefulWidget {
  @override
  _showproducttypeState createState() => _showproducttypeState();
}

class _showproducttypeState extends State<showproducttype> {
  // รายการประเภทสินค้า
List<Map<String, dynamic>> categories = [
  {'name': 'Electronics', 'icon': Icons.tv},
  {'name': 'Clothing', 'icon': Icons.shopping_bag}, 
  {'name': 'Food', 'icon': Icons.restaurant}, 
  {'name': 'Books', 'icon': Icons.library_books}, 
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประเภทสินค้า',
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
      body: Stack(
        children: [
          // พื้นหลังแบบไล่สี
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade100,
                  Colors.orange.shade100,
                  Colors.yellow.shade100,
                  Colors.green.shade100,
                  Colors.blue.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // การแสดงผลรายการประเภทสินค้าในกริด
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // กำหนดจำนวนคอลัมน์ในกริด
                crossAxisSpacing: 20, // เว้นระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 20, // เว้นระยะห่างระหว่างแถว
              ),
              itemCount: categories.length, // จำนวนประเภทสินค้า
              itemBuilder: (context, index) {
                final category =
                    categories[index]; // การเข้าถึงประเภทสินค้าแต่ละตัว
                return GestureDetector(
                  onTap: () {
                    // เมื่อกดที่ประเภทสินค้า, แอปจะนำผู้ใช้ไปยังหน้าจอแสดงสินค้าของประเภทนั้น
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showfiltertypect(
                          selectedCategory: category['name'], // ส่งประเภทที่เลือกไปยังหน้าใหม่
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5, // ความสูงของการ์ด
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // ขอบมนของการ์ด
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // จัดตำแหน่งไอคอนและข้อความ
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
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
                            ).createShader(bounds),
                            child: Icon(
                              category['icon'],
                              size: 65,
                              color: Colors.white, // ใช้ ShaderMask สำหรับไล่สี
                            ),
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่างไอคอนและข้อความ
                          Text(
                            category['name'], // ชื่อประเภทสินค้า
                            style: TextStyle(
                              color: Colors.red, // สีของข้อความ
                              fontSize: 18,
                              fontWeight: FontWeight.w600, // รูปแบบตัวอักษร
                            ),
                            textAlign:
                                TextAlign.center, // จัดตำแหน่งข้อความให้ตรงกลาง
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
