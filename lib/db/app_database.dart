import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;
  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    final docs = await getApplicationDocumentsDirectory();
    final path = p.join(docs.path, 'pos_assessment.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY,
        orderDate TEXT,
        orderId INTEGER,
        itemId INTEGER,
        size TEXT,
        price REAL,
        qty INTEGER,
        orderStatus TEXT,
        total REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY,
        paymentDate TEXT,
        paymentId INTEGER,
        orderId INTEGER,
        amountDue REAL,
        tips REAL,
        discount REAL,
        totalPaid REAL,
        paymentType TEXT,
        paymentStatus TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE menu (
        itemId INTEGER PRIMARY KEY,
        itemName TEXT,
        catId INTEGER,
        menuId INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE menu_sizes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemId INTEGER,
        size TEXT,
        price REAL
      );
    ''');

    await db.execute('CREATE INDEX idx_orders_orderId ON orders(orderId);');
    await db.execute('CREATE INDEX idx_payments_orderId ON payments(orderId);');

    await _seedDatabase(db);
  }

  static Future _seedDatabase(Database db) async {
    final batch = db.batch();
    final menuItems = [
      {'itemId': 1, 'itemName': 'Item1', 'catId': 1, 'menuId': 1},
      {'itemId': 2, 'itemName': 'Item2', 'catId': 1, 'menuId': 1},
      {'itemId': 3, 'itemName': 'Item3', 'catId': 2, 'menuId': 2},
      {'itemId': 4, 'itemName': 'Item4', 'catId': 2, 'menuId': 2},
      {'itemId': 5, 'itemName': 'Item5', 'catId': 2, 'menuId': 1},
      {'itemId': 6, 'itemName': 'Item6', 'catId': 3, 'menuId': 1},
      {'itemId': 7, 'itemName': 'Item7', 'catId': 3, 'menuId': 1},
      {'itemId': 8, 'itemName': 'Item8', 'catId': 4, 'menuId': 2},
      {'itemId': 9, 'itemName': 'Item9', 'catId': 4, 'menuId': 2},
      {'itemId': 10, 'itemName': 'Item10', 'catId': 5, 'menuId': 2},
    ];
    for (var m in menuItems) {
      batch.insert('menu', m);
    }
    batch.insert('menu_sizes', {'itemId': 1, 'size': 'Small', 'price': 1.5});
    batch.insert('menu_sizes', {'itemId': 1, 'size': 'Large', 'price': 2.5});
    batch.insert('menu_sizes', {'itemId': 2, 'size': '', 'price': 3.0});
    batch.insert('menu_sizes', {'itemId': 3, 'size': '', 'price': 2.5});
    batch.insert('menu_sizes', {'itemId': 4, 'size': '', 'price': 1.5});
    batch.insert('menu_sizes', {'itemId': 5, 'size': '', 'price': 1.0});
    batch.insert('menu_sizes', {'itemId': 6, 'size': 'Small', 'price': 2.5});
    batch.insert('menu_sizes', {'itemId': 6, 'size': 'Large', 'price': 3.6});
    batch.insert('menu_sizes', {'itemId': 7, 'size': '', 'price': 2.5});
    batch.insert('menu_sizes', {'itemId': 8, 'size': 'Small', 'price': 3.75});
    batch.insert('menu_sizes', {'itemId': 8, 'size': 'Large', 'price': 6.5});
    batch.insert('menu_sizes', {'itemId': 9, 'size': '', 'price': 1.5});
    batch.insert('menu_sizes', {'itemId': 10, 'size': '', 'price': 2.0});
    final payments = [
      {'id':1,'paymentDate':'01 Oct 2025','paymentId':100,'orderId':10,'amountDue':9.25,'tips':0.0,'discount':0.0,'totalPaid':9.25,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':2,'paymentDate':'01 Oct 2025','paymentId':101,'orderId':11,'amountDue':21.25,'tips':0.0,'discount':0.0,'totalPaid':10.0,'paymentType':'Cash','paymentStatus':'Completed'},
      {'id':3,'paymentDate':'01 Oct 2025','paymentId':102,'orderId':11,'amountDue':21.25,'tips':0.0,'discount':0.0,'totalPaid':11.25,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':4,'paymentDate':'02 Oct 2025','paymentId':103,'orderId':12,'amountDue':17.0,'tips':3.0,'discount':4.0,'totalPaid':16.0,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':5,'paymentDate':'03 Oct 2025','paymentId':104,'orderId':13,'amountDue':15.5,'tips':0.0,'discount':2.0,'totalPaid':13.5,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':6,'paymentDate':'01 Oct 2025','paymentId':105,'orderId':14,'amountDue':42.8193,'tips':0.0,'discount':0.0,'totalPaid':20.0,'paymentType':'Cash','paymentStatus':'Completed'},
      {'id':7,'paymentDate':'01 Oct 2025','paymentId':106,'orderId':14,'amountDue':42.8193,'tips':0.0,'discount':0.0,'totalPaid':22.82,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':8,'paymentDate':'02 Oct 2025','paymentId':107,'orderId':15,'amountDue':5.136,'tips':0.0,'discount':0.0,'totalPaid':5.14,'paymentType':'Card','paymentStatus':'Refunded'},
      {'id':9,'paymentDate':'03 Oct 2025','paymentId':108,'orderId':16,'amountDue':19.758,'tips':0.0,'discount':0.0,'totalPaid':10.0,'paymentType':'Cash','paymentStatus':'Completed'},
      {'id':10,'paymentDate':'03 Oct 2025','paymentId':109,'orderId':16,'amountDue':19.758,'tips':0.0,'discount':0.0,'totalPaid':9.76,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':11,'paymentDate':'01 Oct 2025','paymentId':110,'orderId':17,'amountDue':10.8918,'tips':0.0,'discount':0.0,'totalPaid':10.9,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':12,'paymentDate':'05 Oct 2025','paymentId':111,'orderId':18,'amountDue':26.33588,'tips':2.0,'discount':0.0,'totalPaid':25.0,'paymentType':'Cash','paymentStatus':'Completed'},
      {'id':13,'paymentDate':'05 Oct 2025','paymentId':115,'orderId':18,'amountDue':26.33588,'tips':0.0,'discount':0.0,'totalPaid':3.34,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':14,'paymentDate':'01 Oct 2025','paymentId':116,'orderId':19,'amountDue':72.13188,'tips':0.0,'discount':0.0,'totalPaid':50.0,'paymentType':'Cash','paymentStatus':'Completed'},
      {'id':15,'paymentDate':'01 Oct 2025','paymentId':119,'orderId':19,'amountDue':72.13188,'tips':0.0,'discount':0.0,'totalPaid':22.13,'paymentType':'Card','paymentStatus':'Completed'},
      {'id':16,'paymentDate':'01 Oct 2025','paymentId':120,'orderId':20,'amountDue':52.2573,'tips':0.0,'discount':0.0,'totalPaid':25.0,'paymentType':'Cash','paymentStatus':'Completed'},
      {'id':17,'paymentDate':'01 Oct 2025','paymentId':121,'orderId':20,'amountDue':52.2573,'tips':0.0,'discount':0.0,'totalPaid':27.28,'paymentType':'Card','paymentStatus':'Completed'},
    ];
    for (var p in payments) {
      batch.insert('payments', p);
    }
    final orders = [
      {'id':1,'orderDate':'01 Oct 2025','orderId':10,'itemId':2,'size':null,'price':2.5,'qty':1,'orderStatus':'Completed','total':2.5},
      {'id':2,'orderDate':'01 Oct 2025','orderId':10,'itemId':3,'size':null,'price':1.5,'qty':2,'orderStatus':'Completed','total':3.0},
      {'id':3,'orderDate':'01 Oct 2025','orderId':10,'itemId':1,'size':'Small','price':3.75,'qty':1,'orderStatus':'Completed','total':3.75},
      {'id':4,'orderDate':'01 Oct 2025','orderId':11,'itemId':5,'size':null,'price':2.75,'qty':1,'orderStatus':'Completed','total':2.75},
      {'id':5,'orderDate':'01 Oct 2025','orderId':11,'itemId':6,'size':null,'price':1.75,'qty':2,'orderStatus':'Completed','total':3.5},
      {'id':6,'orderDate':'01 Oct 2025','orderId':11,'itemId':2,'size':null,'price':2.5,'qty':1,'orderStatus':'Completed','total':2.5},
      {'id':7,'orderDate':'01 Oct 2025','orderId':11,'itemId':3,'size':null,'price':3.5,'qty':1,'orderStatus':'Completed','total':3.5},
      {'id':8,'orderDate':'01 Oct 2025','orderId':11,'itemId':4,'size':null,'price':3.75,'qty':2,'orderStatus':'Completed','total':7.5},
      {'id':9,'orderDate':'01 Oct 2025','orderId':11,'itemId':5,'size':null,'price':1.5,'qty':1,'orderStatus':'Completed','total':1.5},
      {'id':10,'orderDate':'01 Oct 2025','orderId':12,'itemId':6,'size':'Large','price':5.5,'qty':2,'orderStatus':'Completed','total':11.0},
      {'id':11,'orderDate':'01 Oct 2025','orderId':12,'itemId':7,'size':null,'price':2.5,'qty':1,'orderStatus':'Completed','total':2.5},
      {'id':12,'orderDate':'01 Oct 2025','orderId':12,'itemId':1,'size':'Large','price':3.5,'qty':1,'orderStatus':'Completed','total':3.5},
      {'id':13,'orderDate':'01 Oct 2025','orderId':13,'itemId':1,'size':'Small','price':2.75,'qty':2,'orderStatus':'Completed','total':5.5},
      {'id':14,'orderDate':'01 Oct 2025','orderId':13,'itemId':6,'size':'Small','price':1.5,'qty':1,'orderStatus':'Completed','total':1.5},
      {'id':15,'orderDate':'01 Oct 2025','orderId':13,'itemId':8,'size':'Small','price':3.5,'qty':1,'orderStatus':'Completed','total':3.5},
      {'id':16,'orderDate':'01 Oct 2025','orderId':13,'itemId':1,'size':'Small','price':2.5,'qty':2,'orderStatus':'Completed','total':5.0},
    ];
    for (var o in orders) {
      batch.insert('orders', o);
    }
    await batch.commit(noResult: true);
  }
}
