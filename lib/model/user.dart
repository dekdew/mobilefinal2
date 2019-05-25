import 'package:sqflite/sqflite.dart';

final String tableUser = "user";
final String columnId = "id";
final String columnUserId = "userid";
final String columnName = "name";
final String columnAge = "age";
final String columnPassword = "password";
final String columnQuote = "quote";

class User {
  int id;
  String userid;
  String name;
  String age;
  String password;
  String quote;

  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnUserId: userid,
      columnName: name,
      columnAge: age,
      columnPassword: password,
      columnQuote: quote,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  User.formMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.userid = map[columnUserId];
    this.name = map[columnName];
    this.age = map[columnAge];
    this.password = map[columnPassword];
    this.quote = map[columnQuote];
  }

  @override
  String toString() {
    return 'id: ${this.id}, userid:  ${this.userid}, name:  ${this.name}, age:  ${this.age}, password:  ${this.password}, quote:  ${this.quote}';
  }
}

class UserProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableUser (
        $columnId integer primary key autoincrement,
        $columnUserId text not null unique,
        $columnName text not null,
        $columnAge text not null,
        $columnPassword text not null,
        $columnQuote text
      )
      ''');
    });
  }

  Future<User> registerUser(User user) async {
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableUser,
        columns: [
          columnId,
          columnUserId,
          columnName,
          columnAge,
          columnPassword,
          columnQuote
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    return maps.length > 0 ? new User.formMap(maps.first) : null;
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    return db.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future<List<User>> getAllUser() async {
    await this.open("user.db");
    var res = await db.query(tableUser, columns: [
      columnId,
      columnUserId,
      columnName,
      columnAge,
      columnPassword,
      columnQuote
    ]);
    List<User> userList =
        res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}
