import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/chat_message.dart';
import '../providers/obd2_provider.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../widgets/typing_indicator.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  State<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  String _buildVehicleContext(Obd2Provider provider) {
    final buf = StringBuffer();
    buf.writeln('VIN: ${provider.vin}');
    buf.writeln('Protocolo: ${provider.protocol}');
    buf.writeln('ECUs: ${provider.ecuCount}');
    buf.writeln('Parámetros:');
    for (final p in provider.liveParams) {
      buf.writeln('  ${p.label}: ${p.value} ${p.unit}');
    }
    if (provider.dtcCodes.isNotEmpty) {
      buf.writeln('DTCs activos:');
      for (final dtc in provider.dtcCodes) {
        buf.writeln('  ${dtc.code}: ${dtc.description}');
      }
    }
    return buf.toString();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<Obd2Provider>();

    _controller.clear();
    setState(() {
      _messages.add(
        ChatMessage(text: text, role: ChatRole.user, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    // Mock mode: provide simulated responses
    if (provider.useMockData && !provider.isGeminiConfigured) {
      final l = AppLocalizations.of(context);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      final mockResponses = _getMockResponses(l);
      final response = mockResponses[Random().nextInt(mockResponses.length)];
      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            role: ChatRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
      return;
    }

    if (!provider.isGeminiConfigured) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: AppLocalizations.of(context).chatAiDemoReply,
            role: ChatRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
      return;
    }

    try {
      final history = _messages
          .where((m) => m != _messages.last)
          .map(
            (m) => {
              'role': m.role == ChatRole.user ? 'user' : 'model',
              'text': m.text,
            },
          )
          .toList();

      final response = await provider.geminiService!.chat(
        history: history,
        userMessage: text,
        vehicleContext: _buildVehicleContext(provider),
      );

      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            role: ChatRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
      });
    } on GeminiException catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Error: ${e.message}',
            role: ChatRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Error: $e',
            role: ChatRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  List<String> _getMockResponses(AppLocalizations l) {
    if (l.locale == 'es') {
      return const [
        'Basándome en los datos del vehículo, el código P0301 indica un fallo de encendido en el cilindro 1. '
            'Las causas más comunes son bujías desgastadas, bobinas de encendido defectuosas o inyectores obstruidos. '
            'Recomiendo revisar las bujías primero, ya que es la solución más económica.',
        'La temperatura del motor se encuentra en rango normal (92°C). '
            'El código P0420 sugiere que la eficiencia del catalizador está por debajo del umbral. '
            'Esto puede deberse a un catalizador desgastado o sensores de oxígeno deteriorados.',
        'El código P0171 indica mezcla pobre en el banco 1. '
            'Verifica posibles fugas de vacío, el estado del filtro de aire y el sensor MAF. '
            'Una limpieza del sensor MAF con spray especializado suele resolver este problema.',
        'Los parámetros del motor se ven estables. El RPM en ralentí está dentro del rango normal. '
            'La presión del múltiple de admisión y la carga del motor son consistentes. '
            'Te sugiero atender los códigos de falla activos para mantener el rendimiento óptimo.',
      ];
    }
    return const [
      'Based on the vehicle data, code P0301 indicates a misfire in cylinder 1. '
          'The most common causes are worn spark plugs, faulty ignition coils, or clogged injectors. '
          'I recommend checking the spark plugs first, as it\'s the most cost-effective fix.',
      'Engine temperature is within normal range (92°C). '
          'Code P0420 suggests catalyst efficiency is below threshold. '
          'This could be due to a worn catalytic converter or deteriorated oxygen sensors.',
      'Code P0171 indicates a lean mixture on bank 1. '
          'Check for vacuum leaks, air filter condition, and the MAF sensor. '
          'Cleaning the MAF sensor with specialized spray often resolves this issue.',
      'Engine parameters look stable. Idle RPM is within normal range. '
          'Intake manifold pressure and engine load are consistent. '
          'I suggest addressing the active fault codes to maintain optimal performance.',
    ];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.chatAiTitle)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Text(
                          l.chatAiHint,
                          style: GoogleFonts.inter(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) => _buildMessage(_messages[i]),
                      ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TypingIndicator(label: l.chatAiTyping),
                ),
              _buildInput(l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage msg) {
    final isUser = msg.role == ChatRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppTheme.primary.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInput(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: l.chatAiPlaceholder,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              style: GoogleFonts.inter(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isLoading ? null : _sendMessage,
            icon: const Icon(Icons.send_rounded),
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}
