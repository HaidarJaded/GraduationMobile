import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_mobile/helper/snack_bar_alert.dart';
import 'package:graduation_mobile/models/device_model.dart';
import 'cubit/step_cubit/step_cubit.dart';

class RepairSteps extends StatefulWidget {
  const RepairSteps(
      {super.key,
      required this.device,
      required this.state,
      required this.clientDateWarranty});

  final Device device;
  final String state;
  final DateTime clientDateWarranty;
  @override
  State<RepairSteps> createState() => _RepairSteps();
}

class _RepairSteps extends State<RepairSteps> {
  final TextEditingController _stepController = TextEditingController();
  int _currentStep = 0;

  void _addStep(BuildContext context) {
    context
        .read<RepairStepsCubit>()
        .addStep(_stepController.text, _currentStep);
    _stepController.clear();
    setState(() {
      _currentStep++;
    });
  }

  void _sendToCustomer(BuildContext context) async {
    try {
      context.read<RepairStepsCubit>().saveStepsAndChangeDeviceStatus(
          widget.device,
          widget.device.id as int,
          _stepController.text,
          widget.state,
          widget.clientDateWarranty);
    } catch (e) {
      SnackBarAlert()
          .alert("حدث خطأ أثناء الإرسال", color: Colors.red, title: "خطأ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'خطوات التصليح',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: BlocConsumer<RepairStepsCubit, RepairStepsState>(
        listener: (context, state) {
          if (state is RepairStepsLoading) {
            const Center(child: CircularProgressIndicator());
          } else if (state is RepairStepsFailure) {
            Center(
                child: Text('حدث خطأ: ${state.error}',
                    style: const TextStyle(color: Colors.red)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      controller: _stepController,
                      decoration: InputDecoration(
                        labelText: 'ادخل وصف الخطوة',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _addStep(context),
                      child: const Text('اضف الخطوة'),
                    ),
                    const SizedBox(height: 12),
                    if (state is RepairStepsSuccess)
                      Column(
                        children: state.steps.map((step) {
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: const Icon(FontAwesomeIcons.wrench),
                              title: Text(
                                step['title']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(step['description']!),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 100),
                    InkWell(
                        onTap: () async {
                          _sendToCustomer(context);
                        },
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
                              'Send to customer',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
