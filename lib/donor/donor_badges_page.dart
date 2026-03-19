import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeModel {
  final String id;
  final String nome;
  final String descricao;
  final IconData icon;
  final Color cor;
  final int pontosNecessarios;
  final String criterio; 

  const BadgeModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.icon,
    required this.cor,
    required this.pontosNecessarios,
    required this.criterio,
  });
}

const List<BadgeModel> todosBadges = [
  BadgeModel(
    id: 'primeiro_passo',
    nome: 'Primeiro Passo',
    descricao: 'Fez a primeira doação',
    icon: Icons.emoji_nature_rounded,
    cor: Color(0xFF10B981),
    pontosNecessarios: 10,
    criterio: '1 doação',
  ),
  BadgeModel(
    id: 'em_chamas',
    nome: 'Em Chamas',
    descricao: '3 doações num mês',
    icon: Icons.local_fire_department_rounded,
    cor: Color(0xFFEF4444),
    pontosNecessarios: 50,
    criterio: '3 doações num mês',
  ),
  BadgeModel(
    id: 'heroi_local',
    nome: 'Herói Local',
    descricao: '10 doações totais',
    icon: Icons.shield_rounded,
    cor: Color(0xFF8B5CF6),
    pontosNecessarios: 150,
    criterio: '10 doações',
  ),
  BadgeModel(
    id: 'guardiao',
    nome: 'Guardião',
    descricao: 'Doou para 5 instituições diferentes',
    icon: Icons.account_balance_rounded,
    cor: Color(0xFF0EA5E9),
    pontosNecessarios: 200,
    criterio: '5 instituições diferentes',
  ),
  BadgeModel(
    id: 'coracao_de_ouro',
    nome: 'Coração de Ouro',
    descricao: '3 meses consecutivos a doar',
    icon: Icons.favorite_rounded,
    cor: Color(0xFFF59E0B),
    pontosNecessarios: 300,
    criterio: '3 meses seguidos',
  ),
  BadgeModel(
    id: 'lenda',
    nome: 'Lenda',
    descricao: '50 doações realizadas',
    icon: Icons.emoji_events_rounded,
    cor: Color(0xFFF59E0B),
    pontosNecessarios: 1000,
    criterio: '50 doações',
  ),
];

class DonorBadgesPage extends StatefulWidget {
  const DonorBadgesPage({super.key});

  @override
  State<DonorBadgesPage> createState() => _DonorBadgesPageState();
}

class _DonorBadgesPageState extends State<DonorBadgesPage>
    with TickerProviderStateMixin {
  int _pontosActuais = 60; 
  int _totalDoacoes = 3;
  int _streakMeses = 1;
  List<String> _badgesDesbloqueados = ['primeiro_passo', 'em_chamas'];

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _carregarDados();
    Future.delayed(
        const Duration(milliseconds: 300), () => _progressController.forward());
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pontosActuais = prefs.getInt('pontos') ?? 60;
      _totalDoacoes = prefs.getInt('totalDoacoes') ?? 3;
      _streakMeses = prefs.getInt('streakMeses') ?? 1;
      _badgesDesbloqueados =
          prefs.getStringList('badges') ?? ['primeiro_passo', 'em_chamas'];
    });
  }

  BadgeModel? get _proximoBadge {
    for (final badge in todosBadges) {
      if (!_badgesDesbloqueados.contains(badge.id)) return badge;
    }
    return null;
  }

  double get _progressoProximoBadge {
    final prox = _proximoBadge;
    if (prox == null) return 1.0;
    return (_pontosActuais / prox.pontosNecessarios).clamp(0.0, 1.0);
  }

  void _mostrarDetalheBadge(BadgeModel badge, bool desbloqueado) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _BadgeDetalheSheet(
        badge: badge,
        desbloqueado: desbloqueado,
        pontosActuais: _pontosActuais,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desbloqueados =
        todosBadges.where((b) => _badgesDesbloqueados.contains(b.id)).toList();
    final bloqueados =
        todosBadges.where((b) => !_badgesDesbloqueados.contains(b.id)).toList();
    final prox = _proximoBadge;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("As minhas Conquistas"),
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
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    children: [
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$_pontosActuais",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 6),
                            child: Text(
                              "pts",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Pontos de Impacto",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statCard(
                            Icons.volunteer_activism,
                            "$_totalDoacoes",
                            "Doações",
                          ),
                          _statCard(
                            Icons.emoji_events_rounded,
                            "${desbloqueados.length}",
                            "Badges",
                          ),
                          _statCard(
                            Icons.local_fire_department_rounded,
                            "${_streakMeses}m",
                            "Streak",
                          ),
                        ],
                      ),

                      if (prox != null) ...[
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Próximo: ${prox.nome}",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            Text(
                              "$_pontosActuais/${prox.pontosNecessarios} pts",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _progressoProximoBadge *
                                  _progressAnimation.value,
                              backgroundColor:
                                  Colors.white.withOpacity(0.15),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(prox.cor),
                              minHeight: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            if (desbloqueados.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  "✅ Conquistados",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: desbloqueados.length,
                itemBuilder: (_, i) => _BadgeCard(
                  badge: desbloqueados[i],
                  desbloqueado: true,
                  onTap: () =>
                      _mostrarDetalheBadge(desbloqueados[i], true),
                ),
              ),
            ],

            if (bloqueados.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  "🔒 Por conquistar",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 24),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: bloqueados.length,
                itemBuilder: (_, i) => _BadgeCard(
                  badge: bloqueados[i],
                  desbloqueado: false,
                  onTap: () =>
                      _mostrarDetalheBadge(bloqueados[i], false),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String valor, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style:
              TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
        ),
      ],
    );
  }
}

class _BadgeCard extends StatefulWidget {
  final BadgeModel badge;
  final bool desbloqueado;
  final VoidCallback onTap;

  const _BadgeCard({
    required this.badge,
    required this.desbloqueado,
    required this.onTap,
  });

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cor = widget.desbloqueado ? widget.badge.cor : Colors.grey;

    return GestureDetector(
      onTapDown: (_) => _scaleController.reverse(),
      onTapUp: (_) {
        _scaleController.forward();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.desbloqueado
                  ? cor.withOpacity(0.3)
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: widget.desbloqueado
                ? [
                    BoxShadow(
                      color: cor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cor.withOpacity(
                      widget.desbloqueado ? 0.12 : 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.badge.icon,
                  color: widget.desbloqueado ? cor : Colors.grey[400],
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.badge.nome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: widget.desbloqueado
                      ? const Color(0xFF1F2937)
                      : Colors.grey[400],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.desbloqueado)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(Icons.check_circle,
                      color: cor, size: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeDetalheSheet extends StatelessWidget {
  final BadgeModel badge;
  final bool desbloqueado;
  final int pontosActuais;

  const _BadgeDetalheSheet({
    required this.badge,
    required this.desbloqueado,
    required this.pontosActuais,
  });

  @override
  Widget build(BuildContext context) {
    final progresso =
        (pontosActuais / badge.pontosNecessarios).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: (desbloqueado ? badge.cor : Colors.grey)
                  .withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              badge.icon,
              size: 46,
              color: desbloqueado ? badge.cor : Colors.grey[400],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            badge.nome,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            badge.descricao,
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: (desbloqueado ? badge.cor : Colors.grey)
                  .withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  desbloqueado
                      ? Icons.check_circle
                      : Icons.lock_outline,
                  color: desbloqueado ? badge.cor : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  desbloqueado
                      ? "Conquistado!"
                      : "Critério: ${badge.criterio}",
                  style: TextStyle(
                    color: desbloqueado ? badge.cor : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          if (!desbloqueado) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progresso",
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 13)),
                Text(
                  "$pontosActuais/${badge.pontosNecessarios} pts",
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progresso,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(badge.cor),
                minHeight: 10,
              ),
            ),
          ],

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class BadgeUnlockOverlay extends StatefulWidget {
  final BadgeModel badge;
  final VoidCallback onDismiss;

  const BadgeUnlockOverlay({
    super.key,
    required this.badge,
    required this.onDismiss,
  });

  @override
  State<BadgeUnlockOverlay> createState() => _BadgeUnlockOverlayState();
}

class _BadgeUnlockOverlayState extends State<BadgeUnlockOverlay>
    with TickerProviderStateMixin {
  late AnimationController _entradaController;
  late AnimationController _pulseController;
  late Animation<double> _scaleEntrada;
  late Animation<double> _fadeEntrada;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _entradaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleEntrada = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
          parent: _entradaController, curve: Curves.elasticOut),
    );
    _fadeEntrada = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _entradaController, curve: Curves.easeOut),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entradaController.forward();

    Future.delayed(
        const Duration(milliseconds: 3500), widget.onDismiss);
  }

  @override
  void dispose() {
    _entradaController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: FadeTransition(
            opacity: _fadeEntrada,
            child: ScaleTransition(
              scale: _scaleEntrada,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, child) => Transform.scale(
                  scale: _pulse.value,
                  child: child,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: widget.badge.cor.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "🎉 Badge Desbloqueado!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: widget.badge.cor.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.badge.cor.withOpacity(0.4),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          widget.badge.icon,
                          size: 52,
                          color: widget.badge.cor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.badge.nome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.badge.descricao,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Toca para continuar",
                        style: TextStyle(
                            color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}