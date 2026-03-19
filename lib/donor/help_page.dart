import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjudaPage extends StatefulWidget {
  const AjudaPage({super.key});

  @override
  State<AjudaPage> createState() => _AjudaPageState();
}

class _AjudaPageState extends State<AjudaPage> {
  bool _isDonor = true;
  int? _expandido;

  @override
  void initState() {
    super.initState();
    _carregarTipo();
  }

  Future<void> _carregarTipo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isDonor = prefs.getBool('isDonor') ?? true);
  }

  final List<Map<String, String>> _faqDoador = [
    {
      'pergunta': 'Como faço uma doação?',
      'resposta':
          'No ecrã do Mapa, toca num pin colorido para ver os detalhes da instituição. Se precisarem de ajuda, toca em "Ajudar Agora", escolhe o que queres doar, seleciona o dia e hora e confirma. É simples assim!',
    },
    {
      'pergunta': 'O que significam as cores dos pins?',
      'resposta':
          'Vermelho significa urgência — a instituição precisa de ajuda imediata. Laranja significa que precisam de ajuda mas não é crítico. Verde significa que estão estáveis e não precisam de doações neste momento.',
    },
    {
      'pergunta': 'Como ganho pontos e badges?',
      'resposta':
          'Cada doação vale pontos consoante o tipo. Alimentos valem 30pts, Cobertores 25pts, Higiene 20pts, Material Escolar 15pts e Apoio Financeiro 40pts. Os pontos acumulam e desbloqueiam badges automàticamente.',
    },
    {
      'pergunta': 'Posso cancelar uma doação agendada?',
      'resposta':
          'Sim. No separador "Histórico", toca na doação que queres cancelar e selecciona "Cancelar Agendamento". Tenta fazê-lo com pelo menos 24 horas de antecedência.',
    },
    {
      'pergunta': 'Como edito o meu perfil?',
      'resposta':
          'Vai ao separador "Perfil" no menu inferior e toca em "Editar Perfil". Podes alterar o nome, email e foto de perfil.',
    },
    {
      'pergunta': 'Os meus dados estão seguros?',
      'resposta':
          'Sim. Os teus dados são armazenados de forma segura e nunca são partilhados com terceiros. A tua privacidade é a nossa prioridade.',
    },
  ];

  final List<Map<String, String>> _faqInstituicao = [
    {
      'pergunta': 'Como apareço no mapa dos doadores?',
      'resposta':
          'Após criar a conta e completar o perfil, define a localização da tua instituição no separador "Perfil" → "Localização no Mapa". A tua instituição aparece imediatamente no mapa.',
    },
    {
      'pergunta': 'Como actualizo as necessidades?',
      'resposta':
          'No separador "Necessidades", selecciona as categorias urgentes e escreve uma descrição detalhada. Esta informação aparece para os doadores quando tocam no teu pin.',
    },
    {
      'pergunta': 'Como confirmo a receção de uma doação?',
      'resposta':
          'No separador "Painel", toca na doação agendada e selecciona "Confirmar Receção". O doador recebe uma notificação automàtica.',
    },
    {
      'pergunta': 'Posso estar no mapa mas sem aceitar doações?',
      'resposta':
          'Sim. No separador "Painel", o switch de "Visibilidade no Mapa" permite-te aparecer como "Estável" (verde) em vez de "Precisa de Ajuda" (laranja).',
    },
    {
      'pergunta': 'A app é gratuita para instituições?',
      'resposta':
          'Sim, completamente gratuita. O Doa Certo é uma plataforma sem fins lucrativos criada para ajudar Moçambique.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color themeColor = _isDonor ? const Color(0xFF10B981) : Colors.blue;
    final faqs = _isDonor ? _faqDoador : _faqInstituicao;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Ajuda"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              color: themeColor.withOpacity(0.08),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.help_rounded,
                        color: themeColor, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Como podemos ajudar?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Encontra respostas às perguntas mais frequentes.",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                "Perguntas Frequentes",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 0.8,
                ),
              ),
            ),

            ...faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;
              final isExpanded = _expandido == index;

              return Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isExpanded
                        ? themeColor.withOpacity(0.3)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        faq['pergunta']!,
                        style: TextStyle(
                          fontWeight: isExpanded
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 14,
                          color: isExpanded
                              ? themeColor
                              : const Color(0xFF1F2937),
                        ),
                      ),
                      trailing: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_down,
                            color: isExpanded
                                ? themeColor
                                : Colors.grey),
                      ),
                      onTap: () {
                        setState(() {
                          _expandido = isExpanded ? null : index;
                        });
                      },
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['resposta']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                "Ainda tens dúvidas?",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 0.8,
                ),
              ),
            ),

            _contactoItem(
              Icons.email_outlined,
              "Enviar email",
              "suporte@doacerto.co.mz",
              themeColor,
              () {},
            ),
            _contactoItem(
              Icons.chat_bubble_outline,
              "WhatsApp",
              "+258 84 000 0000",
              themeColor,
              () {},
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _contactoItem(
    IconData icon,
    String titulo,
    String subtitulo,
    Color themeColor,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: themeColor, size: 22),
        ),
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitulo,
            style: TextStyle(color: Colors.grey[500], fontSize: 13)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}