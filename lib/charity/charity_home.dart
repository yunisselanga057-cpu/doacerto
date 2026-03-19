import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:doacerto/charity/charity_location_page.dart';
import 'package:doacerto/pages/edit_profile_page.dart';
import 'package:doacerto/donor/notifications_page.dart';
import 'package:doacerto/donor/help_page.dart';
import 'package:doacerto/donor/about_page.dart';
import 'package:doacerto/pages/welcome_page.dart';

class CharityHomePage extends StatefulWidget {
  const CharityHomePage({super.key});

  @override
  State<CharityHomePage> createState() => _CharityHomePageState();
}

class _CharityHomePageState extends State<CharityHomePage> {
  int _paginaActual = 0;

  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      const _PainelPage(),
      const _NecessidadesPage(),
      const _PerfilInstituicaoPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _paginaActual,
        children: _paginas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _paginaActual = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Painel",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_outlined),
            activeIcon: Icon(Icons.volunteer_activism),
            label: "Necessidades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            activeIcon: Icon(Icons.account_balance),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}

class _PainelPage extends StatefulWidget {
  const _PainelPage();

  @override
  State<_PainelPage> createState() => _PainelPageState();
}

class _PainelPageState extends State<_PainelPage> {
  bool _precisaAjuda = true;
  String _nomeInstituicao = "Instituição";
  String? _imagemPath;

  final List<Map<String, dynamic>> _doacoes = [
    {
      'doador': 'Yuyu Langa',
      'itens': 'Cesto Básico, Cobertores',
      'data': '22/05',
      'hora': '14:30',
      'status': 'Pendente',
      'statusCor': Colors.orange,
    },
    {
      'doador': 'Anónimo',
      'itens': 'Material Escolar',
      'data': '23/05',
      'hora': '09:00',
      'status': 'Confirmado',
      'statusCor': Color(0xFF10B981),
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeInstituicao = prefs.getString('userName') ?? "Instituição";
      _imagemPath = prefs.getString('userImagePath');
      _precisaAjuda = prefs.getBool('precisaAjuda') ?? true;
    });
  }

  Future<void> _toggleStatus(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('precisaAjuda', val);
    setState(() => _precisaAjuda = val);
  }

  void _mostrarDetalhes(Map<String, dynamic> doacao) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Doação de ${doacao['doador']}",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _infoRow(Icons.inventory_2_outlined, "Itens", doacao['itens']),
              const SizedBox(height: 12),
              _infoRow(Icons.calendar_today, "Agendado para",
                  "${doacao['data']} às ${doacao['hora']}"),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.circle, size: 14, color: Colors.grey),
                  const SizedBox(width: 10),
                  const Text("Status: ",
                      style: TextStyle(color: Colors.grey)),
                  Text(
                    doacao['status'],
                    style: TextStyle(
                        color: doacao['statusCor'],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (doacao['status'] == 'Pendente')
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      setState(() {
                        doacao['status'] = 'Confirmado';
                        doacao['statusCor'] = const Color(0xFF10B981);
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Doação confirmada!"),
                          backgroundColor: Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text("Confirmar Receção",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(valor,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendentes =
        _doacoes.where((d) => d['status'] == 'Pendente').length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_nomeInstituicao),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              backgroundImage: _imagemPath != null
                  ? FileImage(File(_imagemPath!))
                  : null,
              child: _imagemPath == null
                  ? const Icon(Icons.account_balance,
                      size: 18, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Visibilidade no Mapa",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _precisaAjuda,
                        activeColor: Colors.orange,
                        inactiveThumbColor: const Color(0xFF10B981),
                        inactiveTrackColor:
                            const Color(0xFF10B981).withOpacity(0.3),
                        onChanged: _toggleStatus,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _precisaAjuda
                          ? Colors.orange.withOpacity(0.1)
                          : const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _precisaAjuda
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          color: _precisaAjuda
                              ? Colors.orange
                              : const Color(0xFF10B981),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _precisaAjuda
                              ? "Visível como: PRECISA DE AJUDA 🟠"
                              : "Visível como: TUDO OK 🟢",
                          style: TextStyle(
                            color: _precisaAjuda
                                ? Colors.orange
                                : const Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (pendentes > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active,
                        color: Colors.orange),
                    const SizedBox(width: 12),
                    Text(
                      "$pendentes doação(ões) aguardam confirmação",
                      style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  const Text(
                    "Doações Agendadas",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    "${_doacoes.length} total",
                    style:
                        TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),

            _doacoes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.inbox_outlined,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          "Ainda não há doações agendadas",
                          style:
                              TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _doacoes.length,
                    itemBuilder: (context, index) {
                      final doacao = _doacoes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 1,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(Icons.volunteer_activism,
                                color: Colors.blue),
                          ),
                          title: Text(doacao['doador'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(doacao['itens'],
                                  style:
                                      const TextStyle(fontSize: 13)),
                              Text(
                                  "${doacao['data']} às ${doacao['hora']}",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12)),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (doacao['statusCor'] as Color)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              doacao['status'],
                              style: TextStyle(
                                color: doacao['statusCor'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          onTap: () => _mostrarDetalhes(doacao),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _NecessidadesPage extends StatefulWidget {
  const _NecessidadesPage();

  @override
  State<_NecessidadesPage> createState() => _NecessidadesPageState();
}

class _NecessidadesPageState extends State<_NecessidadesPage> {
  final TextEditingController _necessidadeController =
      TextEditingController();
  String _necessidadeActual = "";
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categorias = [
    {'nome': 'Alimentos', 'icon': Icons.bakery_dining_rounded},
    {'nome': 'Cobertores', 'icon': Icons.bed_rounded},
    {'nome': 'Higiene', 'icon': Icons.sanitizer_rounded},
    {'nome': 'Roupas', 'icon': Icons.checkroom_rounded},
    {'nome': 'Medicamentos', 'icon': Icons.medication_rounded},
    {'nome': 'Leite', 'icon': Icons.local_drink_rounded},
    {'nome': 'Material Escolar', 'icon': Icons.menu_book_rounded},
    {'nome': 'Dinheiro', 'icon': Icons.savings_rounded},
  ];

  List<String> _categoriasSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    _carregarNecessidade();
  }

  @override
  void dispose() {
    _necessidadeController.dispose();
    super.dispose();
  }

  Future<void> _carregarNecessidade() async {
    final prefs = await SharedPreferences.getInstance();
    final descricao = prefs.getString('instituicaoDescricao') ?? "";
    final categorias =
        prefs.getStringList('instituicaoCategorias') ?? [];
    setState(() {
      _necessidadeActual = descricao;
      _necessidadeController.text = descricao;
      _categoriasSeleccionadas = categorias;
      _isLoading = false;
    });
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'instituicaoDescricao', _necessidadeController.text.trim());
    await prefs.setStringList(
        'instituicaoCategorias', _categoriasSeleccionadas);

    setState(() =>
        _necessidadeActual = _necessidadeController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Necessidades actualizadas!"),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.blue));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("As nossas Necessidades"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Esta informação aparece no mapa para os doadores verem o que precisas.",
                      style: TextStyle(
                          color: Colors.blue[800], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Selecciona as categorias urgentes",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categorias.map((cat) {
                final bool selected =
                    _categoriasSeleccionadas.contains(cat['nome']);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected
                          ? _categoriasSeleccionadas.remove(cat['nome'])
                          : _categoriasSeleccionadas.add(cat['nome']);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.blue
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: selected
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'] as IconData,
                          size: 16,
                          color: selected
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['nome'],
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.grey[700],
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            const Text(
              "Descrição detalhada",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _necessidadeController,
              maxLines: 4,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText:
                    "Ex: Precisamos urgentemente de leite em pó e cobertores para as crianças mais pequenas.",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            if (_necessidadeActual.isNotEmpty) ...[
              const Text(
                "Preview — O que os doadores vêem:",
                style:
                    TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  "⚠️ Preciso de ajuda: $_necessidadeActual",
                  style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  "Guardar Necessidades",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerfilInstituicaoPage extends StatefulWidget {
  const _PerfilInstituicaoPage();

  @override
  State<_PerfilInstituicaoPage> createState() =>
      _PerfilInstituicaoPageState();
}

class _PerfilInstituicaoPageState
    extends State<_PerfilInstituicaoPage> {
  String _nome = "";
  String _email = "";
  String? _imagemPath;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('userName') ?? "Instituição";
      _email = prefs.getString('userEmail') ?? "";
      _imagemPath = prefs.getString('userImagePath');
      _lat = prefs.getDouble('instituicaoLat');
      _lng = prefs.getDouble('instituicaoLng');
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
        (route) => false,
      );
    }
  }

  void _abrirLocalizacao() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => const CharityLocationPage()),
    );
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final bool temLocalizacao = _lat != null && _lng != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Perfil da Instituição"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue.withOpacity(0.15),
                    backgroundImage: _imagemPath != null
                        ? FileImage(File(_imagemPath!))
                        : null,
                    child: _imagemPath == null
                        ? const Icon(Icons.account_balance,
                            size: 48, color: Colors.blue)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nome,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (_email.isNotEmpty)
                    Text(_email,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "🏛️ Instituição",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: temLocalizacao
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    child: Icon(
                      Icons.location_on,
                      color: temLocalizacao
                          ? const Color(0xFF10B981)
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Localização no Mapa",
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(
                          temLocalizacao
                              ? "Definida: ${_lat!.toStringAsFixed(3)}, ${_lng!.toStringAsFixed(3)}"
                              : "Ainda não definida",
                          style: TextStyle(
                              color: temLocalizacao
                                  ? Colors.grey[500]
                                  : Colors.orange,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _abrirLocalizacao,
                    child: Text(
                      temLocalizacao ? "Editar" : "Definir",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            _opcaoItem(Icons.edit, "Editar Perfil", () async {
              final alterado = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                    builder: (_) => const EditProfilePage()),
              );
              if (alterado == true) _carregarDados();
            }),
            _opcaoItem(Icons.notifications_outlined, "Notificações", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificacoesPage()),
              );
            }),
            _opcaoItem(Icons.help_outline, "Ajuda", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AjudaPage()),
              );
            }),
            _opcaoItem(Icons.info_outline, "Sobre o Doa Certo", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SobrePage()),
              );
            }),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Sair da conta",
                      style: TextStyle(
                          color: Colors.red, fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  Widget _opcaoItem(
      IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}