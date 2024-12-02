import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// Configura el logger
final logger = Logger();

class AuthService {
  
  static const String _baseUrl = "https://aqua-noelle-96.tiiny.io"; // Cambia esto por la URL correcta

  // Función para registrar un usuario
  static Future<bool> register(
    String nombre,
    String email,
    String password,
    String telefono,
    String direccion,
    String rol, // 'Administrador', 'Voluntario', 'Adoptante'
    ) async {
      final response = await http.post(
        Uri.parse("$_baseUrl?operation=register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "email": email,
          "password": password, // La contraseña se enviará sin encriptar, el servidor se encarga de encriptarla
          "telefono": telefono,
          "direccion": direccion,
          "rol": rol, // Asumiendo que se envía uno de los valores válidos para rol
        }),
      );

      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["success"];
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    }


  // Función para iniciar sesión (login)
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?operation=login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"];
    }
    return false;
  }

  // Función para verificar si la tabla 'users' existe
  static Future<bool> checkTable() async {
    final response = await http.get(
      Uri.parse("$_baseUrl?operation=check_table"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["success"];
    }
    return false;
  }

  static Future<bool> reportPet(
    int idUsuario,
    String nombre,
    String tipo,
    String raza,
    int edad,
    String sexo,
    String tamano,
    String estadoSalud,
    String caracteristicas,
    String foto,
    String ubicacion,
    String descripcion,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?operation=report_pet"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id_usuario": idUsuario,
        "nombre": nombre,
        "tipo": tipo,
        "raza": raza,
        "edad": edad,
        "sexo": sexo,
        "tamano": tamano,
        "estado_salud": estadoSalud,
        "caracteristicas": caracteristicas,
        "foto": foto,
        "ubicacion": ubicacion,
        "descripcion": descripcion,
      }),
    );

    // Verificar si la respuesta fue exitosa
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"]) {
        print('Reporte de mascota enviado con éxito.');
        return true;
      } else {
        print('Error: ${data["message"]}');
        return false;
      }
    } else {
      print('Error: ${response.statusCode}');
      return false;
    }
  }

  // Método para obtener un usuario por su email
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?operation=get_user_by_email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      logger.d("Enviando email: $email");
      final data = jsonDecode(response.body);
      if (data["success"]) {
        return data["data"]; // Datos del usuario
      } else {
        logger.w("Usuario no encontrado: ${data["message"]}");
      }
    } else {
      logger.e("Error al obtener usuario: ${response.statusCode}");
    }

    return null; // Retorna null si falla
  }

  // Método para obtener mascotas no adoptadas
  static Future<List<Map<String, dynamic>>> getUnadoptedPets() async {
    final response = await http.get(
      Uri.parse("$_baseUrl?operation=get_unadopted_pets"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"]) {
        return List<Map<String, dynamic>>.from(data["data"]); // Convierte a una lista de mapas
      } else {
        logger.w("No se encontraron mascotas no adoptadas: ${data["message"]}");
      }
    } else {
      logger.e("Error al obtener mascotas no adoptadas: ${response.statusCode}");
    }
    return []; // Retorna una lista vacía si falla
  }

  // Método para obtener una mascota por su ID
  static Future<Map<String, dynamic>?> getPetById(int idMascota) async {
    final response = await http.post(
      Uri.parse("$_baseUrl?operation=get_pet_by_id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_mascota": idMascota}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["success"]) {
        return data["data"]; // Retorna la mascota como un mapa
      } else {
        logger.w("Mascota no encontrada: ${data["message"]}");
      }
    } else {
      logger.e("Error al obtener mascota: ${response.statusCode}");
    }
    return null; // Retorna null si falla
  }


}