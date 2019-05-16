import 'dart:io';
import 'dart:core';

import 'package:postgres/postgres.dart';
import '../lib/orm_class_builder.dart';

main(List<String> arguments) async {
  String host = 'localhost';
  int port = 32768;
  String db = 'moqui_data';
  String dbUser = 'postgres';
  String dbPassword = '';
  String table = 'information_schema.tables';
  String column = 'information_schema.columns';
  String _table_query = "SELECT table_name FROM $table WHERE table_name NOT LIKE 'pg_%';";
  String _column_query;
  String _key_query;
  String _table;

  var connection = PostgreSQLConnection(host, port, db, username: dbUser, password: dbPassword);
  await connection.open();

  String capitalizeFirstLetter(String s) =>
      (s?.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  List<List<dynamic>> results = await connection.query(_table_query);

  for (final row in results) {
    _table = row[0].toString();
    // print('table: $_table');
    _column_query = "SELECT column_name, udt_name FROM $column "
                    "WHERE table_name = '$_table' AND table_schema='public';";
    _key_query = "select distinct "
                  "constraint_column_usage.column_name "
                  "from information_schema.table_constraints "
                  "left outer join information_schema.constraint_column_usage "
                  "on table_constraints.table_name = constraint_column_usage.table_name "
                  "where table_constraints.table_name = '$_table' "
                  "AND table_constraints.constraint_type = 'PRIMARY KEY';";
    List<List<dynamic>> columnResults = await connection.query(_column_query);
    List<List<dynamic>> keyResult = await connection.query(_key_query);
    // for (final column in columnResults) {
     // print('   column: ${column[0]}, type: ${column[1]}');
    // }
    //TODO: Pass the _table and columnResults to a library to parse into model class
    if (columnResults.isNotEmpty) {
      await ClassBuilder(capitalizeFirstLetter(_table), columnResults, keyResult);
    }
  }
  await connection.close();
  exit(0);


}

