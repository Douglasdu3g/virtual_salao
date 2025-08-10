import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/barber.dart';
import '../../models/localizacao.dart';
import '../../models/services/firebase_service.dart';
import '../../models/services/location_service.dart';

class CadastroBarbeiroScreen extends StatefulWidget {
  const CadastroBarbeiroScreen({super.key});

  @override
  State<CadastroBarbeiroScreen> createState() => _CadastroBarbeiroScreenState();
}

class _CadastroBarbeiroScreenState extends State<CadastroBarbeiroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _contatoController = TextEditingController();
  final _especialidadesController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _avaliacaoController = TextEditingController(text: '5.0');

  final _firebaseService = FirebaseService();

  File? _imagemPerfil;
  List<String> especialidades = [];
  bool _disponivelAgora = true;
  bool _isLoading = false;
  bool _buscandoLocalizacao = false;

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        _imagemPerfil = File(imagem.path);
      });
    }
  }

  void _adicionarEspecialidade() {
    if (_especialidadesController.text.isNotEmpty) {
      setState(() {
        especialidades.add(_especialidadesController.text.trim());
        _especialidadesController.clear();
      });
    }
  }

  void _removerEspecialidade(String especialidade) {
    setState(() {
      especialidades.remove(especialidade);
    });
  }

  Future<void> _obterLocalizacaoAtual() async {
    setState(() {
      _buscandoLocalizacao = true;
    });

    try {
      final posicao = await LocationService.getCurrentLocation();
      setState(() {
        _latitudeController.text = posicao.latitude.toString();
        _longitudeController.text = posicao.longitude.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Localização obtida com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    } finally {
      setState(() {
        _buscandoLocalizacao = false;
      });
    }
  }

  Future<void> _salvarBarbeiro() async {
    if (_formKey.currentState!.validate()) {
      if (especialidades.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Adicione pelo menos uma especialidade')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final novoBarbeiro = Barbeiro(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nome: _nomeController.text.trim(),
          especialidades: especialidades,
          avaliacao: double.parse(_avaliacaoController.text),
          localizacao: Localizacao(
            latitude: double.parse(_latitudeController.text),
            longitude: double.parse(_longitudeController.text),
          ),
          disponivelAgora: _disponivelAgora,
          contato: _contatoController.text.trim(),
          fotoPerfil: '',
        );

        await _firebaseService.adicionarBarbeiro(novoBarbeiro,
            imagemPerfil: _imagemPerfil);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Barbeiro cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao cadastrar barbeiro: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Barbeiro'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Foto de Perfil
                    Center(
                      child: GestureDetector(
                        onTap: _selecionarImagem,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _imagemPerfil != null
                              ? ClipOval(
                                  child: Image.file(
                                    _imagemPerfil!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt,
                                        size: 40, color: Colors.grey),
                                    Text('Foto',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nome Completo
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira o nome completo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // WhatsApp
                    TextFormField(
                      controller: _contatoController,
                      decoration: const InputDecoration(
                        labelText: 'WhatsApp *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        hintText: '(99) 99999-9999',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira o número do WhatsApp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Avaliação Inicial
                    TextFormField(
                      controller: _avaliacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Avaliação Inicial (0-5) *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.star),
                        hintText: '5.0',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a avaliação';
                        }
                        final avaliacao = double.tryParse(value);
                        if (avaliacao == null ||
                            avaliacao < 0 ||
                            avaliacao > 5) {
                          return 'Avaliação deve ser entre 0 e 5';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Especialidades
                    const Text(
                      'Especialidades',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _especialidadesController,
                            decoration: const InputDecoration(
                              labelText: 'Ex: Corte, Barba, Sobrancelha',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.content_cut),
                            ),
                            onFieldSubmitted: (_) => _adicionarEspecialidade(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _adicionarEspecialidade,
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (especialidades.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: especialidades.map((especialidade) {
                          return Chip(
                            label: Text(especialidade),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () =>
                                _removerEspecialidade(especialidade),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 16),

                    // Localização
                    const Text(
                      'Localização',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latitudeController,
                            decoration: const InputDecoration(
                              labelText: 'Latitude *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Latitude obrigatória';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Latitude inválida';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _longitudeController,
                            decoration: const InputDecoration(
                              labelText: 'Longitude *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Longitude obrigatória';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Longitude inválida';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed:
                          _buscandoLocalizacao ? null : _obterLocalizacaoAtual,
                      icon: _buscandoLocalizacao
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(_buscandoLocalizacao
                          ? 'Obtendo localização...'
                          : 'Usar minha localização'),
                    ),
                    const SizedBox(height: 16),

                    // Disponibilidade
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Disponível agora',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Switch(
                              value: _disponivelAgora,
                              onChanged: (value) {
                                setState(() {
                                  _disponivelAgora = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão Salvar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _salvarBarbeiro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar Barbeiro',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '* Campos obrigatórios',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _contatoController.dispose();
    _especialidadesController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _avaliacaoController.dispose();
    super.dispose();
  }
}
