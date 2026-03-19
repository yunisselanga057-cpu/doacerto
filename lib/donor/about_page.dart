import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SobrePage extends StatefulWidget {
  const SobrePage({super.key});

  @override
  State<SobrePage> createState() => _SobrePageState();
}

class _SobrePageState extends State<SobrePage> {
  bool _isDonor = true;

  @override
  void initState() {
    super.initState();
    _carregarTipo();
  }

  Future<void> _carregarTipo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isDonor = prefs.getBool('isDonor') ?? true);
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = _isDonor ? const Color(0xFF10B981) : Colors.blue;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Sobre o Doa Certo"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF064E3B),
                    const Color(0xFF065F46),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 2),
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Doa Certo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Versão 1.0.0",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFFBBF24).withOpacity(0.4)),
                    ),
                    child: const Text(
                      "🌍 Feito com ❤️ em Moçambique",
                      style: TextStyle(
                        color: Color(0xFFFBBF24),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _secaoCard(
              titulo: "A Nossa Missão",
              conteudo:
                  "O Doa Certo nasceu com um propósito simples: tornar a doação em Moçambique mais fácil, mais transparente e mais eficaz.\n\nConnectamos doadores generosos com instituições que realmente precisam, em tempo real, eliminando as barreiras que muitas vezes impedem a ajuda de chegar a quem mais necessita.",
              icon: Icons.flag_rounded,
              cor: const Color(0xFF10B981),
            ),
            _secaoCard(
              titulo: "Como Funciona",
              conteudo:
                  "As instituições registam-se, definem a sua localização no mapa e publicam as suas necessidades actuais.\n\nOs doadores vêem em tempo real quais as instituições que precisam de ajuda, escolhem o que podem oferecer e agendam a entrega de forma conveniente.\n\nTudo simples, transparente e impactante.",
              icon: Icons.lightbulb_outline_rounded,
              cor: const Color(0xFFF59E0B),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tituloSecao("Impacto até hoje", const Color(0xFF8B5CF6)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _statItem("234", "Doações\nrealizadas",
                              const Color(0xFF10B981))),
                      Expanded(
                          child: _statItem("18", "Instituições\nregistadas",
                              const Color(0xFF0EA5E9))),
                      Expanded(
                          child: _statItem("892", "Famílias\napoiadas",
                              const Color(0xFFF59E0B))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

    
            _secaoCard(
              titulo: "Tecnologia",
              conteudo:
                  "Desenvolvido com Flutter para Android e iOS.\nMapa baseado em OpenStreetMap.\nDados armazenados de forma segura com Firebase.\n\nO código é open-source e contribuicoes são bem-vindas.",
              icon: Icons.code_rounded,
              cor: const Color(0xFF0EA5E9),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _linkItem(
                      Icons.privacy_tip_outlined,
                      "Política de Privacidade",
                      themeColor,
                      () {}),
                  const Divider(height: 1, indent: 60),
                  _linkItem(
                      Icons.description_outlined,
                      "Termos de Uso",
                      themeColor,
                      () {}),
                  const Divider(height: 1, indent: 60),
                  _linkItem(
                      Icons.open_in_new,
                      "Ver no GitHub",
                      themeColor,
                      () {}),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "© 2026 Doa Certo · Maputo, Moçambique",
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              "Todos os direitos reservados",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _secaoCard({
    required String titulo,
    required String conteudo,
    required IconData icon,
    required Color cor,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tituloSecao(titulo, cor),
          const SizedBox(height: 12),
          Text(
            conteudo,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tituloSecao(String titulo, Color cor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _statItem(String valor, String label, Color cor) {
    return Column(
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 12, height: 1.4),
        ),
      ],
    );
  }

  Widget _linkItem(
      IconData icon, String label, Color themeColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: themeColor, size: 22),
      title: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}