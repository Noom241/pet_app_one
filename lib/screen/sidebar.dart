import 'package:flutter/material.dart';
import 'MascotasScreen.dart';
import 'AdopcionesScreen.dart';
import 'package:pet_app_one/auth/report_pet.dart'; // Importar la pantalla de reportar mascota
import 'profile.dart'; // Importar la pantalla de perfil

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del Drawer (puede incluir una imagen o texto)
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Container(
              width: double.infinity, // Esto asegura que el ancho sea total
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Mascotas App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Opciones del menú
          ListTile(
            leading: const Icon(Icons.pets, color: Colors.teal),
            title: const Text('Ver Mascotas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MascotasScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Colors.red),
            title: const Text('Reportar Mascota'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportPetScreen()),
              );
            },
          ),
          // Nueva opción para ver el perfil
          ListTile(
            leading: const Icon(Icons.person, color: Colors.teal),
            title: const Text('Ver Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const Spacer(),
          // Pie de página del Drawer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Icon(Icons.settings, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Configuración',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
