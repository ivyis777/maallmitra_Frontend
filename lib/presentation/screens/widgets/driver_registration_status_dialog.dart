
import 'package:flutter/material.dart';

class DriverRegistrationStatusDialog {
  static Future<void> show({
    required BuildContext context,
    required String status,
    String? rejectionReason,
    Future<Map<String, dynamic>?> Function()? onCheckStatus,
    String Function()? getStatusError,
    VoidCallback? onLogin,
    VoidCallback? onRegisterAgain,
  }) async {
    if (!context.mounted) return;
    var currentStatus = status.toLowerCase().trim();
    String? currentReason = rejectionReason;
    var checking = false;
    String? checkError;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) {
          final approved = currentStatus == 'approved';
          final rejected = currentStatus == 'rejected';
          final pending = currentStatus == 'pending';
          final color = approved ? Colors.green : rejected ? Colors.red : const Color(0xFFFF9800);
          final statusIcon = approved ? Icons.check_circle : rejected ? Icons.cancel : Icons.hourglass_top_rounded;
          final title = approved ? 'Registration Approved!' : rejected ? 'Registration Rejected' : 'Registration Pending';
          final message = approved
              ? 'Congratulations! Your driver registration has been approved by the admin.'
              : rejected
                  ? 'Your driver registration has been rejected.'
                  : 'Your registration was submitted successfully. Please wait for admin approval.';
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            content: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 92, height: 92,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(statusIcon, color: color, size: 64),
                ),
                const SizedBox(height: 20),
                Text(title, textAlign: TextAlign.center,
                    style: TextStyle(color: color, fontSize: 21, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF444444), fontSize: 14, height: 1.5)),
                if (rejected && (currentReason?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade100)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Reason for rejection',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      const SizedBox(height: 8),
                      Text(currentReason!, style: const TextStyle(fontSize: 14, height: 1.4)),
                    ]),
                  ),
                ],
                if (checkError != null) ...[
                  const SizedBox(height: 12),
                  Text(checkError!, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: checking ? null : () async {
                      if (pending && onCheckStatus != null) {
                        update(() { checking = true; checkError = null; });
                        try {
                          final data = await onCheckStatus();
                          if (!dialogContext.mounted) return;
                          if (data == null) {
                            update(() => checkError = getStatusError?.call() ?? 'Could not check status. Please try again.');
                          } else {
                            final next = data['status']?.toString().toLowerCase().trim();
                            if (next != 'pending' && next != 'approved' && next != 'rejected') {
                              update(() => checkError = 'Unknown registration status received.');
                            } else {
                              update(() {
                                currentStatus = next!;
                                currentReason = data['rejection_reason']?.toString();
                              });
                            }
                          }
                        } catch (e) {
                          if (dialogContext.mounted) update(() => checkError = e.toString());
                        } finally {
                          if (dialogContext.mounted) update(() => checking = false);
                        }
                      // } else {
                      //   Navigator.of(dialogContext).pop();
                      //   if (approved) onLogin?.call();
                      //   if (rejected) onRegisterAgain?.call();
                      // }
                      } else {
  Navigator.of(dialogContext, rootNavigator: true).pop();

  if (approved) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onLogin?.call();
    });
  } else if (rejected) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRegisterAgain?.call();
    });
  }
}

                    },
                    child: checking
                        ? const SizedBox(width: 22, height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(pending ? 'Check Status' : approved ? 'Login' : rejected ? 'Register Again' : 'OK',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (pending) ...[
                  const SizedBox(height: 8),
                  TextButton(onPressed: checking ? null : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Close')),
                ],
              ]),
            ),
          );
        },
      ),
    );
  }
}

