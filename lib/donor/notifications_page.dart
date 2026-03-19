import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  bool _isDonor = true;

  bool _notifNovaInstituicao = true;
  bool _notifConfirmacaoDoacao = true;
  bool _notifBadgeDesbloqueado = true;
  bool _notifLembrete = false;
  bool _notifNoticias = false;

  final List<Map<String, dynamic>> _notificacoes = [
    {
      'titulo': '🏆 Badge Desbloqueado!',
      'corpo': 'Conquistaste o badge "Em Chamas" por 3 doações este mês.',
      'tempo': 'Há 2 horas',
      'lida': false,
      'icon': Icons.emoji_events_rounded,
      'cor': Color(0xFFF59E0B),
    },
    {
      'titulo': '✅ Doação Confirmada',
      'corpo': 'O Orfanato Matola confirmou a receção da tua doação de Alimentos.',
      'tempo': 'Ontem',
      'lida': false,
      'icon': Icons.check_circle_rounded,
      'cor': Color(0xFF10B981),
    },
    {
      'titulo': '📍 Nova Instituição no Mapa',
      'corpo': 'Centro Social Machava acabou de ser adicionado perto de ti.',
      'tempo': 'Há 3 dias',
      'lida': true,
      'icon': Icons.location_on_rounded,
      'cor': Color(0xFF8B5CF6),
    },
    {
      'titulo': '🚨 Urgência Próxima',
      'corpo': 'Orfanato Matola está a precisar urgentemente de leite em pó.',
      'tempo': 'Há 5 dias',
      'lida': true,
      'icon': Icons.warning_amber_rounded,
      'cor': Color(0xFFEF4444),
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDonor = prefs.getBool('isDonor') ?? true;
      _notifNovaInstituicao =
          prefs.getBool('notif_nova_instituicao') ?? true;
      _notifConfirmacaoDoacao =
          prefs.getBool('notif_confirmacao_doacao') ?? true;
      _notifBadgeDesbloqueado =
          prefs.getBool('notif_badge') ?? true;
      _notifLembrete = prefs.getBool('notif_lembrete') ?? false;
      _notifNoticias = prefs.getBool('notif_noticias') ?? false;
    });
  }

  Future<void> _guardarPreferencia(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chave, valor);
  }

  void _marcarTodasLidas() {
    setState(() {
      for (final n in _notificacoes) {
        n['lida'] = true;
      }
    });
  }

  int get _naoLidas =>
      _notificacoes.where((n) => n['lida'] == false).length;

  @override
  Widget build(BuildContext context) {
    final Color themeColor = _isDonor ? const Color(0xFF10B981) : Colors.blue;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text("Notificações"),
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          actions: [
            if (_naoLidas > 0)
              TextButton(
                onPressed: _marcarTodasLidas,
                child: const Text(
                  "Marcar todas lidas",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Caixa de entrada"),
                    if (_naoLidas > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$_naoLidas",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(text: "Preferências"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _notificacoes.isEmpty
                ? _estadoVazio()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _notificacoes.length,
                    itemBuilder: (context, index) {
                      final n = _notificacoes[index];
                      return Dismissible(
                        key: Key('notif_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red.shade100,
                          child: const Icon(Icons.delete_outline,
                              color: Colors.red),
                        ),
                        onDismissed: (_) {
                          setState(() => _notificacoes.removeAt(index));
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() => n['lida'] = true);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: n['lida'] == true
                                  ? Colors.white
                                  : themeColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: n['lida'] == true
                                    ? Colors.grey.shade200
                                    : themeColor.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: (n['cor'] as Color)
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    n['icon'] as IconData,
                                    color: n['cor'] as Color,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              n['titulo'],
                                              style: TextStyle(
                                                fontWeight: n['lida'] ==
                                                        true
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          if (n['lida'] == false)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: themeColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        n['corpo'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        n['tempo'],
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _secaoTitulo("Actividade"),
                  const SizedBox(height: 8),
                  _toggleItem(
                    "Confirmação de Doação",
                    "Quando uma instituição confirma a receção",
                    Icons.check_circle_outline,
                    const Color(0xFF10B981),
                    _notifConfirmacaoDoacao,
                    (val) {
                      setState(() => _notifConfirmacaoDoacao = val);
                      _guardarPreferencia(
                          'notif_confirmacao_doacao', val);
                    },
                    themeColor,
                  ),
                  _toggleItem(
                    "Badges Desbloqueados",
                    "Quando conquistas uma nova medalha",
                    Icons.emoji_events_outlined,
                    const Color(0xFFF59E0B),
                    _notifBadgeDesbloqueado,
                    (val) {
                      setState(() => _notifBadgeDesbloqueado = val);
                      _guardarPreferencia('notif_badge', val);
                    },
                    themeColor,
                  ),
                  const SizedBox(height: 16),
                  _secaoTitulo("Descoberta"),
                  const SizedBox(height: 8),
                  _toggleItem(
                    "Novas Instituições",
                    "Quando uma nova instituição é adicionada ao mapa",
                    Icons.location_on_outlined,
                    const Color(0xFF8B5CF6),
                    _notifNovaInstituicao,
                    (val) {
                      setState(() => _notifNovaInstituicao = val);
                      _guardarPreferencia(
                          'notif_nova_instituicao', val);
                    },
                    themeColor,
                  ),
                  _toggleItem(
                    "Lembretes de Doação",
                    "Lembrete mensal para considerar uma nova doação",
                    Icons.notifications_outlined,
                    const Color(0xFF0EA5E9),
                    _notifLembrete,
                    (val) {
                      setState(() => _notifLembrete = val);
                      _guardarPreferencia('notif_lembrete', val);
                    },
                    themeColor,
                  ),
                  _toggleItem(
                    "Novidades do Doa Certo",
                    "Actualizações e novas funcionalidades da app",
                    Icons.campaign_outlined,
                    Colors.grey,
                    _notifNoticias,
                    (val) {
                      setState(() => _notifNoticias = val);
                      _guardarPreferencia('notif_noticias', val);
                    },
                    themeColor,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.grey[500], size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "As notificações push requerem ligação ao Firebase. Por enquanto as preferências são guardadas localmente.",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded,
              size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("Sem notificações",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Estás em dia com tudo!",
              style:
                  TextStyle(color: Colors.grey[400], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _secaoTitulo(String titulo) {
    return Text(
      titulo.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[500],
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _toggleItem(
    String titulo,
    String subtitulo,
    IconData icon,
    Color iconCor,
    bool valor,
    ValueChanged<bool> onChange,
    Color themeColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconCor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconCor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitulo,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: valor,
            onChanged: onChange,
            activeColor: themeColor,
          ),
        ],
      ),
    );
  }
}