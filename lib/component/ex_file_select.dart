import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ExFileSelect extends StatelessWidget {
  const ExFileSelect({super.key, required this.labelText});

  final String labelText;

   void select(TextEditingController controller){
     Future<FilePickerResult?> result = FilePicker.platform.pickFiles(withReadStream: true);
     result.then((value) {
       if (value != null && value.names.isNotEmpty) {
         controller.text = value.names[0]!;
       }
     });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: "");
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            select(controller);
          },
          child: const Text("选择"),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: labelText,
            ),
            onTap: (){
              select(controller);
            },
          ),
        )
      ],
    );
  }
}
