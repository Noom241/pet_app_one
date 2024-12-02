import 'package:flutter/material.dart';

class MascotaCard extends StatelessWidget {
  final Map<String, dynamic> mascota;

  const MascotaCard({required this.mascota, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              mascota['foto'] ?? 'https://via.placeholder.com/150',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mascota['nombre'] ?? 'Sin nombre',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text('Tipo: ${mascota['tipo'] ?? 'Desconocido'}'),
                Text('Estado: ${mascota['estado'] ?? 'Desconocido'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
