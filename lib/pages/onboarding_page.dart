import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doacerto/pages/welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      titulo: "Bem-vindo ao Doa Certo",
      descricao:
          "A plataforma que conecta quem quer ajudar com quem mais precisa, aqui em Moçambique.",
      icon: Icons.volunteer_activism,
      cor: const Color(0xFF10B981),
      corFundo: const Color(0xFFF0FDF4),
      emoji: "💚",
    ),
    _OnboardingData(
      titulo: "Vê onde há necessidade",
      descricao:
          "No mapa, pins coloridos mostram em tempo real quais instituições precisam de ajuda urgente.",
      icon: Icons.map_rounded,
      cor: const Color(0xFFEF4444),
      corFundo: const Color(0xFFFFF1F2),
      emoji: "🗺️",
    ),
    _OnboardingData(
      titulo: "Doa o que tens",
      descricao:
          "Alimentos, roupas, material escolar ou apoio financeiro. Cada doação, por menor que seja, faz diferença.",
      icon: Icons.card_giftcard_rounded,
      cor: const Color(0xFFF59E0B),
      corFundo: const Color(0xFFFFFBEB),
      emoji: "🎁",
    ),
    _OnboardingData(
      titulo: "Agenda a entrega",
      descricao:
          "Escolhe o dia e a hora que te é conveniente. A instituição fica à tua espera.",
      icon: Icons.calendar_month_rounded,
      cor: const Color(0xFF8B5CF6),
      corFundo: const Color(0xFFF5F3FF),
      emoji: "📅",
    ),
    _OnboardingData(
      titulo: "Ganha badges e impacto",
      descricao:
          "Cada doação desbloqueia conquistas, sobe o teu ranking e mostra o impacto real que estás a causar.",
      icon: Icons.emoji_events_rounded,
      cor: const Color(0xFFF59E0B),
      corFundo: const Color(0xFFFFFBEB),
      emoji: "🏆",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _animatePage() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _terminarOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleto', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const WelcomePage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _proxima() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _terminarOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dados = _pages[_currentPage];

    return Scaffold(
      backgroundColor: dados.corFundo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? dados.cor
                              : dados.cor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _terminarOnboarding,
                      child: Text(
                        "Saltar",
                        style: TextStyle(
                          color: dados.cor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _animatePage();
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingScreen(
                    dados: page,
                    fadeAnimation: _fadeAnimation,
                    slideAnimation: _slideAnimation,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _proxima,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dados.cor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _pages.length - 1
                            ? "Começar Agora"
                            : "Continuar",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentPage == _pages.length - 1
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen extends StatelessWidget {
  final _OnboardingData dados;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const _OnboardingScreen({
    required this.dados,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: dados.cor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: dados.cor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                
                    ClipOval(
                      child: Image.asset(
                        'assets/images/onboarding_${_getImageIndex(dados.icon)}.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          dados.icon,
                          size: 80,
                          color: dados.cor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(dados.emoji, style: const TextStyle(fontSize: 36)),

              const SizedBox(height: 24),

              Text(
                dados.titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),
              
              Text(
                dados.descricao,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getImageIndex(IconData icon) {
    const icons = [
      Icons.volunteer_activism,
      Icons.map_rounded,
      Icons.card_giftcard_rounded,
      Icons.calendar_month_rounded,
      Icons.emoji_events_rounded,
    ];
    return icons.indexOf(icon) + 1;
  }
}

class _OnboardingData {
  final String titulo;
  final String descricao;
  final IconData icon;
  final Color cor;
  final Color corFundo;
  final String emoji;

  const _OnboardingData({
    required this.titulo,
    required this.descricao,
    required this.icon,
    required this.cor,
    required this.corFundo,
    required this.emoji,
  });
}