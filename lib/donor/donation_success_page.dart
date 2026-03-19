import 'package:flutter/material.dart';
import 'package:doacerto/donor/donor_home.dart';

class DonationSuccessPage extends StatelessWidget {
  final String nomeInstituicao;
  final List<String> itensSelecionados;
  final DateTime dataSelecionada;
  final TimeOfDay horaSelecionada;

  const DonationSuccessPage({
    super.key,
    required this.nomeInstituicao,
    required this.itensSelecionados,
    required this.dataSelecionada,
    required this.horaSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    final String data =
        "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}";
    final String hora = horaSelecionada.format(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 72,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "Doação Agendada! 🎉",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Obrigado por ajudar $nomeInstituicao.\nA tua generosidade faz a diferença!",
                style: TextStyle(
                    fontSize: 16, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resumo do agendamento",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 16),
                    _resumoItem(Icons.account_balance, "Instituição",
                        nomeInstituicao),
                    const SizedBox(height: 12),
                    _resumoItem(
                      Icons.inventory_2_outlined,
                      "O que vais levar",
                      itensSelecionados.join(", "),
                    ),
                    const SizedBox(height: 12),
                    _resumoItem(Icons.calendar_today, "Data", data),
                    const SizedBox(height: 12),
                    _resumoItem(Icons.access_time, "Hora", hora),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DonorHomePage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    "Voltar ao Mapa",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Fazer outra doação",
                  style:
                      TextStyle(color: Color(0xFF10B981), fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resumoItem(IconData icon, String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF10B981)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      TextStyle(color: Colors.grey[500], fontSize: 12)),
              const SizedBox(height: 2),
              Text(valor,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}