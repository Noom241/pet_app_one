import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../auth/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Obtener el email del usuario desde el provider
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var email = userProvider.user?.email;

      if (email != null) {
        // Llamar al servicio para obtener los detalles del usuario
        var userData = await AuthService.getUserByEmail(email);
        setState(() {
          userDetails = userData;
        });
      }
    } catch (e) {
      print("Error al obtener detalles del usuario: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Perfil"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userDetails == null
          ? const Center(
        child: Text(
          "No se encontraron detalles del usuario.",
          style: TextStyle(fontSize: 16.0),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const ProfilePic(
              image: "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Free-Image.png",
            ),
            Text(
              userDetails?["nombre"] ?? "Nombre no disponible",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 32.0),
            Info(
              infoKey: "Correo",
              info: userDetails?["email"] ?? "Correo no disponible",
            ),
            Info(
              infoKey: "Teléfono",
              info: userDetails?["telefono"] ?? "Teléfono no disponible",
            ),
            Info(
              infoKey: "Dirección",
              info: userDetails?["direccion"] ?? "Dirección no disponible",
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(image),
          ),
          if (isShowPhotoUpload)
            InkWell(
              onTap: imageUploadBtnPress,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            infoKey,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.8),
            ),
          ),
          Text(info),
        ],
      ),
    );
  }
}
