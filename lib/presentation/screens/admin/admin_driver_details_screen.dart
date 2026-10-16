
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../data/controllers/admin_driver_controller.dart';
// import '../../../data/models/driver_details_model.dart';
// import '../../../core/constants/app url.dart';

// class AdminDriverDetailsScreen extends StatefulWidget {
//   final int registrationId;

//   const AdminDriverDetailsScreen({
//     super.key,
//     required this.registrationId,
//   });

//   @override
//   State<AdminDriverDetailsScreen> createState() =>
//       _AdminDriverDetailsScreenState();
// }

// class _AdminDriverDetailsScreenState
//     extends State<AdminDriverDetailsScreen> {
//   static const Color orange = Color(0xFFFF9800);
//   static const Color black = Color(0xFF171717);

//   late final AdminDriverController controller;

//   final TextEditingController reasonController =
//       TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     controller = Get.isRegistered<AdminDriverController>()
//         ? Get.find<AdminDriverController>()
//         : Get.put(AdminDriverController());

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchDriverDetails(widget.registrationId);
//     });
//   }

//   @override
//   void dispose() {
//     reasonController.dispose();
//     super.dispose();
//   }

//   String _mediaUrl(String path) {
//     if (path.isEmpty) return '';

//     if (path.startsWith('https://') ||
//         path.startsWith('http://')) {
//       return path;
//     }

//     final serverBaseUrl = AppUrl.baseUrl.replaceFirst(
//       RegExp(r'/user/?$'),
//       '',
//     );

//     final normalizedPath =
//         path.startsWith('/') ? path : '/$path';

//     return '$serverBaseUrl$normalizedPath';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       appBar: AppBar(
//         backgroundColor: orange,
//         foregroundColor: black,
//         elevation: 0,
//         title: const Text(
//           'Driver Details',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isDetailsLoading.value &&
//             controller.driverDetails.value == null) {
//           return const Center(
//             child: CircularProgressIndicator(color: orange),
//           );
//         }

//         if (controller.driverDetails.value == null) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     controller.detailsError.value.isEmpty
//                         ? 'Unable to load driver details.'
//                         : controller.detailsError.value,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => controller.fetchDriverDetails(
//                       widget.registrationId,
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         final driver = controller.driverDetails.value!.data;

//         return RefreshIndicator(
//           color: orange,
//           onRefresh: () =>
//               controller.fetchDriverDetails(widget.registrationId),
//           child: ListView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(16),
//             children: [
//               _profileCard(driver),
//               const SizedBox(height: 16),

//               _section('Personal Details', [
//                 _detail('Name', driver.name),
//                 _detail('Age', '${driver.age}'),
//                 _detail('Gender', driver.gender),
//                 _detail('Mobile Number', driver.mobileNumber),
//                 _detail('Aadhaar Number', driver.aadhaarNumber),
//               ]),

//               _section('Company Details', [
//                 _detail('Company Type', driver.companyType),
//                 _detail('Company Name', driver.companyName),
//               ]),

//               _section('Driving Licence Details', [
//                 _detail(
//                   'Licence Number',
//                   driver.drivingLicenceNumber,
//                 ),
//                 _detail('DL Type', driver.dlType),
//                 _detail('Issued Date', driver.dlIssuedDate),
//                 _detail('Expiry Date', driver.dlExpiredDate),
//               ]),

//               _section('Addresses', [
//                 _detail(
//                   'Permanent Address',
//                   driver.permanentAddress,
//                 ),
//                 _detail(
//                   'Current Address',
//                   driver.currentAddress,
//                 ),
//               ]),

//               _documentSection(driver),

//               if (driver.status.toLowerCase() == 'rejected')
//                 _section('Rejection Details', [
//                   _detail(
//                     'Reason',
//                     driver.rejectionReason ?? 'Not provided',
//                   ),
//                   _detail(
//                     'Reviewed At',
//                     driver.reviewedAt ?? 'Not available',
//                   ),
//                 ]),

//               const SizedBox(height: 12),

//               if (driver.status.toLowerCase() == 'pending')
//                 _actionButtons(driver),

//               if (driver.status.toLowerCase() != 'pending')
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'This registration is ${driver.status}. '
//                     'No further action is available here.',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 24),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _profileCard(DriverDetails driver) {
//     return Card(
//       color: Colors.white,
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(40),
//               child: driver.photo.isEmpty
//                   ? _photoPlaceholder()
//                   : Image.network(
//                       _mediaUrl(driver.photo),
//                       width: 76,
//                       height: 76,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) =>
//                           _photoPlaceholder(),
//                     ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     driver.name,
//                     style: const TextStyle(
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold,
//                       color: black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     driver.companyName,
//                     style: const TextStyle(color: Colors.black54),
//                   ),
//                   const SizedBox(height: 6),
//                   _statusChip(driver.status),
//                   const SizedBox(height: 4),
//                   Text('Registration ID: ${driver.id}'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _photoPlaceholder() {
//     return Container(
//       width: 76,
//       height: 76,
//       color: orange.withValues(alpha: 0.15),
//       child: const Icon(
//         Icons.person,
//         size: 42,
//         color: black,
//       ),
//     );
//   }

//   Widget _section(String title, List<Widget> children) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       color: Colors.white,
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: black,
//               ),
//             ),
//             const Divider(height: 22),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _detail(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 5,
//             child: Text(
//               label,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             flex: 6,
//             child: Text(
//               value.isEmpty ? 'Not available' : value,
//               textAlign: TextAlign.end,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _documentSection(DriverDetails driver) {
//     final documents = <MapEntry<String, String>>[
//       MapEntry('Driver Photo', driver.photo),
//       MapEntry('Aadhaar Front', driver.aadhaarFront),
//       MapEntry('Aadhaar Back', driver.aadhaarBack),
//       MapEntry('DL Front', driver.dlFront),
//       MapEntry('DL Back', driver.dlBack),
//       MapEntry('Medical Certificate', driver.medicalCertificate),
//       MapEntry(
//         'Police Verification',
//         driver.policeVerificationCertificate,
//       ),
//     ];

//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       color: Colors.white,
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Driver Documents',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: black,
//               ),
//             ),
//             const Divider(height: 22),
//             ...documents.map((document) {
//               final label = document.key;
//               final path = document.value;

//               return ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: const Icon(
//                   Icons.description_outlined,
//                   color: orange,
//                   size: 30,
//                 ),
//                 title: Text(label),
//                 subtitle: Text(
//                   path.isEmpty
//                       ? 'Document unavailable'
//                       : path.split('/').last,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 trailing: path.isEmpty
//                     ? const Icon(
//                         Icons.remove_circle_outline,
//                         color: Colors.grey,
//                       )
//                     : const Icon(
//                         Icons.open_in_new,
//                         color: orange,
//                       ),
//                 onTap: path.isEmpty
//                     ? null
//                     : () => _showDocument(label, path),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDocument(String title, String path) {
//     final url = _mediaUrl(path);
//     final lowerPath = path.toLowerCase();

//     final isImage = lowerPath.endsWith('.jpg') ||
//         lowerPath.endsWith('.jpeg') ||
//         lowerPath.endsWith('.png') ||
//         lowerPath.endsWith('.webp');

//     showDialog<void>(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: Text(title),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: isImage
//               ? InteractiveViewer(
//                   child: Image.network(
//                     url,
//                     fit: BoxFit.contain,
//                     errorBuilder: (_, __, ___) => const Text(
//                       'Unable to load this image. Check the server '
//                       'address and media permissions.',
//                     ),
//                   ),
//                 )
//               : SelectableText(
//                   'Document URL:\n$url\n\n'
//                   'This file is not an image. To preview PDFs, '
//                   'add a PDF viewer package or open the URL '
//                   'using a URL-launching package.',
//                 ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statusChip(String status) {
//     final normalized = status.toLowerCase();

//     final color = normalized == 'approved'
//         ? Colors.green
//         : normalized == 'rejected'
//             ? Colors.red
//             : orange;

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 5,
//       ),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.13),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status.isEmpty ? 'Unknown' : status.toUpperCase(),
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }

//   Widget _actionButtons(DriverDetails driver) {
//     return Obx(() {
//       final busy = controller.isActionLoading.value;

//       return Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: busy ? null : _approve,
//               icon: const Icon(Icons.check_circle_outline),
//               label: Text(
//                 busy ? 'Please wait...' : 'Approve',
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: busy ? null : _showRejectDialog,
//               icon: const Icon(Icons.cancel_outlined),
//               label: const Text('Reject'),
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   Future<void> _approve() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Approve Driver'),
//         content: const Text(
//           'Are you sure you want to approve this driver registration?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () => Navigator.pop(dialogContext, true),
//             child: const Text('Approve'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true || !mounted) return;

//     final success = await controller.approveDriver(
//       widget.registrationId,
//     );

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           controller.actionMessage.value.isEmpty
//               ? (success
//                   ? 'Driver approved successfully'
//                   : 'Unable to approve driver')
//               : controller.actionMessage.value,
//         ),
//         backgroundColor: success ? Colors.green : Colors.red,
//       ),
//     );
//   }

//   Future<void> _showRejectDialog() async {
//     reasonController.clear();

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Reject Driver'),
//         content: TextField(
//           controller: reasonController,
//           maxLines: 4,
//           maxLength: 500,
//           decoration: const InputDecoration(
//             labelText: 'Rejection reason',
//             hintText: 'Explain why this driver is rejected',
//             border: OutlineInputBorder(),
//             alignLabelWithHint: true,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () {
//               if (reasonController.text.trim().isEmpty) {
//                 ScaffoldMessenger.of(dialogContext).showSnackBar(
//                   const SnackBar(
//                     content: Text(
//                       'Please enter a rejection reason',
//                     ),
//                   ),
//                 );
//                 return;
//               }

//               Navigator.pop(dialogContext, true);
//             },
//             child: const Text('Reject'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true || !mounted) return;

//     final success = await controller.rejectDriver(
//       registrationId: widget.registrationId,
//       rejectionReason: reasonController.text,
//     );

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           controller.actionMessage.value.isEmpty
//               ? (success
//                   ? 'Driver rejected successfully'
//                   : 'Unable to reject driver')
//               : controller.actionMessage.value,
//         ),
//         backgroundColor: success ? Colors.green : Colors.red,
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controllers/admin_driver_controller.dart';
import '../../../data/models/driver_details_model.dart';
import '../../../core/constants/app url.dart';

class AdminDriverDetailsScreen extends StatefulWidget {
  final int registrationId;

  const AdminDriverDetailsScreen({
    super.key,
    required this.registrationId,
  });

  @override
  State<AdminDriverDetailsScreen> createState() =>
      _AdminDriverDetailsScreenState();
}

class _AdminDriverDetailsScreenState
    extends State<AdminDriverDetailsScreen> {
  static const Color orange = Color(0xFFFF9800);
  static const Color black = Color(0xFF171717);

  late final AdminDriverController controller;

  final TextEditingController reasonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminDriverController>()
        ? Get.find<AdminDriverController>()
        : Get.put(AdminDriverController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDriverAndCompanyDetails();
    });
  }

  Future<void> _loadDriverAndCompanyDetails() async {
    final success = await controller.fetchDriverDetails(
      widget.registrationId,
    );

    if (!success || !mounted) return;

    final driver = controller.driverDetails.value?.data;
    final companyId = int.tryParse(driver?.companyId ?? '');

    if (companyId != null && companyId > 0) {
      await controller.fetchCompanyDetails(companyId);
    }
  }

  Future<void> _refreshDetails() async {
    await _loadDriverAndCompanyDetails();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  String _mediaUrl(String path) {
    if (path.isEmpty) return '';

    final serverBaseUrl = AppUrl.baseUrl.replaceFirst(
      RegExp(r'/user/?$'),
      '',
    );

    if (path.startsWith('https://') ||
        path.startsWith('http://')) {
      final mediaUri = Uri.tryParse(path);
      final baseUri = Uri.tryParse(serverBaseUrl);

      // URLs generated by a local Django server may contain 127.0.0.1,
      // which is not reachable from a physical phone. Replace only that
      // host with the host configured in AppUrl.baseUrl.
      if (mediaUri != null &&
          baseUri != null &&
          (mediaUri.host == '127.0.0.1' ||
              mediaUri.host == 'localhost')) {
        return mediaUri.replace(
          host: baseUri.host,
          port: baseUri.hasPort ? baseUri.port : mediaUri.port,
          scheme: baseUri.scheme,
        ).toString();
      }

      return path;
    }

    final normalizedPath =
        path.startsWith('/') ? path : '/$path';

    return '$serverBaseUrl$normalizedPath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: orange,
        foregroundColor: black,
        elevation: 0,
        title: const Text(
          'Driver Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isDetailsLoading.value &&
            controller.driverDetails.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        if (controller.driverDetails.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.detailsError.value.isEmpty
                        ? 'Unable to load driver details.'
                        : controller.detailsError.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchDriverDetails(
                      widget.registrationId,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final driver = controller.driverDetails.value!.data;

        return RefreshIndicator(
          color: orange,
          onRefresh: _refreshDetails,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _profileCard(driver),
              const SizedBox(height: 16),

              _section('Personal Details', [
                _detail('Name', driver.name),
                _detail('Age', '${driver.age}'),
                _detail('Gender', driver.gender),
                _detail('Mobile Number', driver.mobileNumber),
                _detail('Aadhaar Number', driver.aadhaarNumber),
              ]),

              Obx(() {
                final company = controller.companyDetails.value;

                if (controller.isCompanyDetailsLoading.value &&
                    company == null) {
                  return _section('Company Details', [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(color: orange),
                      ),
                    ),
                  ]);
                }

                if (company == null) {
                  return _section('Company Details', [
                    _detail('Company Type', driver.companyType),
                    _detail('Company Name', driver.companyName),
                    if (controller.companyDetailsError.value.isNotEmpty)
                      _detail(
                        'Company Details Error',
                        controller.companyDetailsError.value,
                      ),
                  ]);
                }

                return _section('Company Details', [
                  _detail('Company Type', driver.companyType),
                  _detail('Company ID', company.company_Id),
                  _detail('Company Unique ID', company.company_uniqueid),
                  _detail('Company Name', company.companyName),
                  _detail('GST Number', company.gstNumber),
                  _detail('Email', company.email),
                  _detail('Phone Number', company.phoneNumber),
                  _detail('Contact Person Number', company.companyPersonNumber),
                  _detail('Address', company.address),
                  _detail('City', company.city),
                  _detail('State', company.state),
                  _detail('Pincode', company.pincode),
                  _detail('Country', company.country),
                  _detail('Document Type', company.documentType),
                  _detail('Created At', company.createdAt),
                  _detail('Updated At', company.updatedAt),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.description_outlined,
                      color: orange,
                      size: 30,
                    ),
                    title: const Text('Company Document'),
                    subtitle: Text(
                      company.document.isEmpty
                          ? 'Document unavailable'
                          : company.document.split('/').last,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: company.document.isEmpty
                        ? const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.grey,
                          )
                        : const Icon(Icons.open_in_new, color: orange),
                    onTap: company.document.isEmpty
                        ? null
                        : () => _showDocument(
                              'Company Document',
                              company.document,
                            ),
                  ),
                ]);
              }),

              _section('Driving Licence Details', [
                _detail(
                  'Licence Number',
                  driver.drivingLicenceNumber,
                ),
                _detail('DL Type', driver.dlType),
                _detail('Issued Date', driver.dlIssuedDate),
                _detail('Expiry Date', driver.dlExpiredDate),
              ]),

              _section('Addresses', [
                _detail(
                  'Permanent Address',
                  driver.permanentAddress,
                ),
                _detail(
                  'Current Address',
                  driver.currentAddress,
                ),
              ]),

              _documentSection(driver),

              if (driver.status.toLowerCase() == 'rejected')
                _section('Rejection Details', [
                  _detail(
                    'Reason',
                    driver.rejectionReason ?? 'Not provided',
                  ),
                  _detail(
                    'Reviewed At',
                    driver.reviewedAt ?? 'Not available',
                  ),
                ]),

              const SizedBox(height: 12),

              if (driver.status.toLowerCase() == 'pending')
                _actionButtons(driver),

              if (driver.status.toLowerCase() != 'pending')
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'This registration is ${driver.status}. '
                    'No further action is available here.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _profileCard(DriverDetails driver) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: driver.photo.isEmpty
                  ? _photoPlaceholder()
                  : Image.network(
                      _mediaUrl(driver.photo),
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _photoPlaceholder(),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.companyName,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  _statusChip(driver.status),
                  const SizedBox(height: 4),
                  Text('Registration ID: ${driver.id}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      width: 76,
      height: 76,
      color: orange.withValues(alpha: 0.15),
      child: const Icon(
        Icons.person,
        size: 42,
        color: black,
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            const Divider(height: 22),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? 'Not available' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentSection(DriverDetails driver) {
    final documents = <MapEntry<String, String>>[
      MapEntry('Driver Photo', driver.photo),
      MapEntry('Aadhaar Front', driver.aadhaarFront),
      MapEntry('Aadhaar Back', driver.aadhaarBack),
      MapEntry('DL Front', driver.dlFront),
      MapEntry('DL Back', driver.dlBack),
      MapEntry('Medical Certificate', driver.medicalCertificate),
      MapEntry(
        'Police Verification',
        driver.policeVerificationCertificate,
      ),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Documents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),
            const Divider(height: 22),
            ...documents.map((document) {
              final label = document.key;
              final path = document.value;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.description_outlined,
                  color: orange,
                  size: 30,
                ),
                title: Text(label),
                subtitle: Text(
                  path.isEmpty
                      ? 'Document unavailable'
                      : path.split('/').last,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: path.isEmpty
                    ? const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.open_in_new,
                        color: orange,
                      ),
                onTap: path.isEmpty
                    ? null
                    : () => _showDocument(label, path),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDocument(String title, String path) {
    final url = _mediaUrl(path);
    final lowerPath = path.toLowerCase();

    final isImage = lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.webp');

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: isImage
              ? InteractiveViewer(
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text(
                      'Unable to load this image. Check the server '
                      'address and media permissions.',
                    ),
                  ),
                )
              : SelectableText(
                  'Document URL:\n$url\n\n'
                  'This file is not an image. To preview PDFs, '
                  'add a PDF viewer package or open the URL '
                  'using a URL-launching package.',
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final normalized = status.toLowerCase();

    final color = normalized == 'approved'
        ? Colors.green
        : normalized == 'rejected'
            ? Colors.red
            : orange;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty ? 'Unknown' : status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _actionButtons(DriverDetails driver) {
    return Obx(() {
      final busy = controller.isActionLoading.value;

      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: busy ? null : _approve,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                busy ? 'Please wait...' : 'Approve',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: busy ? null : _showRejectDialog,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Reject'),
            ),
          ),
        ],
      );
    });
  }

  Future<void> _approve() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Approve Driver'),
        content: const Text(
          'Are you sure you want to approve this driver registration?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await controller.approveDriver(
      widget.registrationId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          controller.actionMessage.value.isEmpty
              ? (success
                  ? 'Driver approved successfully'
                  : 'Unable to approve driver')
              : controller.actionMessage.value,
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _showRejectDialog() async {
    reasonController.clear();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject Driver'),
        content: TextField(
          controller: reasonController,
          maxLines: 4,
          maxLength: 500,
          decoration: const InputDecoration(
            labelText: 'Rejection reason',
            hintText: 'Explain why this driver is rejected',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please enter a rejection reason',
                    ),
                  ),
                );
                return;
              }

              Navigator.pop(dialogContext, true);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await controller.rejectDriver(
      registrationId: widget.registrationId,
      rejectionReason: reasonController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          controller.actionMessage.value.isEmpty
              ? (success
                  ? 'Driver rejected successfully'
                  : 'Unable to reject driver')
              : controller.actionMessage.value,
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}


