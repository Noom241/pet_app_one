import 'package:flutter/material.dart';

class DetallesMascotaScreen extends StatelessWidget {
  final Map<String, dynamic> mascota;

  const DetallesMascotaScreen({
    super.key,
    required this.mascota,
  });

  @override
  Widget build(BuildContext context) {
    // Validamos si el estado de la mascota es 'Abandonado'
    bool isAbandoned = (mascota['estado'] ?? '').toLowerCase() == 'abandonado';

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ProductImages(mascota: mascota),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(mascota: mascota),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      ColorDots(mascota: mascota),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isAbandoned
          ? TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFF7643),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onPressed: () {
                // Acción para adoptar o marcar interés
              },
              child: const Text("Adoptar"),
            ),
          ),
        ),
      )
          : null,
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}

class ProductImages extends StatefulWidget {
  final Map<String, dynamic> mascota;

  const ProductImages({super.key, required this.mascota});

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              widget.mascota['foto'] ?? 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmallProductImage(
              isSelected: selectedImage == 0,
              press: () {
                setState(() {
                  selectedImage = 0;
                });
              },
              image: widget.mascota['foto'] ?? 'https://via.placeholder.com/150',
            ),
          ],
        ),
      ],
    );
  }
}

class SmallProductImage extends StatelessWidget {
  final bool isSelected;
  final VoidCallback press;
  final String image;

  const SmallProductImage({
    super.key,
    required this.isSelected,
    required this.press,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFFF7643).withOpacity(isSelected ? 1 : 0)),
        ),
        child: Image.network(image, fit: BoxFit.cover),
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  final Map<String, dynamic> mascota;

  const ProductDescription({
    super.key,
    required this.mascota,
  });

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _showMoreDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.mascota['nombre'] ?? 'Desconocida',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text("Edad: ${widget.mascota['edad']} años"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Raza: ${widget.mascota['raza'] ?? 'Desconocida'}"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Sexo: ${widget.mascota['sexo'] ?? 'Desconocido'}"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Tamaño: ${widget.mascota['tamaño'] ?? 'Desconocido'}"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Estado de Salud: ${widget.mascota['estado_salud'] ?? 'Desconocido'}"),
        ),
        if (_showMoreDetails)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text("Características: ${widget.mascota['caracteristicas'] ?? 'No especificadas'}"),
          ),
        const Divider(),
        TextButton(
          onPressed: () {
            setState(() {
              _showMoreDetails = !_showMoreDetails;
            });
          },
          child: Text(_showMoreDetails ? "Ver menos" : "Ver más"),
        ),
      ],
    );
  }
}

class ColorDots extends StatelessWidget {
  final Map<String, dynamic> mascota;

  const ColorDots({
    super.key,
    required this.mascota,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [Spacer()],
      ),
    );
  }
}
