import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doacerto/donor/donor_home.dart';
import 'package:doacerto/charity/charity_home.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  File? _image;
  bool _isDonor = true;
  bool _isLoading = true;
  bool _nomeJaGuardado = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final nomeGuardado = prefs.getString('userName') ?? '';
    final descricaoGuardada = prefs.getString('instituicaoDescricao') ?? '';
    final imagemGuardada = prefs.getString('userImagePath');

    setState(() {
      _isDonor = prefs.getBool('isDonor') ?? true;
      _nameController.text = nomeGuardado;
      _descricaoController.text = descricaoGuardada;
      _nomeJaGuardado = nomeGuardado.isNotEmpty;
      if (imagemGuardada != null) _image = File(imagemGuardada);
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userImagePath', pickedFile.path);
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

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      _mostrarErro(_isDonor
          ? "Por favor, diz-nos o teu nome."
          : "Por favor, insere o nome da instituição.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text.trim());

    if (!_isDonor && _descricaoController.text.trim().isNotEmpty) {
      await prefs.setString(
          'instituicaoDescricao', _descricaoController.text.trim());
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _isDonor ? const DonorHomePage() : const CharityHomePage(),
      ),
    );
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
        title: Text(_nomeJaGuardado ? "Adicionar foto" : "Completar perfil"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            
            Row(
              children: [
                _passoIndicador(Icons.check, "Conta", true, themeColor),
                Expanded(child: Container(height: 2, color: themeColor)),
                _passoIndicador(Icons.person, "Perfil", true, themeColor),
                Expanded(
                    child: Container(height: 2, color: Colors.grey.shade200)),
                _passoIndicador(
                    Icons.home, "Início", false, Colors.grey.shade300),
              ],
            ),

            const SizedBox(height: 32),

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
            Text(
              _image == null
                  ? "Toca para adicionar foto (opcional)"
                  : "Toca para alterar a foto",
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),

            const SizedBox(height: 28),

            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: _isDonor ? "O teu nome" : "Nome da Instituição",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
                prefixIcon: Icon(
                    _isDonor ? Icons.person : Icons.business,
                    color: Colors.grey[400]),
              ),
            ),

            if (!_isDonor) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _descricaoController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "O que precisam actualmente? (opcional)",
                  hintText: "Ex: Faltam cobertores e leite para as crianças",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.info_outline, color: Colors.blue),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _isDonor ? "Começar a Ajudar! 💚" : "Entrar no Painel",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_nomeJaGuardado) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: _saveProfile,
                child: Text(
                  "Saltar, adicionar foto mais tarde",
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  Widget _passoIndicador(
      IconData icon, String label, bool activo, Color cor) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          child: Icon(icon,
              color: activo ? Colors.white : Colors.grey.shade400,
              size: 18),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: activo ? Colors.grey[600] : Colors.grey[400])),
      ],
    );
  }
}