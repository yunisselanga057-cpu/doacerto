import 'package:flutter/material.dart';
import 'package:doacerto/donor/donation_success_page.dart';

class DonationFormPage extends StatefulWidget {
  final String nomeInstituicao;
  final String instituicaoNecessidade;

  const DonationFormPage({
    super.key,
    required this.nomeInstituicao,
    required this.instituicaoNecessidade,
  });

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  List<String> itensSelecionados = [];
  String _metodoEntrega = "Eu vou entregar";
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;

  final List<Map<String, dynamic>> categorias = [
    {
      'nome': 'Cesto Básico (Alimentos)',
      'icon': Icons.bakery_dining_rounded,
      'tipo': 'Alimentos',
    },
    {
      'nome': 'Vestuário e Calçado',
      'icon': Icons.checkroom_rounded,
      'tipo': 'Cobertores',
    },
    {
      'nome': 'Higiene e Limpeza',
      'icon': Icons.sanitizer_rounded,
      'tipo': 'Higiene',
    },
    {
      'nome': 'Apoio Financeiro',
      'icon': Icons.savings_rounded,
      'tipo': 'Dinheiro',
    },
    {
      'nome': 'Material Escolar',
      'icon': Icons.menu_book_rounded,
      'tipo': 'Cadernos',
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: Color(0xFF10B981)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dataSelecionada = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: Color(0xFF10B981)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _horaSelecionada = picked);
  }

  bool get _formularioValido =>
      itensSelecionados.isNotEmpty && _dataSelecionada != null;

  void _confirmarDoacao() {
    final hora = _horaSelecionada ?? const TimeOfDay(hour: 9, minute: 0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DonationSuccessPage(
          nomeInstituicao: widget.nomeInstituicao,
          itensSelecionados: itensSelecionados,
          dataSelecionada: _dataSelecionada!,
          horaSelecionada: hora,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doar para ${widget.nomeInstituicao}"),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "O que pretende doar?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Pode selecionar mais de uma categoria.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final cat = categorias[index];
                final bool ePrioridade = widget.instituicaoNecessidade
                    .toLowerCase()
                    .contains(cat['tipo']!.toLowerCase());
                final bool isSelected =
                    itensSelecionados.contains(cat['nome']);

                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected
                        ? itensSelecionados.remove(cat['nome'])
                        : itensSelecionados.add(cat['nome']);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF10B981).withOpacity(0.07)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: ePrioridade
                            ? Colors.orange
                            : (isSelected
                                ? const Color(0xFF10B981)
                                : Colors.grey.shade300),
                        width: ePrioridade ? 2.5 : 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(cat['icon'],
                            color: isSelected
                                ? const Color(0xFF10B981)
                                : Colors.grey),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat['nome'],
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (ePrioridade)
                                const Text(
                                  "⭐ NECESSIDADE URGENTE",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: Color(0xFF10B981)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),
            const Text(
              "Método de Entrega",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _metodoChip("Eu vou entregar", Icons.directions_walk),
                const SizedBox(width: 10),
                _metodoChip(
                    "Enviar por mototaxi", Icons.delivery_dining),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              "Quando podes entregar?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_month,
                        color: Color(0xFF10B981)),
                    label: Text(
                      _dataSelecionada == null
                          ? "Escolher dia"
                          : "${_dataSelecionada!.day.toString().padLeft(2, '0')}/${_dataSelecionada!.month.toString().padLeft(2, '0')}",
                      style: const TextStyle(color: Color(0xFF1F2937)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _dataSelecionada != null
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade400,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time,
                        color: Color(0xFF10B981)),
                    label: Text(
                      _horaSelecionada == null
                          ? "Hora"
                          : _horaSelecionada!.format(context),
                      style: const TextStyle(color: Color(0xFF1F2937)),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _horaSelecionada != null
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade400,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),

            if (itensSelecionados.isNotEmpty &&
                _dataSelecionada == null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 14, color: Colors.orange[700]),
                  const SizedBox(width: 6),
                  Text(
                    "Por favor, seleciona uma data de entrega.",
                    style: TextStyle(
                        color: Colors.orange[700], fontSize: 13),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _formularioValido ? _confirmarDoacao : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _formularioValido
                      ? "Confirmar Doação ✓"
                      : "Seleciona itens e data",
                  style: TextStyle(
                    color: _formularioValido
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _metodoChip(String label, IconData icon) {
    final bool selected = _metodoEntrega == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _metodoEntrega = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF10B981).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF10B981)
                  : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected
                      ? const Color(0xFF10B981)
                      : Colors.grey),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? const Color(0xFF10B981)
                        : Colors.grey[700],
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}