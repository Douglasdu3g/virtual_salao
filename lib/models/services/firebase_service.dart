import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../barber.dart';
import '../localizacao.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collection = 'barbeiros';

  // Adicionar um novo barbeiro
  Future<String> adicionarBarbeiro(Barbeiro barbeiro,
      {File? imagemPerfil}) async {
    try {
      // Se houver uma imagem, fazer upload primeiro
      String urlImagem = '';
      if (imagemPerfil != null) {
        urlImagem = await _uploadImagem(imagemPerfil, barbeiro.id);
      }

      // Criar mapa de dados do barbeiro
      final dadosBarbeiro = barbeiro.toJson();

      // Converter localização para GeoPoint
      dadosBarbeiro['localizacao'] = GeoPoint(
        barbeiro.localizacao.latitude,
        barbeiro.localizacao.longitude,
      );

      if (urlImagem.isNotEmpty) {
        dadosBarbeiro['fotoPerfil'] = urlImagem;
      }

      // Adicionar ao Firestore
      await _firestore
          .collection(_collection)
          .doc(barbeiro.id)
          .set(dadosBarbeiro);
      return barbeiro.id;
    } catch (e) {
      throw Exception('Erro ao adicionar barbeiro: $e');
    }
  }

  // Upload de imagem para o Storage
  Future<String> _uploadImagem(File imagem, String barbeirId) async {
    try {
      final ref = _storage.ref().child('barbeiros/$barbeirId/perfil.jpg');
      await ref.putFile(imagem);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  // Buscar todos os barbeiros
  Stream<List<Barbeiro>> getBarbeiros() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Tratar a localização corretamente
        Localizacao localizacao;
        if (data['localizacao'] is GeoPoint) {
          final geoPoint = data['localizacao'] as GeoPoint;
          localizacao = Localizacao(
            latitude: geoPoint.latitude,
            longitude: geoPoint.longitude,
          );
        } else if (data['localizacao'] is Map) {
          localizacao = Localizacao(
            latitude: (data['localizacao']['latitude'] ?? 0.0).toDouble(),
            longitude: (data['localizacao']['longitude'] ?? 0.0).toDouble(),
          );
        } else {
          localizacao = Localizacao(latitude: 0.0, longitude: 0.0);
        }

        return Barbeiro(
          id: doc.id,
          nome: data['nome'] ?? '',
          especialidades: List<String>.from(data['especialidades'] ?? []),
          avaliacao: (data['avaliacao'] ?? 5.0).toDouble(),
          localizacao: localizacao,
          disponivelAgora: data['disponivelAgora'] ?? false,
          contato: data['contato'] ?? '',
          fotoPerfil: data['fotoPerfil'] ?? '',
        );
      }).toList();
    });
  }

  // Buscar um barbeiro específico
  Future<Barbeiro?> getBarbeiro(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;

        // Tratar a localização corretamente
        Localizacao localizacao;
        if (data['localizacao'] is GeoPoint) {
          final geoPoint = data['localizacao'] as GeoPoint;
          localizacao = Localizacao(
            latitude: geoPoint.latitude,
            longitude: geoPoint.longitude,
          );
        } else if (data['localizacao'] is Map) {
          localizacao = Localizacao(
            latitude: (data['localizacao']['latitude'] ?? 0.0).toDouble(),
            longitude: (data['localizacao']['longitude'] ?? 0.0).toDouble(),
          );
        } else {
          localizacao = Localizacao(latitude: 0.0, longitude: 0.0);
        }

        return Barbeiro(
          id: doc.id,
          nome: data['nome'] ?? '',
          especialidades: List<String>.from(data['especialidades'] ?? []),
          avaliacao: (data['avaliacao'] ?? 5.0).toDouble(),
          localizacao: localizacao,
          disponivelAgora: data['disponivelAgora'] ?? false,
          contato: data['contato'] ?? '',
          fotoPerfil: data['fotoPerfil'] ?? '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar barbeiro: $e');
    }
  }

  // Atualizar um barbeiro
  Future<void> atualizarBarbeiro(Barbeiro barbeiro, {File? novaImagem}) async {
    try {
      final dadosAtualizados = barbeiro.toJson();

      // Converter localização para GeoPoint
      dadosAtualizados['localizacao'] = GeoPoint(
        barbeiro.localizacao.latitude,
        barbeiro.localizacao.longitude,
      );

      if (novaImagem != null) {
        final urlImagem = await _uploadImagem(novaImagem, barbeiro.id);
        dadosAtualizados['fotoPerfil'] = urlImagem;
      }

      await _firestore
          .collection(_collection)
          .doc(barbeiro.id)
          .update(dadosAtualizados);
    } catch (e) {
      throw Exception('Erro ao atualizar barbeiro: $e');
    }
  }

  // Excluir um barbeiro
  Future<void> excluirBarbeiro(String id) async {
    try {
      // Excluir imagem do Storage
      try {
        await _storage.ref().child('barbeiros/$id/perfil.jpg').delete();
      } catch (e) {
        // Ignora erro se a imagem não existir
      }

      // Excluir documento do Firestore
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao excluir barbeiro: $e');
    }
  }
}
