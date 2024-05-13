import 'package:flutter/material.dart';

class AddDetalis extends StatefulWidget {
  const AddDetalis({super.key});

  @override
  State<AddDetalis> createState() => _AddDetalisState();
}

class _AddDetalisState extends State<AddDetalis> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown for selecting the category
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Add Detalis',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.emoji_symbols_sharp),
                    title: Text("Device Number"),
                    subtitle: Text("1"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text("Model"),
                    subtitle: Text("err3345"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text("Date Receipt"),
                    subtitle: Text("33/4/2023"),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'issuss',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.report_problem),
                    title: const Text("Problem"),
                    subtitle:
                        const Text("Molestias sunt ut et dolore fugiat iste."),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.info_rounded),
                    title: const Text("Information"),
                    subtitle: const Text(
                        "Fugit adipisci exercitationem voluptatem quod fugit nemo cumque. Porro pariatur molestias id non. Aliquid id et illo sint."),
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(colors: [
                        Color(0xFF3E7FF8),
                        Color(0xFF21468A),
                      ]),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
