import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../localizacao.dart';

class LocationService {
  // Verificar se o serviço de localização está habilitado
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Verificar e solicitar permissões de localização
  static Future<LocationPermission> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente');
    }

    return permission;
  }

  // Obter a localização atual do usuário
  static Future<Localizacao> getCurrentLocation() async {
    try {
      // Verificar se o serviço está habilitado
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Serviço de localização desabilitado');
      }

      // Verificar permissões
      await checkPermission();

      // Obter posição atual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint(
          'Localização obtida: ${position.latitude}, ${position.longitude}');

      return Localizacao(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');
      rethrow;
    }
  }

  // Calcular distância entre dois pontos
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Obter localização padrão (São Paulo) para testes
  static Localizacao getDefaultLocation() {
    return Localizacao(
      latitude: -23.550520,
      longitude: -46.633308,
    );
  }
}
