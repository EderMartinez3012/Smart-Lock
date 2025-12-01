import 'package:flutter/material.dart';

// Widget para estado de conexión
class ConnectionStatus extends StatelessWidget {
  final bool isConnected;
  final String? customText;

  const ConnectionStatus({
    super.key,
    this.isConnected = true,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (isConnected ? Colors.green : Colors.red).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isConnected ? Colors.green : Colors.red).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isConnected ? Colors.green : Colors.red).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            customText ?? (isConnected ? 'Conectado' : 'Desconectado'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
