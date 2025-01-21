import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      home: showproductgrid(),
    );
  }
}

class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        });
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
        setState(() {
          products = loadedProducts;
        });
        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
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

  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
                fetchProducts(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลใหม่เพื่อแสดงผลหลังการแก้ไขเช่น fetchProducts
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController categoryController =
        TextEditingController(text: product['category']);
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController productionDateController =
        TextEditingController(text: product['productionDate']);
    //สร้าง dialog เพื่อแสดงข้อมูลเก่าและให้กรอกข้อมูลใหม่เพื่อแก้ไข
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: productionDateController,
                  decoration:
                      InputDecoration(labelText: 'วันที่ผลิต (yyyy-MM-dd)'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(product['productionDate']),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      productionDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  readOnly: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'category': categoryController.text,
                  'quantity': int.parse(quantityController.text),
                  'price': int.parse(priceController.text),
                  'productionDate': productionDateController.text,
                };

                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop();
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แสดงข้อมูลสินค้า',
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
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
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
                                    product['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'รายละเอียดสินค้า',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ' ${product['description']}',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'ราคา : ${product['price']} บาท',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 80,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .red[50], // พื้นหลังสีแดงอ่อน
                                            shape:
                                                BoxShape.circle, // รูปทรงวงกลม
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              showDeleteConfirmationDialog(
                                                  product['key'], context);
                                            },
                                            icon: Icon(Icons.delete),
                                            color: Colors.red, // สีของไอคอน
                                            iconSize: 30,
                                            tooltip: 'ลบสินค้า',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 80,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .red[50], // พื้นหลังสีแดงอ่อน
                                            shape:
                                                BoxShape.circle, // รูปทรงวงกลม
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              showEditProductDialog(product);
                                            },
                                            icon: Icon(Icons.edit),
                                            color: Colors.red, // สีของไอคอน
                                            iconSize: 30,
                                            tooltip: 'แก้ไขสินค้า่',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
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
