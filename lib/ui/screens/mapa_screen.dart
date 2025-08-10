import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/barber.dart';
import '../../models/localizacao.dart';
import '../../models/services/location_service.dart';
import '../../models/services/firebase_service.dart';
import 'barbeiro_detalhes_screen.dart';
import '../styles/colors.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? _mapController;
  Localizacao? _currentLocation;
  List<Barbeiro> _barbeiros = [];
  Set<Marker> _markers = {};
  bool _isLoading = true;
  final FirebaseService _firebaseService = FirebaseService();

  // Configurações iniciais do mapa (São Paulo como padrão)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-23.550520, -46.633308),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      debugPrint('Iniciando inicialização do mapa...');

      // Obter localização atual
      await _getCurrentLocation();
      debugPrint(
          'Localização obtida: ${_currentLocation?.latitude}, ${_currentLocation?.longitude}');

      // Carregar barbeiros
      await _loadBarbeiros();
      debugPrint('Barbeiros carregados: ${_barbeiros.length}');

      // Criar marcadores
      await _createMarkers();
      debugPrint('Marcadores criados: ${_markers.length}');

      debugPrint('Mapa inicializado com sucesso!');
    } catch (e) {
      debugPrint('Erro ao inicializar mapa: $e');
      // Verificar se o widget ainda está montado antes de usar o context
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar localização: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('Estado de loading definido como false');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await LocationService.getCurrentLocation();
      debugPrint(
          'Localização atual: ${_currentLocation?.latitude}, ${_currentLocation?.longitude}');
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');
      // Usar localização padrão se não conseguir obter a atual
      _currentLocation = LocationService.getDefaultLocation();
    }
  }

  Future<void> _loadBarbeiros() async {
    try {
      // Carrega a primeira emissão do Firestore
      _barbeiros = await _firebaseService.getBarbeiros().first;
      debugPrint('Barbeiros carregados: ${_barbeiros.length}');
    } catch (e) {
      debugPrint('Erro ao carregar barbeiros: $e');
    }
  }

  Future<void> _createMarkers() async {
    Set<Marker> markers = {};

    // Adicionar marcador da localização atual
    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position:
              LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Sua Localização',
            snippet: 'Você está aqui',
          ),
        ),
      );
    }

    // Adicionar marcadores dos barbeiros
    for (int i = 0; i < _barbeiros.length; i++) {
      final barbeiro = _barbeiros[i];
      markers.add(
        Marker(
          markerId: MarkerId('barbeiro_${barbeiro.id}'),
          position: LatLng(
              barbeiro.localizacao.latitude, barbeiro.localizacao.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            barbeiro.disponivelAgora
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: barbeiro.nome,
            snippet:
                '⭐ ${barbeiro.avaliacao} - ${barbeiro.disponivelAgora ? "Disponível" : "Indisponível"}',
          ),
          onTap: () => _showBarbeiroDetails(barbeiro),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _showBarbeiroDetails(Barbeiro barbeiro) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle do modal
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Foto e informações básicas
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    barbeiro.fotoPerfil,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blue,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barbeiro.nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(' ${barbeiro.avaliacao}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: barbeiro.disponivelAgora
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          barbeiro.disponivelAgora
                              ? 'Disponível'
                              : 'Indisponível',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Especialidades
            Text(
              'Especialidades:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(barbeiro.servicos.keys.join(', ')),

            const SizedBox(height: 16),

            // Distância (se tiver localização do usuário)
            if (_currentLocation != null)
              Text(
                'Distância: ${_calculateDistance(barbeiro).toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkBlue,
                ),
              ),

            const SizedBox(height: 20),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.info),
                    label: const Text('Ver Detalhes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BarbeiroDetalhesScreen(barbeiro: barbeiro),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions),
                    label: const Text('Rota'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _goToBarbeiro(barbeiro),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateDistance(Barbeiro barbeiro) {
    if (_currentLocation == null) return 0.0;

    return LocationService.calculateDistance(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          barbeiro.localizacao.latitude,
          barbeiro.localizacao.longitude,
        ) /
        1000; // Converter para km
  }

  void _goToBarbeiro(Barbeiro barbeiro) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              barbeiro.localizacao.latitude, barbeiro.localizacao.longitude),
          zoom: 16,
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _goToUserLocation() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
            zoom: 16,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'Build chamado - isLoading: $_isLoading, barbeiros: ${_barbeiros.length}, marcadores: ${_markers.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Barbeiros Próximos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _initializeMap();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Carregando mapa...',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _currentLocation != null
                      ? CameraPosition(
                          target: LatLng(_currentLocation!.latitude,
                              _currentLocation!.longitude),
                          zoom: 14,
                        )
                      : _initialPosition,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    debugPrint('GoogleMap criado com sucesso!');
                    _mapController = controller;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),

                // Botão para ir para a localização do usuário
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: _goToUserLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.blue,
                    ),
                  ),
                ),

                // Card com informações
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppColors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_barbeiros.length} barbeiros encontrados',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Toque nos marcadores para ver detalhes dos barbeiros',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
