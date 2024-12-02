import 'package:flutter/material.dart';
import 'MascotasScreen.dart';
import 'AdopcionesScreen.dart';
import 'package:pet_app_one/auth/report_pet.dart'; // Importar la pantalla de reportar mascota

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Imagen con URL (representando la mascota)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    mascotaIllistration, // Utilizando la URL de la imagen de mascota
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // Título y descripción informativa
              InfoCard(
                title: "¡Bienvenido!",
                description:
                "Descubre las mejores mascotas para adoptar y ver nuevas oportunidades.",
              ),
              const Spacer(),
              // Botones para navegar a otras pantallas
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MascotasScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Ver Mascotas'),
              ),
              const SizedBox(height: 16),
              // Botón para Reportar Mascota
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportPetScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.red, // Color rojo para destacar
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Reportar Mascota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título con estilo destacado
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            // Descripción centrada
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16 * 2.5),
          ],
        ),
      ),
    );
  }
}

// URL de la imagen para la ilustración (mascota)
const mascotaIllistration = 'https://static.vecteezy.com/system/resources/previews/029/822/720/non_2x/cute-dog-transparent-background-png.png';
