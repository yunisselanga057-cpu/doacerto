import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorImpactPage extends StatefulWidget {
  const DonorImpactPage({super.key});

  @override
  State<DonorImpactPage> createState() => _DonorImpactPageState();
}

class _DonorImpactPageState extends State<DonorImpactPage>
    with TickerProviderStateMixin {
  String _nome = "Doador";
  int _totalDoacoes = 3;
  int _pontosActuais = 60;
  int _streakMeses = 1;
  int _instituicoesAjudadas = 2;

  late AnimationController _countController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;

  final List<Map<String, dynamic>> _impactoCategoria = [
    {
      'categoria': 'Alimentos',
      'quantidade': 2,
      'icon': Icons.bakery_dining_rounded,
      'cor': const Color(0xFF10B981),
      'impacto': '~24 refeições',
    },
    {
      'categoria': 'Cobertores',
      'quantidade': 1,
      'icon': Icons.bed_rounded,
      'cor': const Color(0xFF0EA5E9),
      'impacto': '3 crianças aquecidas',
    },
    {
      'categoria': 'Material Escolar',
      'quantidade': 1,
      'icon': Icons.menu_book_rounded,
      'cor': const Color(0xFF8B5CF6),
      'impacto': '2 alunos equipados',
    },
  ];

  final List<Map<String, dynamic>> _historicoMensal = [
    {'mes': 'Jan', 'doacoes': 0},
    {'mes': 'Fev', 'doacoes': 1},
    {'mes': 'Mar', 'doacoes': 0},
    {'mes': 'Abr', 'doacoes': 2},
    {'mes': 'Mai', 'doacoes': 3},
    {'mes': 'Jun', 'doacoes': 1},
  ];

  @override
  void initState() {
    super.initState();

    _countController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _cardControllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _cardAnimations = _cardControllers.map((c) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: c, curve: Curves.easeOutCubic),
      );
    }).toList();

    _carregarDados();

    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + i * 120),
          () => _cardControllers[i].forward());
    }
    Future.delayed(
        const Duration(milliseconds: 300), () => _countController.forward());
  }

  @override
  void dispose() {
    _countController.dispose();
    for (final c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('userName') ?? "Doador";
      _totalDoacoes = prefs.getInt('totalDoacoes') ?? 3;
      _pontosActuais = prefs.getInt('pontos') ?? 60;
      _streakMeses = prefs.getInt('streakMeses') ?? 1;
      _instituicoesAjudadas = prefs.getInt('instituicoesAjudadas') ?? 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int maxDoacoesMes =
        _historicoMensal.map((e) => e['doacoes'] as int).reduce(
              (a, b) => a > b ? a : b,
            );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("O meu Impacto"),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF064E3B), Color(0xFF065F46)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
                child: Column(
                  children: [
                    Text(
                      "Olá, $_nome! 👋",
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "O teu impacto até hoje",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: _animatedStatCard(
                            0,
                            Icons.volunteer_activism,
                            "$_totalDoacoes",
                            "Doações feitas",
                            const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _animatedStatCard(
                            1,
                            Icons.account_balance_rounded,
                            "$_instituicoesAjudadas",
                            "Instituições",
                            const Color(0xFF0EA5E9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _animatedStatCard(
                            2,
                            Icons.emoji_events_rounded,
                            "$_pontosActuais",
                            "Pontos de impacto",
                            const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _animatedStatCard(
                            3,
                            Icons.local_fire_department_rounded,
                            "${_streakMeses}m",
                            "Streak activo",
                            const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "O que as tuas doações significaram",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Impacto real estimado das tuas contribuições",
                    style:
                        TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),

            ..._impactoCategoria.map((item) {
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: (item['cor'] as Color).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (item['cor'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item['icon'] as IconData,
                          color: item['cor'] as Color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['categoria'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Text(
                            "${item['quantidade']}x doado  •  ${item['impacto']}",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.favorite,
                        color: (item['cor'] as Color).withOpacity(0.5),
                        size: 18),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Actividade por mês",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Doações nos últimos 6 meses",
                    style:
                        TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _historicoMensal.map((mes) {
                        final valor = mes['doacoes'] as int;
                        final altura = maxDoacoesMes == 0
                            ? 0.0
                            : (valor / maxDoacoesMes) * 100;
                        final isMax = valor == maxDoacoesMes && valor > 0;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (valor > 0)
                              Text(
                                "$valor",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isMax
                                      ? const Color(0xFF10B981)
                                      : Colors.grey[500],
                                ),
                              ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              width: 28,
                              height: altura,
                              decoration: BoxDecoration(
                                color: isMax
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF10B981)
                                        .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _historicoMensal.map((mes) {
                      return Text(
                        mes['mes'],
                        style: TextStyle(
                            color: Colors.grey[400], fontSize: 11),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text("💚",
                      style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Continua assim!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Mais $_totalDoacoes doações e desbloqueas o badge Herói Local 🏆",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _animatedStatCard(
    int index,
    IconData icon,
    String valor,
    String label,
    Color cor,
  ) {
    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (_, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - _cardAnimations[index].value)),
        child: Opacity(
          opacity: _cardAnimations[index].value,
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: cor, size: 22),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}