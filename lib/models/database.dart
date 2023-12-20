import 'dart:async';
import 'package:floor/floor.dart';
import 'package:floor/floor.dart';
import 'package:floor/floor.dart';
import 'package:floor/floor.dart';

import 'article.dart';
import 'dao.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite; // the generated code will be there
part 'database.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
}