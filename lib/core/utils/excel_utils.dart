import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:taskoteladmin/features/master_task/domain/model/mastertask_model.dart';

class ExcelUtils {
  static Future<void> exportTasksToExcel(
    List<MasterTaskModel> tasks,
    String fileName,
  ) async {
    try {
      // Create Excel workbook
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Tasks'];

      // Add headers
      List<String> headers = [
        'Task ID',
        'Title',
        'Description',
        'Duration (minutes)',
        'Frequency',
        'Department',
        'Place',
        'Day/Date',
        'Assigned Role',
        'Status',
        'Created At',
        'Updated At',
      ];

      // Add header row
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.blue50,
          fontColorHex: ExcelColor.black,
        );
      }

      // Add data rows
      for (int i = 0; i < tasks.length; i++) {
        final task = tasks[i];
        final rowIndex = i + 1;

        List<dynamic> rowData = [
          task.docId,
          task.title,
          task.desc,
          task.duration,
          task.frequency,
          task.departmentId,
          task.place ?? '',
          task.dayOrDate ?? '',
          _getRoleDisplayName(task.assignedRole),
          task.isActive ? 'Active' : 'Inactive',
          _formatDate(task.createdAt),
          _formatDate(task.updatedAt),
        ];

        for (int j = 0; j < rowData.length; j++) {
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: rowIndex));
          cell.value = TextCellValue(rowData[j].toString());
        }
      }

      // Auto-fit columns
      for (int i = 0; i < headers.length; i++) {
        sheetObject.setColumnAutoFit(i);
      }

      // Save file
      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Excel File',
          fileName: '$fileName.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
        );

        if (outputFile != null) {
          File(outputFile)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
      }
    } catch (e) {
      throw Exception('Failed to export Excel file: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> importTasksFromExcel(File file) async {
    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> tasks = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        
        // Skip header row (assuming first row is header)
        for (int i = 1; i < sheet.maxRows; i++) {
          var row = sheet.rows[i];
          if (row.isEmpty) continue;

          // Expected columns: Title, Description, Duration, Frequency, Department, Place, Day/Date
          tasks.add({
            'title': _getCellValue(row, 0),
            'description': _getCellValue(row, 1),
            'duration': int.tryParse(_getCellValue(row, 2)) ?? 30,
            'frequency': _getCellValue(row, 3, defaultValue: 'Daily'),
            'departmentId': _getCellValue(row, 4, defaultValue: 'General'),
            'place': _getCellValue(row, 5),
            'dayOrDate': _getCellValue(row, 6),
          });
        }
      }

      return tasks;
    } catch (e) {
      throw Exception('Failed to import Excel file: $e');
    }
  }

  static Future<void> downloadTemplate() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Template'];

      // Add headers
      List<String> headers = [
        'Title',
        'Description',
        'Duration (minutes)',
        'Frequency',
        'Department',
        'Place',
        'Day/Date',
      ];

      // Add header row with styling
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.blue50,
          fontColorHex: ExcelColor.black,
        );
      }

      // Add sample data
      List<List<String>> sampleData = [
        [
          'Staff Scheduling',
          'Create and manage weekly staff schedules',
          '180',
          'Weekly',
          'Housekeeping',
          'Manager Office',
          'Monday'
        ],
        [
          'Quality Inspection',
          'Conduct daily quality inspections of department areas',
          '90',
          'Daily',
          'Housekeeping',
          'All Floors',
          ''
        ],
        [
          'Inventory Management',
          'Weekly inventory check and ordering',
          '120',
          'Weekly',
          'Housekeeping',
          'Storage Room',
          'Friday'
        ],
      ];

      for (int i = 0; i < sampleData.length; i++) {
        final rowIndex = i + 1;
        for (int j = 0; j < sampleData[i].length; j++) {
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: rowIndex));
          cell.value = TextCellValue(sampleData[i][j]);
        }
      }

      // Auto-fit columns
      for (int i = 0; i < headers.length; i++) {
        sheetObject.setColumnAutoFit(i);
      }

      // Add instructions sheet
      Sheet instructionsSheet = excel['Instructions'];
      List<String> instructions = [
        'Master Task Import Template Instructions',
        '',
        '1. Fill in the task details in the Template sheet',
        '2. Title: Enter a clear task title',
        '3. Description: Provide detailed task description',
        '4. Duration: Enter duration in minutes',
        '5. Frequency: Use Daily, Weekly, Monthly, or Yearly',
        '6. Department: Enter the department name',
        '7. Place: Enter location (optional)',
        '8. Day/Date: Enter specific day or date (optional)',
        '',
        'Supported Departments:',
        '- Housekeeping',
        '- Front Office',
        '- Food & Beverage',
        '- Maintenance',
        '- Security',
        '- Management',
        '- Guest Services',
        '- HR',
        '- Finance',
        '- Kitchen',
        '- Laundry',
        '- Spa & Wellness',
      ];

      for (int i = 0; i < instructions.length; i++) {
        var cell = instructionsSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i));
        cell.value = TextCellValue(instructions[i]);
        if (i == 0) {
          cell.cellStyle = CellStyle(
            bold: true,
            fontSize: 14,
            fontColorHex: ExcelColor.blue,
          );
        }
      }

      // Save template
      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Template',
          fileName: 'master_tasks_template.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
        );

        if (outputFile != null) {
          File(outputFile)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
      }
    } catch (e) {
      throw Exception('Failed to download template: $e');
    }
  }

  static String _getCellValue(List<Data?> row, int index, {String defaultValue = ''}) {
    if (index >= row.length || row[index] == null) {
      return defaultValue;
    }
    return row[index]!.value?.toString() ?? defaultValue;
  }

  static String _getRoleDisplayName(String roleKey) {
    switch (roleKey) {
      case 'rm':
        return 'Regional Manager';
      case 'gm':
        return 'General Manager';
      case 'dm':
        return 'Department Manager';
      case 'staff':
        return 'Operators';
      default:
        return roleKey;
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
