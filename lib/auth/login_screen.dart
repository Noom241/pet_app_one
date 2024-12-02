import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart'; // Importa el servicio de autenticación
import 'register_screen.dart'; // Importa la pantalla de registro
import 'user_provider.dart'; // Importa el UserProvider

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Definir el color principal (229, 113, 113) como un Color en Flutter
  final Color primaryColor = const Color(0xFFE57171); // RGB: (229, 113, 113)

  // Función de inicio de sesión
  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Llama al servicio de autenticación y recibe el resultado
    bool success = await AuthService.login(email, password);

    if (success) {
      // Si el inicio de sesión es exitoso, obtenemos los datos del usuario
      String token = "some_token";  // Este valor debe provenir de tu servicio de autenticación
      UserModel user = UserModel(email: email, token: token);

      // Usamos el provider para almacenar el usuario
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      // Navegamos a la página principal
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Mostrar mensaje de error si el inicio de sesión falla
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión fallido. Verifique sus credenciales.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.network(
                    "https://cdn-icons-png.flaticon.com/512/6462/6462524.png",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Iniciar sesión",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Correo Electrónico',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Contraseña',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor, // Usando el color principal aquí
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Iniciar sesión"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            // Navegar a la pantalla de registro
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "¿No tienes una cuenta? ",
                              children: [
                                TextSpan(
                                  text: "Regístrate",
                                  style: TextStyle(color: primaryColor), // Usando el color principal aquí también
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
