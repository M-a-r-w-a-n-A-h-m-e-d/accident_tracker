import 'package:postgres/postgres.dart';
import '../../flavors.dart';
import 'dart:developer';

class DataBase {
  // Constructor with named parameters
  DataBase({
    this.name,
    required this.email,
    required this.password,
    this.id,
  });

  final int? id;
  final String? name;
  final String email;
  final String password;

  PostgreSQLConnection? _connection;

  Future<void> connection() async {
    // Initialize the database connection
    _connection = PostgreSQLConnection(
      'roundhouse.proxy.rlwy.net', // host
      57698, // port
      'railway', // database name
      username: 'postgres',
      password: 'UhxWkuzyNoDSTXftBrCMUeVjvZvSiYIi',
    );

    try {
      // Open the connection
      await _connection!.open();

      // Get the table name based on the flavor
      String table = _getTableForFlavor();

      // Create the tables
      await createTables();

      // Insert the user data
      await insertUserData(table);
    } catch (e) {
      log("Error connecting to the database: $e");
    } finally {
      // Ensure the connection is closed
      await _connection?.close();
    }
  }

  String _getTableForFlavor() {
    // Return the appropriate table name based on the app flavor
    return F.appFlavor == Flavor.unit
        ? 'units'
        : F.appFlavor == Flavor.production
            ? 'users'
            : F.appFlavor == Flavor.staging
                ? 'testers'
                : 'developers';
  }

  Future<void> createTables() async {
    try {
      // List of tables to create
      List<String> tables = ['units', 'users', 'testers', 'developers'];
      if (email.isEmpty && password.isEmpty) {
        _connection = PostgreSQLConnection(
          'roundhouse.proxy.rlwy.net', // host
          57698, // port
          'railway', // database name
          username: 'postgres',
          password: 'UhxWkuzyNoDSTXftBrCMUeVjvZvSiYIi',
        );
        await _connection!.open();
      }

      // Iterate through each table and create if not exists
      for (String table in tables) {
        await _connection!.query(
          'CREATE TABLE IF NOT EXISTS $table (id SERIAL PRIMARY KEY, username TEXT NOT NULL CHECK (LENGTH(username) >= 3), email TEXT UNIQUE NOT NULL, user_password TEXT NOT NULL)',
        );
      }
    } catch (e) {
      log("Error creating tables: $e");
    } finally {
      if (email.isEmpty && password.isEmpty) {
        await _connection?.close();
      }
    }
  }

  Future<List<List>?> searchWithEmail(String email) async {
    try {
      _connection = PostgreSQLConnection(
        'roundhouse.proxy.rlwy.net', // host
        57698, // port
        'railway', // database name
        username: 'postgres',
        password: 'UhxWkuzyNoDSTXftBrCMUeVjvZvSiYIi',
      );

      await _connection!.open();

      // Get the table name based on the flavor
      String table = _getTableForFlavor();

      // Query the database for the user with the given email
      List<List<dynamic>> result = await _connection!.query(
        'SELECT * FROM $table WHERE email = @email',
        substitutionValues: {'email': email},
      );

      return result;
    } catch (e) {
      log('error searching for email: $e');
    }

    await _connection?.close();

    return null;
  }

  Future<void> insertUserData(String table) async {
    try {
      // Check if the user already exists
      List<List<dynamic>> result;
      if (id != null) {
        result = await _connection!.query(
          'SELECT * FROM $table WHERE id = @id',
          substitutionValues: {'id': id},
        );
      } else {
        result = await _connection!.query(
          'SELECT * FROM $table WHERE email = @email',
          substitutionValues: {'email': email},
        );
      }

      // If the user doesn't exist, insert new data
      if (result.isEmpty) {
        await _connection!.query(
          'INSERT INTO $table (username, email, user_password) VALUES (@name, @email, @password)',
          substitutionValues: {
            'name': name,
            'email': email,
            'password': password,
          },
        );
        log('User inserted successfully into table $table.');
      } else {
        log('User with ID $id already exists in table $table.');
      }
    } catch (e) {
      log("Error inserting data into table $table: $e");
    }
  }
}
