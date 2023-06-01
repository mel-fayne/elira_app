import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final progressCtrl = Get.find<ProgressController>();

class CrudProjectForm extends StatefulWidget {
  static const routeName = "/CrudProjectForm";

  final bool isEdit;
  final String btnLabel;
  final StudentProject studProject;

  const CrudProjectForm(
      {Key? key,
      required this.isEdit,
      required this.studProject,
      required this.btnLabel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return CrudProjectFormState(isEdit, studProject, btnLabel);
  }
}

class CrudProjectFormState extends State<CrudProjectForm> {
  late bool isEdit;
  late StudentProject studProject;
  late String btnLabel;

  CrudProjectFormState(this.isEdit, this.studProject, btnLabel);

  final GlobalKey<FormState> _projectForm = GlobalKey<FormState>();
  TextEditingController namectrl = TextEditingController();
  TextEditingController gitlinkctrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();
  TextEditingController startDatectrl = TextEditingController();
  TextEditingController endDatectrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      setEditForm();
    } else {
      setAddForm();
    }
  }

  setEditForm() {
    namectrl.text = studProject.name;
    descctrl.text = studProject.description;
    gitlinkctrl.text = studProject.gitLink;
  }

  setAddForm() {}

  @override
  void dispose() {
    namectrl.dispose();
    descctrl.dispose();
    gitlinkctrl.dispose();
    startDatectrl.dispose();
    endDatectrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return formPopupScaffold(
      formKey: _projectForm,
      children: [
        popupHeader(label: isEdit ? 'Update Project' : 'Create Project'),
        formField(
            label: 'Project Name',
            labelColor: Colors.white,
            require: true,
            controller: namectrl,
            type: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the project name';
              }
              return null;
            }),
        formField(
            label: 'Description',
            labelColor: Colors.white,
            require: false,
            controller: descctrl,
            type: TextInputType.name,
            validator: (value) {
              return null;
            }),
        formField(
            label: 'Github Link',
            labelColor: Colors.white,
            require: false,
            controller: gitlinkctrl,
            type: TextInputType.name,
            validator: (value) {
              return null;
            }),
        primaryBtn(
            label: btnLabel,
            width: double.infinity,
            isLoading: progressCtrl.crudBtnLoading,
            function: _projectForm.currentState!.validate()
                ? null
                : () async {
                    if (isEdit) {
                      progressCtrl.createStudentProject();
                    } else {
                      progressCtrl.updateStudentProject();
                    }
                  }),
        isEdit
            ? primaryBtn(
                label: 'Complete Project',
                bgColor: kPriMaroon,
                width: double.infinity,
                isLoading: progressCtrl.crudBtnLoading,
                function: _projectForm.currentState!.validate()
                    ? null
                    : () async {
                        progressCtrl.completeProject();
                      })
            : const SizedBox()
      ],
    );
  }
}
