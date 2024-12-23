import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class DataBase extends StatelessWidget {
  const DataBase({super.key});

  Future<void> connection() async {
    final connection = PostgreSQLConnection(
      'junction.proxy.rlwy.net',//host
      58962,//port
      'railway',//database name
      username: 'postgres',
      password: 'NoDfSEBGShvkTpcUZIUGMtzgPxMccDqc',
    );

    try {
      await connection.open();

      await insertData(connection, 2, 'New Name', 100);

      List<List<dynamic>> result = await connection.query(
        'SELECT * FROM a_table WHERE id = @id',
        substitutionValues: {'id': 2},
      );

      if (result.isNotEmpty) {
        print(result.first.asMap());
      } else {
        print('No results found for the given ID.');
      }
    } catch (e) {
      print("Error connecting to the database: $e");
    } finally {
      await connection.close();
    }
  }

  Future<void> insertData(
    PostgreSQLConnection connection,
    int id,
    String name,
    int totals,
  ) async {
    try {
      await connection.query(
        'INSERT INTO a_table (id, name, totals,totalss) VALUES (@id, @name, @totals)',
        substitutionValues: {'id': id, 'name': name, 'totals': totals},
      );

      print('Data inserted successfully.');
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    connection();

    return const Scaffold(
      body: Center(child: Text('Database Connection Example')),
    );
  }
}
