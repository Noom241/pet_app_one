import 'package:flutter/material.dart';
import 'auth_service.dart'; // Importa el servicio de autenticación
import 'login_screen.dart'; // Importa la pantalla de login

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  final Color primaryColor = const Color(0xFFE57171); // Color principal

  // Método para registrar usuario
  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String phone = _phoneController.text.trim();
    String name = _nameController.text.trim();
    String role = "Administrador"; // Valor predeterminado para el rol
    String address = "Calle Ficticia 123"; // Valor predeterminado para la dirección

    if (email.isEmpty || password.isEmpty || phone.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos.')),
      );
      return;
    }

    // Llamar al servicio de autenticación para registrar al usuario
    bool success = await AuthService.register(name, email, password, phone, address, role);

    if (success) {
      // Si el registro es exitoso, mostrar mensaje y redirigir a login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // Si el registro falla, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro fallido. Intente nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Cierra el teclado al tocar fuera del formulario
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Image.network(
                      "https://cdn-icons-png.flaticon.com/512/6462/6462524.png",
                      height: 100,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Text(
                      "Regístrate",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextFormField(
                            controller: _nameController,
                            hintText: 'Nombre completo',
                            validatorMessage: 'Por favor ingresa tu nombre.',
                          ),
                          const SizedBox(height: 16.0),
                          _buildTextFormField(
                            controller: _phoneController,
                            hintText: 'Teléfono',
                            keyboardType: TextInputType.phone,
                            validatorMessage: 'Por favor ingresa tu teléfono.',
                          ),
                          const SizedBox(height: 16.0),
                          _buildTextFormField(
                            controller: _emailController,
                            hintText: 'Correo Electrónico',
                            keyboardType: TextInputType.emailAddress,
                            validatorMessage: 'Por favor ingresa tu correo.',
                          ),
                          const SizedBox(height: 16.0),
                          _buildTextFormField(
                            controller: _passwordController,
                            hintText: 'Contraseña',
                            obscureText: true,
                            validatorMessage: 'Por favor ingresa tu contraseña.',
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _register(); // Llamada al método de registro
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text("Registrarse"),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "¿Ya tienes cuenta? ",
                                children: [
                                  TextSpan(
                                    text: "Inicia sesión",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ],
                              ),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
      ),
    );
  }

  // Método para construir los campos de texto
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String validatorMessage,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF5FCF9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }
}
