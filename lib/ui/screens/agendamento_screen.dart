import 'package:flutter/material.dart';
import '../../models/barber.dart';
import '../../models/agendamento.dart';
import '../../models/services/database_service.dart';

class AgendamentoScreen extends StatefulWidget {
  final Barbeiro barbeiro;

  const AgendamentoScreen({super.key, required this.barbeiro});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  DateTime? dataSelecionada;
  TimeOfDay? horarioSelecionado;
  String? servicoSelecionado;
  final precos = {
    'Corte Masculino': 50.0,
    'Barba': 30.0,
    'Sobrancelha': 20.0,
    'Corte Infantil': 40.0,
    'Corte Feminino': 60.0,
  };

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (data != null) {
      setState(() => dataSelecionada = data);
      _selecionarHorario(); // Abre seleção de horário automaticamente
    }
  }

  Future<void> _selecionarHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horario != null) {
      setState(() => horarioSelecionado = horario);
    }
  }

  void _confirmarAgendamento() async {
    if (dataSelecionada == null ||
        horarioSelecionado == null ||
        servicoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    // Criar objeto DateTime combinando data e hora
    final dataHora = DateTime(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
      horarioSelecionado!.hour,
      horarioSelecionado!.minute,
    );

    // Verificar se horário está disponível
    final dbService = DatabaseService();
    final disponivel =
        await dbService.horarioDisponivel(widget.barbeiro.id, dataHora);

    if (!disponivel) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Este horário já está agendado. Por favor, escolha outro horário.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final agendamento = Agendamento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barbeiroid: widget.barbeiro.id,
      data: dataHora,
      servico: servicoSelecionado!,
      preco: precos[servicoSelecionado] ?? 0.0,
      status: 'pendente',
    );

    try {
      // Salvar no banco de dados
      await dbService.salvarAgendamento(agendamento);

      // Mostrar confirmação
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Agendamento Realizado!'),
          content: Text(
            'Agendamento com ${widget.barbeiro.nome}\n'
            'Data: ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}\n'
            'Horário: ${horarioSelecionado!.format(context)}\n'
            'Serviço: $servicoSelecionado\n'
            'Valor: R\$ ${precos[servicoSelecionado]?.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                Navigator.of(context).pop(); // Volta para tela anterior
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar agendamento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar com ${widget.barbeiro.nome}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  dataSelecionada != null
                      ? '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}'
                      : 'Selecione uma data',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selecionarData,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  horarioSelecionado != null
                      ? horarioSelecionado!.format(context)
                      : 'Selecione um horário',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _selecionarHorario,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selecione o serviço:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.barbeiro.especialidades.length,
                itemBuilder: (context, index) {
                  final servico = widget.barbeiro.especialidades[index];
                  return RadioListTile<String>(
                    title: Text(servico),
                    subtitle:
                        Text('R\$ ${precos[servico]?.toStringAsFixed(2)}'),
                    value: servico,
                    groupValue: servicoSelecionado,
                    onChanged: (value) =>
                        setState(() => servicoSelecionado = value),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _confirmarAgendamento,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Confirmar Agendamento',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
