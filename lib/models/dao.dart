import 'package:floor/floor.dart';

import 'article.dart';

// dao/person_dao.dart

import 'package:floor/floor.dart';

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPeople();

  @Query('SELECT name FROM Person')
  Stream<List<String>> findAllPeopleName();

  @Query('SELECT * FROM Person WHERE title = :title')
  Stream<Person?> findArticle(String title);

  @Query('DELETE FROM Person WHERE title = :title')
  Future<void>  removeArticle(String title);

  @insert
  Future<void> insertPerson(Person person);
}