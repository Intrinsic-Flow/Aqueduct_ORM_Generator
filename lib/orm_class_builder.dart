import 'dart:convert';
import 'dart:core';
import 'dart:io';

Future<void> ClassBuilder(
    String _table,
    List<List<dynamic>> _columns,
    List<List<dynamic>> _key) async {

  final _imports = "import 'package:aqueduct/aqueduct.dart';\n"
                   "import 'package:flow_framework/flow_framework.dart';\n\n";

  final _managed_object_class = 'class $_table extends ManagedObject<_$_table> implements _$_table {\n\n';
  final _override_willUpdate = '@override\n   void willUpdate() {}\n\n';
  final _override_willInsert = '@override\n   void willInsert() {}\n}\n\n';

  final _header = '@Table(name: "$_table")\n'
                  'class _$_table {\n';
  String _primaryKey;
  String _body;
  String _datatype;

  for(var row in _columns) {

    switch (row[1].toString()) {
      case 'text':
        _datatype = 'String';
        break;
      case 'varchar':
        _datatype = 'String';
        break;
      case 'bpchar':
        _datatype = 'String';
        break;
      case 'timestamp':
        _datatype = 'DateTime';
        break;
      case 'date':
        _datatype = 'DateTime';
        break;
      case 'time':
        _datatype = 'DateTime';
        break;
      case 'numeric':
        _datatype = 'double';
        break;
      case 'float8':
        _datatype = 'double';
        break;
      case 'int8':
        _datatype ='\n  @Column(databaseType: Managed.bigInteger)\n  int';
        break;
      case 'bytea':
        _datatype = 'Document';
        break;
      default:
        _datatype = row[1].toString();
    }
    if(_key.isNotEmpty) {
      var key = _key[0];
      if(row[0] == key[0]){
        _primaryKey = '\n@primaryKey\n';
      } else {
        _primaryKey = '';
      }
    }
      _body = '   $_primaryKey${_datatype} ${row[0]};\n${_body}';
  }
  final _footer = '}\n';

  final _fileContents = '$_imports$_managed_object_class$_override_willUpdate'
                        '$_override_willInsert$_header'
                        '${_body.replaceAll('null', '')}$_footer';
  print(_table);
  final output = File('/development/IF_PROJECTS/flow_framework/lib/model/${_table}.dart').openWrite();
  output.write(_fileContents);
}