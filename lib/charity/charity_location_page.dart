import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharityLocationPage extends StatefulWidget {
  const CharityLocationPage({super.key});

  @override
  State<CharityLocationPage> createState() => _CharityLocationPageState();
}

class _CharityLocationPageState extends State<CharityLocationPage> {
  LatLng _pinLocation = const LatLng(-25.9692, 32.5732);
  bool _guardado = false;

  Future<void> _guardarLocalizacao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('instituicaoLat', _pinLocation.latitude);
    await prefs.setDouble('instituicaoLng', _pinLocation.longitude);

    setState(() => _guardado = true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Localização guardada com sucesso!"),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.pop(context, _pinLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Definir Localização"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
        
          FlutterMap(
            options: MapOptions(
              initialCenter: _pinLocation,
              initialZoom: 14,
              
              onTap: (tapPosition, point) {
                setState(() {
                  _pinLocation = point;
                  _guardado = false;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.doacerto',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pinLocation,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Toca no mapa para colocar o pin na localização da tua instituição",
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              children: [
              
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.gps_fixed,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Lat: ${_pinLocation.latitude.toStringAsFixed(4)}  |  Lng: ${_pinLocation.longitude.toStringAsFixed(4)}",
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
            
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _guardado ? null : _guardarLocalizacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: Icon(
                      _guardado
                          ? Icons.check_circle
                          : Icons.save_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      _guardado
                          ? "Localização Guardada"
                          : "Guardar esta Localização",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}