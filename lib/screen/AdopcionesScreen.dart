import 'package:flutter/material.dart';
import 'MascotaCard.dart';
import 'sidebar.dart'; // Importa tu Sidebar

class AdopcionesScreen extends StatelessWidget {
  AdopcionesScreen({super.key});

  // Lista de ejemplo de mascotas
  final List<Map<String, String>> mascotas = [
    {
      'nombre': 'Firulais',
      'tipo': 'Perro',
      'raza': 'Labrador',
      'estado': 'Abandonado',
      'imagen': 'https://th-thumbnailer.cdn-si-edu.com/bgmkh2ypz03IkiRR50I-UMaqUQc=/1000x750/filters:no_upscale():focal(1061x707:1062x708)/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer_public/55/95/55958815-3a8a-4032-ac7a-ff8c8ec8898a/gettyimages-1067956982.jpg',
    },
    {
      'nombre': 'Miau',
      'tipo': 'Gato',
      'raza': 'Siames',
      'estado': 'En Abandonado',
      'imagen': 'https://th-thumbnailer.cdn-si-edu.com/bgmkh2ypz03IkiRR50I-UMaqUQc=/1000x750/filters:no_upscale():focal(1061x707:1062x708)/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer_public/55/95/55958815-3a8a-4032-ac7a-ff8c8ec8898a/gettyimages-1067956982.jpg',
    },
    {
      'nombre': 'Rexx',
      'tipo': 'Perro',
      'raza': 'Pastor Alemán',
      'estado': 'Abandonado',
      'imagen': 'https://th-thumbnailer.cdn-si-edu.com/bgmkh2ypz03IkiRR50I-UMaqUQc=/1000x750/filters:no_upscale():focal(1061x707:1062x708)/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer_public/55/95/55958815-3a8a-4032-ac7a-ff8c8ec8898a/gettyimages-1067956982.jpg',
    },
    // Agrega más mascotas según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mascotas para Adopción'),
        backgroundColor: Colors.teal,
      ),
      drawer: const SideBar(), // Agregar el Drawer
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: GridView.builder(
            itemCount: mascotas.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Ancho máximo de cada tarjeta
              childAspectRatio: 0.75, // Ajusta la relación de aspecto de las tarjetas
              mainAxisSpacing: 16, // Espacio entre las filas
              crossAxisSpacing: 16, // Espacio entre las columnas
            ),
            itemBuilder: (context, index) {
              return MascotaCard(mascota: mascotas[index]);
            },
          ),
        ),
      ),
    );
  }
}
