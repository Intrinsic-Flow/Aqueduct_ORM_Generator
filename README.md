***Aqueduct ORM Generator***

A CLI application to generate model class files for Aqueduct using an existing schema in postgresSQL.
There are 2 files - 
 - main.dart includes the DB connection props
 - orm_class_builder.dart contains the file contents and file writing
 
 Some things have to be adapted to use, you need to change the DB details in main.dart and then add any 
 extra imports and export directory in orm_class_builder.dart.
