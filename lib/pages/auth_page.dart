import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doacerto/pages/profile_setup_page.dart';
import 'package:doacerto/donor/donor_home.dart';
import 'package:doacerto/charity/charity_home.dart';

class AuthPage extends StatefulWidget {
  final bool isDonor;
  const AuthPage({super.key, required this.isDonor});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomeController = TextEditingController(); 

  bool _isLoading = false;
  bool _isLogin = true; 
  bool _mostrarSenha = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomeController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _toggleModo() {
    _animController.reset();
    setState(() => _isLogin = !_isLogin);
    _animController.forward();
  }

  bool _isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final nome = _nomeController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarErro("Por favor, preenche todos os campos.");
      return;
    }
    if (!_isEmailValid(email)) {
      _mostrarErro("Insere um email válido.");
      return;
    }
    if (password.length < 6) {
      _mostrarErro("A senha deve ter pelo menos 6 caracteres.");
      return;
    }
    if (!_isLogin && nome.isEmpty) {
      _mostrarErro("Por favor, insere o teu nome.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();

      if (_isLogin) {
        final nomeGuardado = prefs.getString('userName');
        final perfilCompleto = nomeGuardado != null && nomeGuardado.isNotEmpty;

        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setBool('isDonor', widget.isDonor);

        if (!mounted) return;

        if (perfilCompleto) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => widget.isDonor
                  ? const DonorHomePage()
                  : const CharityHomePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const ProfileSetupPage()),
          );
        }
      } else {
      
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setBool('isDonor', widget.isDonor);
        await prefs.setString('userName', nome);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const ProfileSetupPage()),
        );
      }
    } catch (e) {
      _mostrarErro("Erro de ligação. Tenta novamente.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor =
        widget.isDonor ? const Color(0xFF10B981) : Colors.blue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: themeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  widget.isDonor
                      ? Icons.volunteer_activism
                      : Icons.account_balance,
                  color: themeColor,
                  size: 32,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                _isLogin ? "Bem-vindo de volta!" : "Criar conta",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isLogin
                    ? "Entra na tua conta para continuar"
                    : widget.isDonor
                        ? "Regista-te como Doador"
                        : "Regista a tua Instituição",
                style: TextStyle(color: Colors.grey[500], fontSize: 15),
              ),

              const SizedBox(height: 36),

              if (!_isLogin) ...[
                _campo(
                  controller: _nomeController,
                  label: widget.isDonor ? "O teu nome" : "Nome da Instituição",
                  icon: widget.isDonor ? Icons.person : Icons.business,
                  themeColor: themeColor,
                  capitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
              ],

              _campo(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                themeColor: themeColor,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: !_mostrarSenha,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                  prefixIcon:
                      Icon(Icons.lock_outlined, color: Colors.grey[400]),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarSenha
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                    ),
                    onPressed: () =>
                        setState(() => _mostrarSenha = !_mostrarSenha),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          _isLogin ? "Entrar" : "Criar Conta",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: _toggleModo,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.grey[500], fontSize: 14),
                      children: [
                        TextSpan(
                          text: _isLogin
                              ? "Ainda não tens conta? "
                              : "Já tens conta? ",
                        ),
                        TextSpan(
                          text: _isLogin ? "Criar conta" : "Entrar",
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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