import 'dart:io';

import 'package:certificate/certificate/certificate.dart';
import 'package:certificate/helpers/data.dart';
import 'package:certificate/helpers/students.dart';
import 'package:certificate/helpers/providers.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  final GlobalKey childKey = GlobalKey();

  bool _isGenerating = false;
  bool _isLoading = false;

  TextEditingController clubController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController nameColumnDropdownController = TextEditingController();
  TextEditingController courseColumnDropdownController =
      TextEditingController();
  TextEditingController semColumnDropdownController = TextEditingController();
  TextEditingController sectionColumnDropdownController =
      TextEditingController();
  TextEditingController idColumnDropdownController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    clubController.text = ref.read(clubProvider);
    eventController.text = ref.read(eventProvider);
    dateController.text = ref.read(dateProvider);

    clubController.addListener(() {
      ref.read(clubProvider.notifier).state = clubController.text;
    });
    eventController.addListener(() {
      ref.read(eventProvider.notifier).state = eventController.text;
    });
    dateController.addListener(() {
      ref.read(dateProvider.notifier).state = dateController.text;
    });
  }

  @override
  void dispose() {
    clubController.dispose();
    eventController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Certificate",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: eventController,
                decoration: const InputDecoration(
                  labelText: "Event Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: clubController,
                decoration: const InputDecoration(
                  labelText: "Organizer Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ref.watch(dateProvider),
                    style: const TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                          dateController.text =
                              DateFormat("dd MMMM yyyy").format(picked);
                        });
                      }
                    },
                    child: const Text('Select date'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: _isLoading ? null : _openFile,
                child: const Text("Choose Excel (.xlsx) file"),
              ),
              const SizedBox(
                height: 20,
              ),
              if (excel != null)
                Column(
                  children: [
                    DropdownMenu(
                      initialSelection: nameIndex,
                      controller: nameColumnDropdownController,
                      width: 200,
                      label: const Text("Select name"),
                      onSelected: (value) {
                        if (value != null) {
                          nameIndex = value;
                        }
                      },
                      dropdownMenuEntries: [
                        for (var entry in headerMap.entries)
                          DropdownMenuEntry(
                            value: entry.key,
                            label: entry.value,
                          )
                      ],
                    ),
                    DropdownMenu(
                      initialSelection: courseIndex,
                      controller: courseColumnDropdownController,
                      width: 200,
                      label: const Text("Select course"),
                      onSelected: (value) {
                        if (value != null) {
                          courseIndex = value;
                        }
                      },
                      dropdownMenuEntries: [
                        for (var entry in headerMap.entries)
                          DropdownMenuEntry(
                            value: entry.key,
                            label: entry.value,
                          )
                      ],
                    ),
                    DropdownMenu(
                      initialSelection: semIndex,
                      controller: semColumnDropdownController,
                      width: 200,
                      label: const Text("Select semester"),
                      onSelected: (value) {
                        if (value != null) {
                          semIndex = value;
                        }
                      },
                      dropdownMenuEntries: [
                        for (var entry in headerMap.entries)
                          DropdownMenuEntry(
                            value: entry.key,
                            label: entry.value,
                          )
                      ],
                    ),
                    DropdownMenu(
                      initialSelection: sectionIndex,
                      controller: sectionColumnDropdownController,
                      width: 200,
                      label: const Text("Select section"),
                      onSelected: (value) {
                        if (value != null) {
                          sectionIndex = value;
                        }
                      },
                      dropdownMenuEntries: [
                        for (var entry in headerMap.entries)
                          DropdownMenuEntry(
                            value: entry.key,
                            label: entry.value,
                          )
                      ],
                    ),
                    DropdownMenu(
                      initialSelection: idIndex,
                      controller: idColumnDropdownController,
                      width: 200,
                      label: const Text("Select ID"),
                      onSelected: (value) {
                        if (value != null) {
                          idIndex = value;
                        }
                      },
                      dropdownMenuEntries: [
                        for (var entry in headerMap.entries)
                          DropdownMenuEntry(
                            value: entry.key,
                            label: entry.value,
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: _loadData,
                      child: const Text("Load data"),
                    ),
                  ],
                ),
              if (studentsData.isNotEmpty)
                Column(
                  children: [
                    Row(
                      children: [
                        Text("${currentSelected + 1}/${studentsData.length}"),
                        const Spacer(),
                        IconButton(
                          onPressed: currentSelected < 1
                              ? null
                              : () {
                                  setState(() {
                                    currentSelected--;
                                    selectStudent();
                                  });
                                },
                          icon: const Icon(Icons.arrow_left),
                        ),
                        IconButton(
                          onPressed: currentSelected < studentsData.length - 1
                              ? () {
                                  setState(() {
                                    currentSelected++;
                                    selectStudent();
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text("Name"),
                            ),
                            TableCell(
                              child: Text(studentsData[currentSelected].name),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text("Course"),
                            ),
                            TableCell(
                              child: Text(
                                  "${studentsData[currentSelected].course} ${studentsData[currentSelected].sem}${studentsData[currentSelected].section}"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Text("ID"),
                            ),
                            TableCell(
                              child: Text(studentsData[currentSelected].id),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _isGenerating ? null : _generateAll,
                      child: const Text("Generate All"),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  int currentSelected = 0;

  int? nameIndex;
  int? courseIndex;
  int? semIndex;
  int? sectionIndex;
  int? idIndex;

  Excel? excel;
  Map<int, String> headerMap = {};
  List<Student> studentsData = [];

  void selectStudent() {
    if (currentSelected < 0 && currentSelected >= studentsData.length) {
      return;
    }

    var student = studentsData[currentSelected];

    ref.read(nameProvider.notifier).state = student.name;
    ref.read(courseProvider.notifier).state =
        "${student.course} ${student.sem}${student.section}";
    ref.read(idProvider.notifier).state = student.id;
  }

  void _openFile() async {
    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = await file.readAsBytes();
      excel = Excel.decodeBytes(bytes);

      var table = excel!.tables[excel!.tables.keys.first]!;
      var headers = table.rows.first;

      setState(() {
        nameIndex = courseIndex = semIndex = sectionIndex = idIndex = null;
        nameColumnDropdownController.text = "";
        courseColumnDropdownController.text = "";
        semColumnDropdownController.text = "";
        sectionColumnDropdownController.text = "";
        idColumnDropdownController.text = "";

        headerMap = headerMap = {
          for (var cell in headers)
            if (cell != null) cell.columnIndex: cell.value.toString()
        };
        studentsData = [];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadData() async {
    if (excel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a file first"),
        ),
      );
      return;
    }
    if (nameIndex == null || courseIndex == null || semIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select all the fields"),
        ),
      );
      return;
    }

    studentsData = loadStudents(
      excel!,
      nameIndex!,
      courseIndex!,
      semIndex!,
      sectionIndex,
      idIndex,
    );

    setState(() {
      studentsData.length = studentsData.length;
      currentSelected = 0;
    });
    selectStudent();
  }

  void _generateAll() async {
    setState(() {
      _isGenerating = true;
    });

    String? folder = await FilePicker.platform.getDirectoryPath();

    if (folder == null) {
      setState(() {
        _isGenerating = false;
      });
      return;
    }

    await Future.wait([
      for (var student in studentsData) _generatePDF(student, folder),
    ]);

    setState(() {
      _isGenerating = false;
    });
  }

  Future<void> _generatePDF(Student student, String path) async {
    var pdf = await Designs.design1.build(
      PdfPageFormat.a4,
      name: student.name,
      course: "${student.course} ${student.sem}${student.section}",
      id: student.id,
      date: ref.read(dateProvider),
      club: ref.read(clubProvider),
      event: ref.read(eventProvider),
    );

    var file = File(
      "$path/${student.name} ${student.course} ${student.sem}${student.section}${student.id.isNotEmpty ? " ${student.id}" : ""}.pdf",
    );
    await file.writeAsBytes(pdf);
  }
}
