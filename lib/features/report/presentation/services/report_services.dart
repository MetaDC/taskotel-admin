// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskoteladmin/features/report/presentation/cubit/report_cubit.dart';
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

// class ReportExportService {
//   // Global key for capturing widget
//   static final GlobalKey screenshotKey = GlobalKey();

//   // Request storage permission (only for mobile)
//   static Future<bool> _requestStoragePermission() async {
//     if (kIsWeb) return true;

//     if (Platform.isAndroid) {
//       final status = await Permission.storage.request();
//       if (status.isDenied) {
//         final manageStatus = await Permission.manageExternalStorage.request();
//         return manageStatus.isGranted;
//       }
//       return status.isGranted;
//     }
//     return true;
//   }

//   // Capture widget as image using RepaintBoundary
//   static Future<Uint8List?> _captureWidget() async {
//     try {
//       await Future.delayed(Duration(milliseconds: 100));

//       final boundary =
//           screenshotKey.currentContext?.findRenderObject()
//               as RenderRepaintBoundary?;
//       if (boundary == null) {
//         print('Boundary is null');
//         return null;
//       }

//       final image = await boundary.toImage(pixelRatio: 2.0);
//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       return byteData?.buffer.asUint8List();
//     } catch (e) {
//       print('Error capturing widget: $e');
//       return null;
//     }
//   }

//   // Save file for mobile platforms
//   static Future<String?> _saveMobileFile(
//     Uint8List bytes,
//     String fileName,
//   ) async {
//     try {
//       final directory = Platform.isAndroid
//           ? Directory('/storage/emulated/0/Download')
//           : await getApplicationDocumentsDirectory();

//       final filePath = '${directory.path}/$fileName';
//       final file = File(filePath);
//       await file.writeAsBytes(bytes);
//       return filePath;
//     } catch (e) {
//       print('Error saving mobile file: $e');
//       return null;
//     }
//   }

//   // Download file for web
//   static void _downloadWebFile(Uint8List bytes, String fileName) {
//     final blob = html.Blob([bytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute('download', fileName)
//       ..click();
//     html.Url.revokeObjectUrl(url);
//   }

//   // Export as PNG
//   static Future<void> exportAsPNG(
//     BuildContext context,
//     BuildContext dialogContext,
//   ) async {
//     final cubit = context.read<ReportCubit>();

//     try {
//       // Set loading state
//       cubit.setExportLoading(true);

//       // Allow UI to update
//       await Future.delayed(const Duration(milliseconds: 100));

//       // Request permission (only for mobile)
//       if (!kIsWeb) {
//         final hasPermission = await _requestStoragePermission();
//         if (!hasPermission) {
//           cubit.setExportLoading(false);
//           cubit.setExportMessage('Storage permission denied');
//           await Future.delayed(const Duration(seconds: 2));
//           if (dialogContext.mounted) Navigator.pop(dialogContext);
//           return;
//         }
//       }

//       // Capture screenshot with delay to allow UI update
//       await Future.delayed(const Duration(milliseconds: 200));
//       final image = await _captureWidget();
//       if (image == null) {
//         cubit.setExportLoading(false);
//         cubit.setExportMessage('Failed to capture report');
//         await Future.delayed(const Duration(seconds: 2));
//         if (dialogContext.mounted) Navigator.pop(dialogContext);
//         return;
//       }

//       // Generate filename
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final fileName = 'report_$timestamp.png';

//       // Process file operations in background
//       await Future.delayed(const Duration(milliseconds: 100));

//       // Save or download based on platform
//       if (kIsWeb) {
//         _downloadWebFile(image, fileName);
//         cubit.setExportLoading(false);
//         cubit.setExportMessage('Report downloaded: $fileName');
//       } else {
//         final filePath = await _saveMobileFile(image, fileName);
//         cubit.setExportLoading(false);
//         if (filePath != null) {
//           cubit.setExportMessage('Report exported to: $filePath');
//         } else {
//           cubit.setExportMessage('Failed to save report');
//         }
//       }

//       // Wait a bit to show success message
//       await Future.delayed(const Duration(seconds: 2));

//       // Close dialog after export is complete
//       if (dialogContext.mounted) {
//         Navigator.pop(dialogContext);
//       }
//     } catch (e) {
//       cubit.setExportLoading(false);
//       cubit.setExportMessage('Export failed: ${e.toString()}');
//       await Future.delayed(const Duration(seconds: 2));
//       if (dialogContext.mounted) Navigator.pop(dialogContext);
//     }
//   }

//   // Export as PDF
//   static Future<void> exportAsPDF(
//     BuildContext context,
//     BuildContext dialogContext,
//   ) async {
//     final cubit = context.read<ReportCubit>();

//     try {
//       // Get state from cubit
//       final state = cubit.state;

//       // Set loading state
//       cubit.setExportLoading(true);

//       // Allow UI to update
//       await Future.delayed(const Duration(milliseconds: 100));

//       final pdf = pw.Document();

//       // Capture screenshot for PDF with delay
//       await Future.delayed(const Duration(milliseconds: 200));
//       final image = await _captureWidget();
//       if (image == null) {
//         cubit.setExportLoading(false);
//         cubit.setExportMessage('Failed to capture report');
//         await Future.delayed(const Duration(seconds: 2));
//         if (dialogContext.mounted) Navigator.pop(dialogContext);
//         return;
//       }

//       // Allow UI to update before heavy processing
//       await Future.delayed(const Duration(milliseconds: 100));
//       final pdfImage = pw.MemoryImage(image);

//       pdf.addPage(
//         pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           margin: pw.EdgeInsets.all(20),
//           build: (pw.Context context) {
//             return [
//               // Header
//               pw.Header(
//                 level: 0,
//                 child: pw.Text(
//                   'Reports & Analytics',
//                   style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 'Generated on: ${DateTime.now().toString().substring(0, 16)}',
//                 style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
//               ),
//               pw.Text(
//                 'Year: ${state.selectedYear} | Filter: ${state.timeFilter.name}',
//                 style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
//               ),
//               pw.SizedBox(height: 20),

//               // Key Metrics Section
//               pw.Text(
//                 'Key Metrics',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Table(
//                 border: pw.TableBorder.all(color: PdfColors.grey300),
//                 children: [
//                   _buildPdfTableRow(
//                     'Total Revenue (YTD)',
//                     '\$${state.totalRevenue.toStringAsFixed(2)}',
//                   ),
//                   _buildPdfTableRow(
//                     'Active Subscribers',
//                     '${state.activeSubscribers}',
//                   ),
//                   _buildPdfTableRow(
//                     'Total Subscribers',
//                     '${state.totalSubscribers}',
//                   ),
//                   _buildPdfTableRow(
//                     'Churn Rate',
//                     '${state.churnRate.toStringAsFixed(1)}%',
//                   ),
//                   _buildPdfTableRow(
//                     'Avg. Revenue Per User',
//                     '\$${state.avgRevenuePerUser.toStringAsFixed(2)}',
//                   ),
//                   _buildPdfTableRow(
//                     'Successful Transactions',
//                     '${state.successfulTransactions}',
//                   ),
//                   _buildPdfTableRow(
//                     'Failed Transactions',
//                     '${state.failedTransactions}',
//                   ),
//                   _buildPdfTableRow(
//                     'Pending Transactions',
//                     '${state.pendingTransactions}',
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 20),

//               // Revenue by Month
//               if (state.revenueByMonth.isNotEmpty) ...[
//                 pw.Text(
//                   'Monthly Revenue',
//                   style: pw.TextStyle(
//                     fontSize: 18,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Table(
//                   border: pw.TableBorder.all(color: PdfColors.grey300),
//                   children: [
//                     pw.TableRow(
//                       decoration: pw.BoxDecoration(color: PdfColors.grey200),
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(8),
//                           child: pw.Text(
//                             'Month',
//                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(8),
//                           child: pw.Text(
//                             'Revenue',
//                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...state.revenueByMonth.map(
//                       (data) => pw.TableRow(
//                         children: [
//                           pw.Padding(
//                             padding: pw.EdgeInsets.all(8),
//                             child: pw.Text(data['month']),
//                           ),
//                           pw.Padding(
//                             padding: pw.EdgeInsets.all(8),
//                             child: pw.Text(
//                               '\$${data['revenue'].toStringAsFixed(2)}',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 20),
//               ],

//               // Plan Distribution
//               if (state.planDistribution.isNotEmpty) ...[
//                 pw.Text(
//                   'Plan Distribution',
//                   style: pw.TextStyle(
//                     fontSize: 18,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Table(
//                   border: pw.TableBorder.all(color: PdfColors.grey300),
//                   children: [
//                     pw.TableRow(
//                       decoration: pw.BoxDecoration(color: PdfColors.grey200),
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(8),
//                           child: pw.Text(
//                             'Plan',
//                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(8),
//                           child: pw.Text(
//                             'Subscribers',
//                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(8),
//                           child: pw.Text(
//                             'Revenue',
//                             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...state.planDistribution.entries.map(
//                       (entry) => pw.TableRow(
//                         children: [
//                           pw.Padding(
//                             padding: pw.EdgeInsets.all(8),
//                             child: pw.Text(entry.key),
//                           ),
//                           pw.Padding(
//                             padding: pw.EdgeInsets.all(8),
//                             child: pw.Text('${entry.value}'),
//                           ),
//                           pw.Padding(
//                             padding: pw.EdgeInsets.all(8),
//                             child: pw.Text(
//                               '\$${(state.planRevenue[entry.key] ?? 0).toStringAsFixed(2)}',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 pw.SizedBox(height: 20),
//               ],

//               // Screenshot of charts
//               pw.Text(
//                 'Visual Reports',
//                 style: pw.TextStyle(
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Image(pdfImage, fit: pw.BoxFit.contain),
//             ];
//           },
//         ),
//       );

//       // Request permission (only for mobile)
//       if (!kIsWeb) {
//         final hasPermission = await _requestStoragePermission();
//         if (!hasPermission) {
//           cubit.setExportLoading(false);
//           cubit.setExportMessage('Storage permission denied');
//           await Future.delayed(const Duration(seconds: 2));
//           if (dialogContext.mounted) Navigator.pop(dialogContext);
//           return;
//         }
//       }

//       // Generate PDF bytes with delay to allow UI updates
//       await Future.delayed(const Duration(milliseconds: 100));
//       final pdfBytes = await pdf.save();
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final fileName = 'report_$timestamp.pdf';

//       // Save or download based on platform
//       if (kIsWeb) {
//         _downloadWebFile(pdfBytes, fileName);
//         cubit.setExportLoading(false);
//         cubit.setExportMessage('PDF downloaded: $fileName');
//       } else {
//         final filePath = await _saveMobileFile(pdfBytes, fileName);
//         cubit.setExportLoading(false);
//         if (filePath != null) {
//           cubit.setExportMessage('PDF exported to: $filePath');
//         } else {
//           cubit.setExportMessage('Failed to save PDF');
//         }
//       }

//       // Wait a bit to show success message
//       await Future.delayed(const Duration(seconds: 2));

//       // Close dialog after export is complete
//       if (dialogContext.mounted) {
//         Navigator.pop(dialogContext);
//       }
//     } catch (e) {
//       cubit.setExportLoading(false);
//       cubit.setExportMessage('Export failed: ${e.toString()}');
//       await Future.delayed(const Duration(seconds: 2));
//       if (dialogContext.mounted) Navigator.pop(dialogContext);
//     }
//   }

//   // Export as Excel
//   static Future<void> exportAsExcel(
//     BuildContext context,
//     BuildContext dialogContext,
//   ) async {
//     final cubit = context.read<ReportCubit>();

//     try {
//       // Get state from cubit
//       final state = cubit.state;

//       // Set loading state
//       cubit.setExportLoading(true);

//       // Allow UI to update
//       await Future.delayed(const Duration(milliseconds: 100));

//       final excel = Excel.createExcel();
//       final sheet = excel['Report'];

//       int row = 0;

//       // Title
//       sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
//       var titleCell = sheet.cell(CellIndex.indexByString('A1'));
//       titleCell.value = TextCellValue('Reports & Analytics');
//       titleCell.cellStyle = CellStyle(bold: true, fontSize: 18);

//       // Date and Filter Info
//       row = 1;
//       var dateCell = sheet.cell(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//       );
//       dateCell.value = TextCellValue(
//         'Generated on: ${DateTime.now().toString().substring(0, 16)}',
//       );

//       row++;
//       var filterCell = sheet.cell(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//       );
//       filterCell.value = TextCellValue(
//         'Year: ${state.selectedYear} | Filter: ${state.timeFilter.name}',
//       );

//       // Key Metrics Section
//       row += 2;
//       var metricsHeaderCell = sheet.cell(
//         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//       );
//       metricsHeaderCell.value = TextCellValue('Key Metrics');
//       metricsHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

//       row += 2;
//       _addExcelRow(
//         sheet,
//         row++,
//         'Total Revenue (YTD)',
//         '\$${state.totalRevenue.toStringAsFixed(2)}',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Active Subscribers',
//         '${state.activeSubscribers}',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Total Subscribers',
//         '${state.totalSubscribers}',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Churn Rate',
//         '${state.churnRate.toStringAsFixed(1)}%',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Avg. Revenue Per User',
//         '\$${state.avgRevenuePerUser.toStringAsFixed(2)}',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Successful Transactions',
//         '${state.successfulTransactions}',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Failed Transactions',
//         '${state.failedTransactions}',
//       );
//       _addExcelRow(
//         sheet,
//         row++,
//         'Pending Transactions',
//         '${state.pendingTransactions}',
//       );

//       // Monthly Revenue Section
//       if (state.revenueByMonth.isNotEmpty) {
//         row += 2;
//         var revenueHeaderCell = sheet.cell(
//           CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//         );
//         revenueHeaderCell.value = TextCellValue('Monthly Revenue');
//         revenueHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

//         row += 2;
//         _addExcelRow(sheet, row++, 'Month', 'Revenue', isBold: true);

//         for (final data in state.revenueByMonth) {
//           _addExcelRow(
//             sheet,
//             row++,
//             data['month'],
//             '\$${data['revenue'].toStringAsFixed(2)}',
//           );
//         }
//       }

//       // Plan Distribution Section
//       if (state.planDistribution.isNotEmpty) {
//         row += 2;
//         var planHeaderCell = sheet.cell(
//           CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//         );
//         planHeaderCell.value = TextCellValue('Plan Distribution');
//         planHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

//         row += 2;
//         _addExcelRowThree(
//           sheet,
//           row++,
//           'Plan',
//           'Subscribers',
//           'Revenue',
//           isBold: true,
//         );

//         for (final entry in state.planDistribution.entries) {
//           final revenue = state.planRevenue[entry.key] ?? 0;
//           _addExcelRowThree(
//             sheet,
//             row++,
//             entry.key,
//             '${entry.value}',
//             '\$${revenue.toStringAsFixed(2)}',
//           );
//         }
//       }

//       // Client Acquisition Section
//       if (state.clientAcquisitionByMonth.isNotEmpty) {
//         row += 2;
//         var clientHeaderCell = sheet.cell(
//           CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//         );
//         clientHeaderCell.value = TextCellValue('Client Acquisition');
//         clientHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

//         row += 2;
//         _addExcelRow(sheet, row++, 'Month', 'New Clients', isBold: true);

//         for (final data in state.clientAcquisitionByMonth) {
//           _addExcelRow(sheet, row++, data['month'], '${data['count']}');
//         }
//       }

//       // Churn vs Retention Section
//       if (state.churnVsRetention.isNotEmpty) {
//         row += 2;
//         var churnHeaderCell = sheet.cell(
//           CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//         );
//         churnHeaderCell.value = TextCellValue('Churn vs Retention');
//         churnHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

//         row += 2;
//         _addExcelRowThree(
//           sheet,
//           row++,
//           'Month',
//           'Retained',
//           'Churned',
//           isBold: true,
//         );

//         for (final data in state.churnVsRetention) {
//           _addExcelRowThree(
//             sheet,
//             row++,
//             data['month'],
//             '${data['retained']}',
//             '${data['churned']}',
//           );
//         }
//       }

//       // Request permission (only for mobile)
//       if (!kIsWeb) {
//         final hasPermission = await _requestStoragePermission();
//         if (!hasPermission) {
//           cubit.setExportLoading(false);
//           cubit.setExportMessage('Storage permission denied');
//           await Future.delayed(const Duration(seconds: 2));
//           if (dialogContext.mounted) Navigator.pop(dialogContext);
//           return;
//         }
//       }

//       // Generate Excel bytes with delay to allow UI updates
//       await Future.delayed(const Duration(milliseconds: 100));
//       final excelBytes = excel.encode()!;
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final fileName = 'report_$timestamp.xlsx';

//       // Save or download based on platform
//       if (kIsWeb) {
//         _downloadWebFile(Uint8List.fromList(excelBytes), fileName);
//         cubit.setExportLoading(false);
//         cubit.setExportMessage('Excel downloaded: $fileName');
//       } else {
//         final filePath = await _saveMobileFile(
//           Uint8List.fromList(excelBytes),
//           fileName,
//         );
//         cubit.setExportLoading(false);
//         if (filePath != null) {
//           cubit.setExportMessage('Excel exported to: $filePath');
//         } else {
//           cubit.setExportMessage('Failed to save Excel');
//         }
//       }

//       // Wait a bit to show success message
//       await Future.delayed(const Duration(seconds: 2));

//       // Close dialog after export is complete
//       if (dialogContext.mounted) {
//         Navigator.pop(dialogContext);
//       }
//     } catch (e) {
//       cubit.setExportLoading(false);
//       cubit.setExportMessage('Export failed: ${e.toString()}');
//       await Future.delayed(const Duration(seconds: 2));
//       if (dialogContext.mounted) Navigator.pop(dialogContext);
//     }
//   }

//   // Helper: Add Excel row with two columns
//   static void _addExcelRow(
//     Sheet sheet,
//     int row,
//     String col1,
//     String col2, {
//     bool isBold = false,
//   }) {
//     var cell1 = sheet.cell(
//       CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//     );
//     cell1.value = TextCellValue(col1);
//     if (isBold) cell1.cellStyle = CellStyle(bold: true);

//     var cell2 = sheet.cell(
//       CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row),
//     );
//     cell2.value = TextCellValue(col2);
//     if (isBold) cell2.cellStyle = CellStyle(bold: true);
//   }

//   // Helper: Add Excel row with three columns
//   static void _addExcelRowThree(
//     Sheet sheet,
//     int row,
//     String col1,
//     String col2,
//     String col3, {
//     bool isBold = false,
//   }) {
//     var cell1 = sheet.cell(
//       CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
//     );
//     cell1.value = TextCellValue(col1);
//     if (isBold) cell1.cellStyle = CellStyle(bold: true);

//     var cell2 = sheet.cell(
//       CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row),
//     );
//     cell2.value = TextCellValue(col2);
//     if (isBold) cell2.cellStyle = CellStyle(bold: true);

//     var cell3 = sheet.cell(
//       CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row),
//     );
//     cell3.value = TextCellValue(col3);
//     if (isBold) cell3.cellStyle = CellStyle(bold: true);
//   }

//   // Helper: Build PDF table row
//   static pw.TableRow _buildPdfTableRow(String label, String value) {
//     return pw.TableRow(
//       children: [
//         pw.Padding(padding: pw.EdgeInsets.all(8), child: pw.Text(label)),
//         pw.Padding(
//           padding: pw.EdgeInsets.all(8),
//           child: pw.Text(
//             value,
//             style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   // Show export options dialog
//   static Future<void> showExportDialog(BuildContext context) async {
//     final parentCubit = context.read<ReportCubit>();

//     return showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing by tapping outside
//       builder: (BuildContext dialogContext) {
//         return BlocProvider.value(
//           value: parentCubit,
//           child: BlocBuilder<ReportCubit, ReportState>(
//             builder: (context, state) {
//               return WillPopScope(
//                 onWillPop: () async =>
//                     !state.isExporting, // Prevent back button when exporting
//                 child: AlertDialog(
//                   title: Text('Export Report'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (state.isExporting) ...[
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             children: [
//                               CircularProgressIndicator(),
//                               SizedBox(height: 16),
//                               Text(
//                                 'Exporting...',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               if (state.exportMessage != null) ...[
//                                 SizedBox(height: 8),
//                                 Text(
//                                   state.exportMessage!,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ] else ...[
//                         ListTile(
//                           leading: Icon(Icons.image, color: Colors.blue),
//                           title: Text('Export as PNG'),
//                           subtitle: Text('Image format'),
//                           onTap: () {
//                             exportAsPNG(context, dialogContext);
//                           },
//                         ),
//                         Divider(),
//                         ListTile(
//                           leading: Icon(
//                             Icons.picture_as_pdf,
//                             color: Colors.red,
//                           ),
//                           title: Text('Export as PDF'),
//                           subtitle: Text('Portable Document Format'),
//                           onTap: () {
//                             exportAsPDF(context, dialogContext);
//                           },
//                         ),
//                         Divider(),
//                         ListTile(
//                           leading: Icon(Icons.table_chart, color: Colors.green),
//                           title: Text('Export as Excel'),
//                           subtitle: Text('Spreadsheet format'),
//                           onTap: () {
//                             exportAsExcel(context, dialogContext);
//                           },
//                         ),
//                       ],
//                     ],
//                   ),
//                   actions: [
//                     if (!state.isExporting)
//                       TextButton(
//                         onPressed: () => Navigator.pop(dialogContext),
//                         child: Text('Cancel'),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskoteladmin/features/report/presentation/cubit/report_cubit.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ReportExportService {
  // Global key for capturing widget
  static final GlobalKey screenshotKey = GlobalKey();

  // Request storage permission (only for mobile)
  static Future<bool> _requestStoragePermission() async {
    if (kIsWeb) return true;

    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        final manageStatus = await Permission.manageExternalStorage.request();
        return manageStatus.isGranted;
      }
      return status.isGranted;
    }
    return true;
  }

  // Capture widget as image using RepaintBoundary
  static Future<Uint8List?> _captureWidget() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));

      final boundary =
          screenshotKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        print('Boundary is null');
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  // Save file for mobile platforms
  static Future<String?> _saveMobileFile(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      print('Error saving mobile file: $e');
      return null;
    }
  }

  // Download file for web
  static void _downloadWebFile(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  // Export as PNG
  static Future<void> exportAsPNG(
    BuildContext context,
    BuildContext dialogContext,
  ) async {
    final cubit = context.read<ReportCubit>();

    try {
      // Set loading state
      cubit.setExportLoading(true);
      cubit.setExportMessage('Capturing report...');

      // Allow UI to update
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture screenshot
      final image = await _captureWidget();
      if (image == null) {
        cubit.setExportLoading(false);
        cubit.setExportMessage('Failed to capture report');
        await Future.delayed(const Duration(milliseconds: 800));
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        return;
      }

      // Request permission (only for mobile)
      if (!kIsWeb) {
        final hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          cubit.setExportLoading(false);
          cubit.setExportMessage('Permission denied');
          await Future.delayed(const Duration(milliseconds: 800));
          if (dialogContext.mounted) Navigator.pop(dialogContext);
          return;
        }
      }

      // Generate filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'report_$timestamp.png';

      // Save or download
      cubit.setExportMessage('Saving...');
      await Future.delayed(const Duration(milliseconds: 50));

      if (kIsWeb) {
        _downloadWebFile(image, fileName);
        cubit.setExportLoading(false);
        cubit.setExportMessage('✓ Downloaded!');
      } else {
        final filePath = await _saveMobileFile(image, fileName);
        cubit.setExportLoading(false);
        if (filePath != null) {
          cubit.setExportMessage('✓ Saved!');
        } else {
          cubit.setExportMessage('Failed to save');
        }
      }

      // Show success briefly
      await Future.delayed(const Duration(milliseconds: 800));

      // Close dialog
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
    } catch (e) {
      print('PNG Export Error: $e');
      cubit.setExportLoading(false);
      cubit.setExportMessage('Export failed');
      await Future.delayed(const Duration(milliseconds: 800));
      if (dialogContext.mounted) Navigator.pop(dialogContext);
    }
  }

  // Export as PDF
  static Future<void> exportAsPDF(
    BuildContext context,
    BuildContext dialogContext,
  ) async {
    final cubit = context.read<ReportCubit>();

    try {
      // Get state from cubit
      final state = cubit.state;

      // Set loading state
      cubit.setExportLoading(true);
      cubit.setExportMessage('Preparing PDF export...');

      // Allow UI to update
      await Future.delayed(const Duration(milliseconds: 300));

      final pdf = pw.Document();

      // Capture screenshot for PDF with delay
      cubit.setExportMessage('Capturing report...');
      await Future.delayed(const Duration(milliseconds: 300));

      final image = await _captureWidget();
      if (image == null) {
        cubit.setExportLoading(false);
        cubit.setExportMessage('Failed to capture report');
        await Future.delayed(const Duration(seconds: 2));
        if (dialogContext.mounted) Navigator.pop(dialogContext);
        return;
      }

      // Allow UI to update before heavy processing
      cubit.setExportMessage('Generating PDF...');
      await Future.delayed(const Duration(milliseconds: 300));

      final pdfImage = pw.MemoryImage(image);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return [
              // Header
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Reports & Analytics',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateTime.now().toString().substring(0, 16)}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
              pw.Text(
                'Year: ${state.selectedYear} | Filter: ${state.timeFilter.name}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
              ),
              pw.SizedBox(height: 20),

              // Key Metrics Section
              pw.Text(
                'Key Metrics',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  _buildPdfTableRow(
                    'Total Revenue (YTD)',
                    '\$${state.totalRevenue.toStringAsFixed(2)}',
                  ),
                  _buildPdfTableRow(
                    'Active Subscribers',
                    '${state.activeSubscribers}',
                  ),
                  _buildPdfTableRow(
                    'Total Subscribers',
                    '${state.totalSubscribers}',
                  ),
                  _buildPdfTableRow(
                    'Churn Rate',
                    '${state.churnRate.toStringAsFixed(1)}%',
                  ),
                  _buildPdfTableRow(
                    'Avg. Revenue Per User',
                    '\$${state.avgRevenuePerUser.toStringAsFixed(2)}',
                  ),
                  _buildPdfTableRow(
                    'Successful Transactions',
                    '${state.successfulTransactions}',
                  ),
                  _buildPdfTableRow(
                    'Failed Transactions',
                    '${state.failedTransactions}',
                  ),
                  _buildPdfTableRow(
                    'Pending Transactions',
                    '${state.pendingTransactions}',
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Revenue by Month
              if (state.revenueByMonth.isNotEmpty) ...[
                pw.Text(
                  'Monthly Revenue',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Month',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Revenue',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...state.revenueByMonth.map(
                      (data) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(data['month']),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '\$${data['revenue'].toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              // Plan Distribution
              if (state.planDistribution.isNotEmpty) ...[
                pw.Text(
                  'Plan Distribution',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Plan',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Subscribers',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            'Revenue',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...state.planDistribution.entries.map(
                      (entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(entry.key),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('${entry.value}'),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              '\${(state.planRevenue[entry.key] ?? 0).toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              // Screenshot of charts
              pw.Text(
                'Visual Reports',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Image(pdfImage, fit: pw.BoxFit.contain),
            ];
          },
        ),
      );

      // Request permission (only for mobile)
      if (!kIsWeb) {
        cubit.setExportMessage('Requesting permissions...');
        await Future.delayed(const Duration(milliseconds: 100));

        final hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          cubit.setExportLoading(false);
          cubit.setExportMessage('Storage permission denied');
          await Future.delayed(const Duration(seconds: 2));
          if (dialogContext.mounted) Navigator.pop(dialogContext);
          return;
        }
      }

      // Generate PDF bytes with delay to allow UI updates
      cubit.setExportMessage('Finalizing PDF...');
      await Future.delayed(const Duration(milliseconds: 300));

      final pdfBytes = await pdf.save();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'report_$timestamp.pdf';

      // Save or download based on platform
      cubit.setExportMessage('Saving file...');
      await Future.delayed(const Duration(milliseconds: 200));

      if (kIsWeb) {
        _downloadWebFile(pdfBytes, fileName);
        cubit.setExportLoading(false);
        cubit.setExportMessage('✓ PDF downloaded successfully!');
      } else {
        final filePath = await _saveMobileFile(pdfBytes, fileName);
        cubit.setExportLoading(false);
        if (filePath != null) {
          cubit.setExportMessage('✓ PDF saved successfully!');
        } else {
          cubit.setExportMessage('Failed to save PDF');
        }
      }

      // Wait to show success message
      await Future.delayed(const Duration(seconds: 2));

      // Close dialog after export is complete
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
    } catch (e) {
      cubit.setExportLoading(false);
      cubit.setExportMessage('Export failed: ${e.toString()}');
      await Future.delayed(const Duration(seconds: 2));
      if (dialogContext.mounted) Navigator.pop(dialogContext);
    }
  }

  // Export as Excel
  static Future<void> exportAsExcel(
    BuildContext context,
    BuildContext dialogContext,
  ) async {
    final cubit = context.read<ReportCubit>();

    try {
      // Get state from cubit
      final state = cubit.state;

      // Set loading state
      cubit.setExportLoading(true);

      // Allow UI to update
      await Future.delayed(const Duration(milliseconds: 100));

      final excel = Excel.createExcel();
      final sheet = excel['Report'];

      int row = 0;

      // Title
      sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('D1'));
      var titleCell = sheet.cell(CellIndex.indexByString('A1'));
      titleCell.value = TextCellValue('Reports & Analytics');
      titleCell.cellStyle = CellStyle(bold: true, fontSize: 18);

      // Date and Filter Info
      row = 1;
      var dateCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      );
      dateCell.value = TextCellValue(
        'Generated on: ${DateTime.now().toString().substring(0, 16)}',
      );

      row++;
      var filterCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      );
      filterCell.value = TextCellValue(
        'Year: ${state.selectedYear} | Filter: ${state.timeFilter.name}',
      );

      // Key Metrics Section
      row += 2;
      var metricsHeaderCell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      );
      metricsHeaderCell.value = TextCellValue('Key Metrics');
      metricsHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

      row += 2;
      _addExcelRow(
        sheet,
        row++,
        'Total Revenue (YTD)',
        '\$${state.totalRevenue.toStringAsFixed(2)}',
      );
      _addExcelRow(
        sheet,
        row++,
        'Active Subscribers',
        '${state.activeSubscribers}',
      );
      _addExcelRow(
        sheet,
        row++,
        'Total Subscribers',
        '${state.totalSubscribers}',
      );
      _addExcelRow(
        sheet,
        row++,
        'Churn Rate',
        '${state.churnRate.toStringAsFixed(1)}%',
      );
      _addExcelRow(
        sheet,
        row++,
        'Avg. Revenue Per User',
        '\$${state.avgRevenuePerUser.toStringAsFixed(2)}',
      );
      _addExcelRow(
        sheet,
        row++,
        'Successful Transactions',
        '${state.successfulTransactions}',
      );
      _addExcelRow(
        sheet,
        row++,
        'Failed Transactions',
        '${state.failedTransactions}',
      );
      _addExcelRow(
        sheet,
        row++,
        'Pending Transactions',
        '${state.pendingTransactions}',
      );

      // Monthly Revenue Section
      if (state.revenueByMonth.isNotEmpty) {
        row += 2;
        var revenueHeaderCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
        );
        revenueHeaderCell.value = TextCellValue('Monthly Revenue');
        revenueHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

        row += 2;
        _addExcelRow(sheet, row++, 'Month', 'Revenue', isBold: true);

        for (final data in state.revenueByMonth) {
          _addExcelRow(
            sheet,
            row++,
            data['month'],
            '\$${data['revenue'].toStringAsFixed(2)}',
          );
        }
      }

      // Plan Distribution Section
      if (state.planDistribution.isNotEmpty) {
        row += 2;
        var planHeaderCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
        );
        planHeaderCell.value = TextCellValue('Plan Distribution');
        planHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

        row += 2;
        _addExcelRowThree(
          sheet,
          row++,
          'Plan',
          'Subscribers',
          'Revenue',
          isBold: true,
        );

        for (final entry in state.planDistribution.entries) {
          final revenue = state.planRevenue[entry.key] ?? 0;
          _addExcelRowThree(
            sheet,
            row++,
            entry.key,
            '${entry.value}',
            '\$${revenue.toStringAsFixed(2)}',
          );
        }
      }

      // Client Acquisition Section
      if (state.clientAcquisitionByMonth.isNotEmpty) {
        row += 2;
        var clientHeaderCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
        );
        clientHeaderCell.value = TextCellValue('Client Acquisition');
        clientHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

        row += 2;
        _addExcelRow(sheet, row++, 'Month', 'New Clients', isBold: true);

        for (final data in state.clientAcquisitionByMonth) {
          _addExcelRow(sheet, row++, data['month'], '${data['count']}');
        }
      }

      // Churn vs Retention Section
      if (state.churnVsRetention.isNotEmpty) {
        row += 2;
        var churnHeaderCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
        );
        churnHeaderCell.value = TextCellValue('Churn vs Retention');
        churnHeaderCell.cellStyle = CellStyle(bold: true, fontSize: 14);

        row += 2;
        _addExcelRowThree(
          sheet,
          row++,
          'Month',
          'Retained',
          'Churned',
          isBold: true,
        );

        for (final data in state.churnVsRetention) {
          _addExcelRowThree(
            sheet,
            row++,
            data['month'],
            '${data['retained']}',
            '${data['churned']}',
          );
        }
      }

      // Request permission (only for mobile)
      if (!kIsWeb) {
        final hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          cubit.setExportLoading(false);
          cubit.setExportMessage('Storage permission denied');
          await Future.delayed(const Duration(seconds: 2));
          if (dialogContext.mounted) Navigator.pop(dialogContext);
          return;
        }
      }

      // Generate Excel bytes with delay to allow UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      final excelBytes = excel.encode()!;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'report_$timestamp.xlsx';

      // Save or download based on platform
      if (kIsWeb) {
        _downloadWebFile(Uint8List.fromList(excelBytes), fileName);
        cubit.setExportLoading(false);
        cubit.setExportMessage('Excel downloaded: $fileName');
      } else {
        final filePath = await _saveMobileFile(
          Uint8List.fromList(excelBytes),
          fileName,
        );
        cubit.setExportLoading(false);
        if (filePath != null) {
          cubit.setExportMessage('Excel exported to: $filePath');
        } else {
          cubit.setExportMessage('Failed to save Excel');
        }
      }

      // Wait a bit to show success message
      await Future.delayed(const Duration(seconds: 2));

      // Close dialog after export is complete
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
    } catch (e) {
      cubit.setExportLoading(false);
      cubit.setExportMessage('Export failed: ${e.toString()}');
      await Future.delayed(const Duration(seconds: 2));
      if (dialogContext.mounted) Navigator.pop(dialogContext);
    }
  }

  // Helper: Add Excel row with two columns
  static void _addExcelRow(
    Sheet sheet,
    int row,
    String col1,
    String col2, {
    bool isBold = false,
  }) {
    var cell1 = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
    );
    cell1.value = TextCellValue(col1);
    if (isBold) cell1.cellStyle = CellStyle(bold: true);

    var cell2 = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row),
    );
    cell2.value = TextCellValue(col2);
    if (isBold) cell2.cellStyle = CellStyle(bold: true);
  }

  // Helper: Add Excel row with three columns
  static void _addExcelRowThree(
    Sheet sheet,
    int row,
    String col1,
    String col2,
    String col3, {
    bool isBold = false,
  }) {
    var cell1 = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
    );
    cell1.value = TextCellValue(col1);
    if (isBold) cell1.cellStyle = CellStyle(bold: true);

    var cell2 = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row),
    );
    cell2.value = TextCellValue(col2);
    if (isBold) cell2.cellStyle = CellStyle(bold: true);

    var cell3 = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row),
    );
    cell3.value = TextCellValue(col3);
    if (isBold) cell3.cellStyle = CellStyle(bold: true);
  }

  // Helper: Build PDF table row
  static pw.TableRow _buildPdfTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: pw.EdgeInsets.all(8), child: pw.Text(label)),
        pw.Padding(
          padding: pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    );
  }

  static Future<void> showExportDialog(BuildContext context) async {
    final parentCubit = context.read<ReportCubit>();

    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: parentCubit,
          child: BlocBuilder<ReportCubit, ReportState>(
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async =>
                    !state.isExporting, // Prevent back button when exporting
                child: AlertDialog(
                  title: Text('Export Report'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isExporting) ...[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Exporting...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (state.exportMessage != null) ...[
                                SizedBox(height: 8),
                                Text(
                                  state.exportMessage!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else ...[
                        ListTile(
                          leading: Icon(Icons.image, color: Colors.blue),
                          title: Text('Export as PNG'),
                          subtitle: Text('Image format'),
                          onTap: () {
                            exportAsPNG(context, dialogContext);
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                          title: Text('Export as PDF'),
                          subtitle: Text('Portable Document Format'),
                          onTap: () {
                            exportAsPDF(context, dialogContext);
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.table_chart, color: Colors.green),
                          title: Text('Export as Excel'),
                          subtitle: Text('Spreadsheet format'),
                          onTap: () {
                            exportAsExcel(context, dialogContext);
                          },
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    if (!state.isExporting)
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text('Cancel'),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
