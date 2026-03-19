import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doacerto/donor/donationForm_page.dart';
import 'package:doacerto/donor/donor_impact_page.dart';
import 'package:doacerto/donor/donor_badges_page.dart';
import 'package:doacerto/pages/edit_profile_page.dart';
import 'package:doacerto/donor/notifications_page.dart';
import 'package:doacerto/donor/help_page.dart';
import 'package:doacerto/donor/about_page.dart';
import 'package:doacerto/pages/welcome_page.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  int _paginaActual = 0;

  late final List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      const _MapaPage(),
      const _HistoricoPage(),
      const DonorImpactPage(),
      const DonorBadgesPage(),
      const _PerfilPage(),
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
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, 
        onTap: (index) => setState(() => _paginaActual = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: "Mapa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: "Histórico",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: "Impacto",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: "Badges",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}

class _MapaPage extends StatelessWidget {
  const _MapaPage();

  final List<Map<String, dynamic>> instituicoes = const [
    {
      'nome': 'Orfanato Matola',
      'lat': -25.9600,
      'lng': 32.5100,
      'cor': Colors.red,
      'info': 'Falta de leite',
    },
    {
      'nome': 'Igreja Anglicana Maputo',
      'lat': -25.9750,
      'lng': 32.5800,
      'cor': Colors.green,
      'info': 'Tudo OK',
    },
    {
      'nome': 'Centro Esperança',
      'lat': -25.9500,
      'lng': 32.5600,
      'cor': Colors.orange,
      'info': 'Faltam cobertores',
    },
  ];

  Future<String> _getGreeting() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('userName');
    if (nome != null && nome.isNotEmpty) return "Olá, $nome!";
    final email = prefs.getString('userEmail') ?? "Doador";
    return "Olá, ${email.split('@').first}!";
  }

  Future<String?> _getUserImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userImagePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _getGreeting(),
          builder: (context, snapshot) =>
              Text(snapshot.data ?? "Olá!", style: const TextStyle(fontSize: 18)),
        ),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<String?>(
            future: _getUserImagePath(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
                  backgroundImage: snapshot.hasData && snapshot.data != null
                      ? FileImage(File(snapshot.data!))
                      : null,
                  child: snapshot.hasData && snapshot.data != null
                      ? null
                      : const Icon(Icons.person, size: 20, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-25.9692, 32.5732),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.doacerto',
              ),
              MarkerLayer(
                markers: instituicoes.map((inst) {
                  return Marker(
                    point: LatLng(inst['lat'], inst['lng']),
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => _mostrarDetalhes(context, inst),
                      child: Column(
                        children: [
                          Icon(Icons.location_on,
                              color: inst['cor'], size: 38),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: Text(
                              inst['nome'].toString().split(' ').first,
                              style: const TextStyle(fontSize: 9),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendaItem(Colors.red, "Urgente"),
                  const SizedBox(height: 4),
                  _legendaItem(Colors.orange, "Precisa de ajuda"),
                  const SizedBox(height: 4),
                  _legendaItem(Colors.green, "Estável"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendaItem(Color cor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: cor, size: 12),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  void _mostrarDetalhes(BuildContext context, Map<String, dynamic> inst) {
    final bool precisaAjuda = inst['cor'] != Colors.green;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      inst['nome'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(Icons.circle, color: inst['cor'], size: 14),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                precisaAjuda
                    ? "🚨 Urgência: ${inst['info']}"
                    : "✅ Esta instituição está estável",
                style: TextStyle(
                  fontSize: 15,
                  color: precisaAjuda ? Colors.red[700] : Colors.grey[600],
                  fontWeight:
                      precisaAjuda ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (precisaAjuda)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.volunteer_activism,
                        color: Colors.white),
                    label: const Text(
                      "Ajudar Agora",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DonationFormPage(
                            nomeInstituicao: inst['nome'],
                            instituicaoNecessidade: inst['info'],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Text(
                    "Obrigado pelo interesse! ❤️",
                    style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoricoPage extends StatelessWidget {
  const _HistoricoPage();

  final List<Map<String, dynamic>> _historico = const [
    {
      'instituicao': 'Orfanato Matola',
      'itens': 'Cesto Básico, Leite',
      'data': '15/03/2025',
      'status': 'Entregue',
      'statusCor': Color(0xFF10B981),
      'icon': Icons.check_circle,
    },
    {
      'instituicao': 'Centro Esperança',
      'itens': 'Cobertores',
      'data': '02/02/2025',
      'status': 'Entregue',
      'statusCor': Color(0xFF10B981),
      'icon': Icons.check_circle,
    },
    {
      'instituicao': 'Igreja Anglicana',
      'itens': 'Material Escolar',
      'data': '22/05/2025',
      'status': 'Agendado',
      'statusCor': Colors.orange,
      'icon': Icons.schedule,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("As minhas Doações"),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_historico.length} doações realizadas",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "Obrigado por fazeres a diferença! ❤️",
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _historico.length,
              itemBuilder: (context, index) {
                final item = _historico[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 1,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor:
                          (item['statusCor'] as Color).withOpacity(0.1),
                      child: Icon(item['icon'] as IconData,
                          color: item['statusCor'] as Color),
                    ),
                    title: Text(item['instituicao'],
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['itens'],
                            style: const TextStyle(fontSize: 13)),
                        Text(item['data'],
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (item['statusCor'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(
                          color: item['statusCor'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfilPage extends StatefulWidget {
  const _PerfilPage();

  @override
  State<_PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<_PerfilPage> {
  String _nome = "";
  String _email = "";
  String? _imagemPath;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('userName') ?? "Doador";
      _email = prefs.getString('userEmail') ?? "";
      _imagemPath = prefs.getString('userImagePath');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("O meu Perfil"),
        backgroundColor: const Color(0xFF10B981),
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
                    backgroundColor:
                        const Color(0xFF10B981).withOpacity(0.15),
                    backgroundImage: _imagemPath != null
                        ? FileImage(File(_imagemPath!))
                        : null,
                    child: _imagemPath == null
                        ? const Icon(Icons.person,
                            size: 48, color: Color(0xFF10B981))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(_nome,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  if (_email.isNotEmpty)
                    Text(_email,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                      style:
                          TextStyle(color: Colors.red, fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

  Widget _opcaoItem(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF10B981)),
        title: Text(label),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}