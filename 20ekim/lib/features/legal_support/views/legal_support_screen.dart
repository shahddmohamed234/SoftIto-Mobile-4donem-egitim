import 'package:flutter/material.dart';
import '../controllers/legal_support_controller.dart';
import '../models/legal_support_model.dart';
import '../widgets/legal_request_card.dart';
import '../widgets/legal_request_dialog.dart';

class LegalSupportScreen extends StatelessWidget {
  final LegalSupportController controller;

  const LegalSupportScreen({super.key, required this.controller});

  void _openRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LegalRequestDialog(
        onCreated: (newReq) => controller.addRequest(newReq),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<LegalRequest>>(
        valueListenable: controller.requests,
        builder: (context, requests, _) {
          if (requests.isEmpty) {
            return const Center(child: Text('Henüz hukuki bir talep bulunmuyor.'));
          }
          return _buildRequestList(context, requests);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openRequestDialog(context),
        icon: const Icon(Icons.add_moderator),
        label: const Text('Hukuki Destek İste'),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, List<LegalRequest> requests) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return LegalRequestCard(
          request: req,
          onResolve: () => controller.resolveRequest(req.id),
        );
      },
    );
  }
}
