import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    final url = Uri.parse('http://40.40.9.50:3000/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    final data = json.decode(response.body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Register Berhasil!")));
      Navigator.pop(context); // Tutup popup register
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'] ?? 'Register gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 34, 102, 141),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Image.asset('assets/images/Frame 1.png'),
              ),
              SizedBox(height: 40),
              buildInputField(
                Icons.person,
                'Nama :',
                'Nama lengkap',
                nameController,
              ),
              SizedBox(height: 10),
              buildInputField(
                Icons.phone,
                'HP :',
                '08xxxxxxxxxx',
                phoneController,
              ),
              SizedBox(height: 10),
              buildInputField(
                Icons.email,
                'Email :',
                'example@gmail.com',
                emailController,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 206, 206, 206),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Icon(Icons.key),
                    SizedBox(width: 15),
                    Text('Password :'),
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 9,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 99, 88, 220),
                  minimumSize: Size(300, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: registerUser,
                child: Text('Register', style: TextStyle(color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do You have an Account? ',
                    style: TextStyle(fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 114, 33, 243),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    IconData icon,
    String label,
    String hintText,
    TextEditingController controller,
  ) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 206, 206, 206),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(width: 15),
          Icon(icon),
          SizedBox(width: 15),
          Text(label),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
