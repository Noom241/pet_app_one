import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../screen/HomeScreen.dart';

class ReportPetScreen extends StatefulWidget {
  const ReportPetScreen({super.key});

  @override
  _ReportPetScreenState createState() => _ReportPetScreenState();
}

class _ReportPetScreenState extends State<ReportPetScreen> {
  File? _image;
  String? _location;
  String? _description;
  String? _imageUrl;
  String? _petName;
  String? _petBreed;
  String? _healthStatus;
  int? _petAge;
  String? _selectedPetType;
  String? _selectedPetSex;
  String? _selectedPetSize;
  String? _characteristics;

  final _formKey = GlobalKey<FormState>();
  final String apiKey = 'db27a24d1333253e282777f2d3b623ea';
  bool _isUploading = false;

  final List<String> petTypes = ['Perro', 'Gato', 'Otro'];
  final List<String> petSexes = ['Macho', 'Hembra'];
  final List<String> petSizes = ['Pequeño', 'Mediano', 'Grande'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: await _chooseImageSource(),
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<ImageSource> _chooseImageSource() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Seleccionar origen de la imagen"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Cámara"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Galería"),
          ),
        ],
      ),
    ) ?? ImageSource.camera;
  }

  Future<void> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final url = Uri.parse("https://api.imgbb.com/1/upload");
      final response = await http.post(url, body: {
        "key": apiKey,
        "image": base64Image,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData["success"]) {
          setState(() {
            _imageUrl = responseData["data"]["url"];
          });
        } else {
          _showSnackbar("Error al subir la imagen.");
        }
      } else {
        _showSnackbar("Error en la solicitud a la API.");
      }
    } catch (e) {
      _showSnackbar("Error al subir la imagen: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      // Verificar si la imagen fue seleccionada
      if (_image == null) {
        _showSnackbar("Por favor, seleccione una imagen.");
        return;
      }

      // Subir la imagen si fue seleccionada
      if (_image != null) {
        await _uploadImage(_image!);
      }

      // Si la URL de la imagen está disponible, proceder con el envío del reporte
      if (_imageUrl != null) {
        // Asegurarse de que todos los campos necesarios no sean nulos o vacíos
        bool success = await AuthService.reportPet(
          1, // Este es un ID de ejemplo, cámbialo según sea necesario.
          _petName!, // Nombre de la mascota
          _selectedPetType!, // Tipo de mascota (ej. Perro o Gato)
          _petBreed!, // Raza
          _petAge!, // Edad
          _selectedPetSex!, // Sexo
          _selectedPetSize!, // Tamaño (Pequeño, Mediano, Grande)
          _healthStatus!, // Estado de salud
          _characteristics ?? "", // Características (puede ser vacío)
          _imageUrl!, // URL de la imagen
          _location!, // Ubicación
          _description!, // Descripción adicional
        );

        // Mostrar mensaje basado en si el reporte fue exitoso o no
        if (success) {
          _showSnackbar("Reporte enviado exitosamente.");
          Navigator.pop(context);  // Esto cierra la pantalla actual

        } else {
          _showSnackbar("Error al enviar el reporte.");
        }
      } else {
        // Si no se tiene la URL de la imagen, mostrar mensaje de error
        _showSnackbar("La imagen no se ha cargado correctamente.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reportar Mascota Abandonada"),
        backgroundColor: const Color(0xFF00BF6D),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfilePic(),
              const SizedBox(height: 20),
              _buildTextField(
                label: "Nombre de la Mascota",
                onChanged: (value) => _petName = value,
              ),
              _buildDropdownField(
                label: "Tipo de Mascota",
                value: _selectedPetType,
                items: petTypes,
                onChanged: (value) => setState(() {
                  _selectedPetType = value;
                }),
              ),
              _buildTextField(
                label: "Raza de la Mascota",
                onChanged: (value) => _petBreed = value,
              ),
              _buildTextField(
                label: "Edad de la Mascota",
                keyboardType: TextInputType.number,
                onChanged: (value) => _petAge = int.tryParse(value),
              ),
              _buildDropdownField(
                label: "Sexo de la Mascota",
                value: _selectedPetSex,
                items: petSexes,
                onChanged: (value) => setState(() {
                  _selectedPetSex = value;
                }),
              ),
              _buildDropdownField(
                label: "Tamaño de la Mascota",
                value: _selectedPetSize,
                items: petSizes,
                onChanged: (value) => setState(() {
                  _selectedPetSize = value;
                }),
              ),
              _buildTextField(
                label: "Estado de Salud",
                onChanged: (value) => _healthStatus = value,
              ),
              _buildTextField(
                label: "Características adicionales",
                maxLines: 3,
                onChanged: (value) => _characteristics = value,
              ),
              _buildTextField(
                label: "Ubicación",
                onChanged: (value) => _location = value,
              ),
              _buildTextField(
                label: "Descripción",
                hintText: "Ejemplo: Mascota abandonada en la calle, necesita ayuda.",
                onChanged: (value) => _description = value,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF6D),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text("Enviar Reporte"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePic() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: const Color(0xFF00BF6D),
        child: _image == null
            ? const Icon(Icons.camera_alt, color: Colors.white, size: 40)
            : ClipOval(child: Image.file(_image!, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, ingrese $label.";
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        value: value,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor, seleccione $label.";
          }
          return null;
        },
      ),
    );
  }
}
