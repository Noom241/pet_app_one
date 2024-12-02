import 'package:flutter/material.dart';
import 'package:pet_app_one/auth/auth_service.dart'; // Importar AuthService
import 'DetallesMascotaScreen.dart';
import 'MascotaCard.dart';
import 'sidebar.dart'; // Importar el Sidebar

class MascotasScreen extends StatefulWidget {
  const MascotasScreen({super.key});

  @override
  State<MascotasScreen> createState() => _MascotasScreenState();
}

class _MascotasScreenState extends State<MascotasScreen> {
  late Future<List<Map<String, dynamic>>> _mascotasFuture;

  @override
  void initState() {
    super.initState();
    _mascotasFuture = _fetchMascotas(); // Llamar al método para obtener mascotas
  }

  Future<List<Map<String, dynamic>>> _fetchMascotas() async {
    try {
      // Obtener las IDs de las mascotas no adoptadas
      final List<dynamic> response = await AuthService.getUnadoptedPets();
      print('Response de getUnadoptedPets: $response');

      // Asegúrate de extraer solo las IDs de los objetos de manera segura
      final ids = response.map((item) {
        final id = item['id_mascota'];
        return (id is String) ? int.tryParse(id) : id as int;
      }).where((id) => id != null).toList();

      print('IDs extraídas: $ids');

      // Si no hay IDs, retornar una lista vacía
      if (ids.isEmpty) return [];

      // Obtener detalles de cada mascota usando su ID
      final mascotas = <Map<String, dynamic>>[];

      for (var id in ids) {
        try {
          // Obtener mascota por ID
          final mascota = await AuthService.getPetById(id as int); // El id ahora es un int
          if (mascota != null) {
            mascotas.add(mascota);
            print('Mascota obtenida: $mascota');
          } else {
            print('No se encontró mascota con ID: $id');
          }
        } catch (e) {
          print('Error al obtener mascota con ID: $id. Error: $e');
        }
      }

      return mascotas;
    } catch (e) {
      throw Exception("Error al obtener las mascotas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mascotas Reportadas'),
        backgroundColor: Colors.teal,
      ),
      drawer: const SideBar(), // Agregar el Drawer en el Scaffold
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>( // Usar el FutureBuilder
          future: _mascotasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final mascotas = snapshot.data!;
              if (mascotas.isEmpty) {
                return const Center(child: Text('No hay mascotas disponibles.'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: GridView.builder(
                  itemCount: mascotas.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    // Agregar GestureDetector para manejar el click en la tarjeta
                    return GestureDetector(
                      onTap: () {
                        // Navegar a la pantalla de detalles y pasar la información de la mascota
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesMascotaScreen(
                              mascota: mascotas[index], // Pasar la mascota seleccionada
                            ),
                          ),
                        );
                      },
                      child: MascotaCard(mascota: mascotas[index]), // Tu tarjeta de mascota
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('Algo salió mal.'));
          },
        ),
      ),
    );
  }
}
