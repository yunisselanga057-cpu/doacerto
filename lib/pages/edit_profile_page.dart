import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _descricaoController = TextEditingController();

  File? _image;
  bool _isDonor = true;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _imagemPathOriginal;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final imagemPath = prefs.getString('userImagePath');

    setState(() {
      _isDonor = prefs.getBool('isDonor') ?? true;
      _nomeController.text = prefs.getString('userName') ?? '';
      _emailController.text = prefs.getString('userEmail') ?? '';
      _descricaoController.text =
          prefs.getString('instituicaoDescricao') ?? '';
      _imagemPathOriginal = imagemPath;
      if (imagemPath != null) _image = File(imagemPath);
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      _mostrarErro("Não foi possível aceder à galeria.");
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _guardar() async {
    if (_nomeController.text.trim().isEmpty) {
      _mostrarErro("O nome não pode estar vazio.");
      return;
    }

    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nomeController.text.trim());
    await prefs.setString('userEmail', _emailController.text.trim());

    if (!_isDonor) {
      await prefs.setString(
          'instituicaoDescricao', _descricaoController.text.trim());
    }

    if (_image != null && _image!.path != _imagemPathOriginal) {
      await prefs.setString('userImagePath', _image!.path);
    }

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Perfil actualizado com sucesso!"),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(color: Color(0xFF10B981))),
      );
    }

    final Color themeColor = _isDonor ? const Color(0xFF10B981) : Colors.blue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _guardar,
            child: Text(
              "Guardar",
              style: TextStyle(
                color: Colors.white.withOpacity(_isSaving ? 0.5 : 1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: themeColor.withOpacity(0.15),
                    backgroundImage:
                        _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(
                            _isDonor ? Icons.person : Icons.account_balance,
                            size: 50,
                            color: themeColor,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: themeColor,
                      child: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _pickImage,
              child: Text(
                "Alterar foto",
                style: TextStyle(color: themeColor, fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),

            _secaoTitulo("Informação pessoal"),
            const SizedBox(height: 12),

            _campo(
              controller: _nomeController,
              label: _isDonor ? "Nome completo" : "Nome da Instituição",
              icon: _isDonor ? Icons.person_outline : Icons.business_outlined,
              themeColor: themeColor,
              capitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 14),

            _campo(
              controller: _emailController,
              label: "Email",
              icon: Icons.email_outlined,
              themeColor: themeColor,
              keyboardType: TextInputType.emailAddress,
            ),

            if (!_isDonor) ...[
              const SizedBox(height: 24),
              _secaoTitulo("Informação da Instituição"),
              const SizedBox(height: 12),
              TextField(
                controller: _descricaoController,
                maxLines: 4,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "O que precisam actualmente?",
                  hintText:
                      "Ex: Faltam cobertores e leite para as crianças",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.info_outline),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        "Guardar Alterações",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secaoTitulo(String titulo) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color themeColor,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      decoration: InputDecoration(
        labelText: label,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
      ),
    );
  }
}