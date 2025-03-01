import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'productdetail.dart'; // นำเข้าไฟล์ ProductDetail ที่เราได้สร้างขึ้น

class showfiltertypect extends StatefulWidget {
  final String selectedCategory; // รับค่าประเภทสินค้าที่เลือกจากหน้าก่อนหน้า

  showfiltertypect({required this.selectedCategory});

  @override
  _showfiltertypectState createState() => _showfiltertypectState();
}

class _showfiltertypectState extends State<showfiltertypect> {
  DatabaseReference dbRef = FirebaseDatabase.instance
      .ref('products'); // สร้างการเชื่อมต่อกับ Firebase Realtime Database
  List<Map<String, dynamic>> products =
      []; // ตัวแปรเก็บสินค้าที่โหลดจาก Firebase

  Future<void> fetchProducts() async {
    // ฟังก์ชันดึงข้อมูลสินค้า
    try {
      final snapshot = await dbRef.get(); // ดึงข้อมูลจาก Firebase
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];

        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;

          // กรองสินค้าตามประเภทที่เลือก
          if (product['category'] == widget.selectedCategory) {
            loadedProducts.add(product); // เพิ่มสินค้าในรายการที่กรอง
          }
        });

        setState(() {
          products = loadedProducts; // อัพเดทข้อมูลสินค้า
        });
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
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
          child: Text(
            'แสดงข้อมูลสินค้า ${widget.selectedCategory}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w400,
            ),
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
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: ShaderMask(
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
                          child: Text(
                            product['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: Text(
                                'รายละเอียดสินค้า: ${product['description']}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Text(
                              'ประเภท: ${product['category']}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Text(
                              'วันที่ผลิตสินค้า: ${formatDate(product['productionDate'])}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Text(
                              'จำนวน: ${product['quantity']}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                         Text(
                            'ราคา : ${product['price']} บาท',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                            
                          ],
                        ),
                        trailing: 
                            SizedBox(
                              width: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[50], // พื้นหลังสีแดงอ่อน
                                  shape: BoxShape.circle, // รูปทรงวงกลม
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red, // สีของไอคอน
                                  iconSize: 30,
                                  tooltip: 'ลบสินค้า',
                                ),
                              ),
                            ),
                          
                       
                     
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetail(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
