import 'package:puppy_app/models/posts_viewed.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _intDB();
      return _db;
    }
    return _db;
  }

  _intDB() async {
    var dbPath = await getDatabasesPath();
    var pa = join(dbPath, 'dog.db');
    Database db = await openDatabase(pa, onCreate: _onCreateDb, version: 1);
    return db;
  }

  _onCreateDb(Database? database, int version) async {
    await database?.execute(
        'CREATE TABLE viewed_posts(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,image TEXT,fact TEXT,date TEXT,isFav INTEGER,isViewed INTEGER)');
  }

  readPost(String sql) async {
    var db = await this.db;
    var res = await db?.rawQuery(sql);
    return res;
  }

  updatePost(PostsViewed post, int postId) async {
    var db = await this.db;
    var res = await db?.rawUpdate(
      'update viewed_posts set isFav = ?, isViewed = ? where id = ?',
      [
        post.isFavorite! ? 1 : 0,
        post.isViewed! ? 1 : 0,
        postId,
      ],
    );

    return res;
  }

  deleteAllFavPosts() async {
    var db = await this.db;
    var res = await db?.rawUpdate('update viewed_posts set isFav = 0');
    return res;
  }

  deleteAllLatestViewedPosts() async {
    var db = await this.db;
    var res = await db?.rawUpdate('update viewed_posts set isViewed = 0');
    return res;
  }

  insertPost(PostsViewed post) async {
    try {
      var db = await this.db;
      var res = await db?.rawInsert(
        'INSERT INTO viewed_posts(name,image,fact,date,isFav,isViewed) VALUES(?,?,?,?,?,?)',
        [
          post.post!.name,
          post.post!.imageUrl,
          post.post!.fact,
          post.date,
          post.isFavorite,
          post.isViewed,
        ],
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

/*   deleteData(String sql) async {
    var db = await this.db;
    var res = await db?.rawDelete(sql);
    return res;
  } */
}
