import 'package:elira_app/screens/progress/progress_ctrl.dart';
import 'package:elira_app/screens/progress/progress_models.dart';
import 'package:elira_app/theme/auth_widgets.dart';
import 'package:elira_app/theme/colors.dart';
import 'package:elira_app/theme/global_widgets.dart';
import 'package:elira_app/theme/text_styles.dart';
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
  final _stepForm = GlobalKey<FormState>();

  TextEditingController namectrl = TextEditingController();
  TextEditingController gitlinkctrl = TextEditingController();
  TextEditingController descctrl = TextEditingController();

  TextEditingController stepNamectrl = TextEditingController();
  TextEditingController stepDescctrl = TextEditingController();

  List<ProjectSteps> projectSteps = [];

  @override
  void initState() {
    super.initState();
    namectrl.text = studProject.name;
    descctrl.text = studProject.description;
    gitlinkctrl.text = studProject.gitLink;
  }

  void addProjectStep(isEdit, name, stepObj) {
    setState(() {
      if (isEdit == true) {
        projectSteps[projectSteps
            .indexWhere((element) => element.name == name)] = stepObj;
      } else {
        projectSteps.add(stepObj);
      }
    });
  }

  @override
  void dispose() {
    namectrl.dispose();
    descctrl.dispose();
    gitlinkctrl.dispose();
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
        Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                      onTap: () {
                        Get.dialog(stepPopup(
                            isEdit: false,
                            stepObj: ProjectSteps('', '', false)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: kPriDark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add)),
                          const Text(
                            'Add Project Step',
                            style: kWhiteTxt,
                          )
                        ],
                      ))),
              projectSteps.isEmpty
                  ? const Text('No Steps Added', style: kLightPurTxt)
                  : ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ...projectSteps.map(buildProjectSteps).toList()
                      ],
                    ),
            ])),
        primaryBtn(
            label: btnLabel,
            width: double.infinity,
            isLoading: progressCtrl.crudBtnLoading,
            function: _projectForm.currentState!.validate()
                ? null
                : () async {
                    progressCtrl.currentProject.name = namectrl.text;
                    progressCtrl.currentProject.description = descctrl.text;
                    progressCtrl.currentProject.gitLink = gitlinkctrl.text;
                    progressCtrl.currentProject.studentId =
                        progressCtrl.studentId!;
                    progressCtrl.currentProject.steps = projectSteps;
                    var status = 'Ongoing';
                    var progress = 0.0;
                    int completed = 0;
                    for (var step in projectSteps) {
                      if (step.complete) {
                        completed += 1;
                      }
                    }
                    if (completed == projectSteps.length) {
                      status = 'Completed';
                      progress = 100.0;
                    } else {
                      progress = (completed / projectSteps.length) * 100.0;
                    }
                    progressCtrl.currentProject.status = status;
                    progressCtrl.currentProject.progress = progress;
                    if (isEdit) {
                      progressCtrl.updateStudentProject();
                    } else {
                      progressCtrl.createStudentProject();
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
                        progressCtrl.currentProject.name = namectrl.text;
                        progressCtrl.currentProject.description = descctrl.text;
                        progressCtrl.currentProject.gitLink = gitlinkctrl.text;
                        progressCtrl.currentProject.studentId =
                            progressCtrl.studentId!;
                        progressCtrl.currentProject.steps = projectSteps;
                        progressCtrl.currentProject.status = 'Completed';
                        progressCtrl.currentProject.progress = 100.0;
                        for (var step in progressCtrl.currentProject.steps) {
                          step.complete = true;
                        }
                        progressCtrl.updateStudentProject();
                      })
            : const SizedBox()
      ],
    );
  }

  Widget buildProjectSteps(ProjectSteps projectStep) =>
      buildSingleStep(projectStep: projectStep);

  Widget buildSingleStep({required ProjectSteps projectStep}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Text(projectStep.name, style: kWhiteTxt),
          subtitle: Text(projectStep.description, style: kLightPurTxt),
          trailing: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                  onTap: () {
                    stepNamectrl.text = projectStep.name;
                    stepDescctrl.text = projectStep.description;
                    Get.dialog(stepPopup(isEdit: true, stepObj: projectStep));
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: kPriDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  )),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    projectSteps.removeWhere(
                        (element) => element.name == projectStep.name);
                  });
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: kPriRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                )),
          ]),
        ));
  }

  Widget stepPopup({required bool isEdit, required ProjectSteps stepObj}) {
    RxBool isStepFormLoading = false.obs;
    return StatefulBuilder(
        builder: (context, setState) => formPopupScaffold(
              formKey: _stepForm,
              children: [
                popupHeader(label: 'Add a step'),
                searchForm(
                  label: 'Step Name',
                  controller: stepNamectrl,
                  inputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the step's Name";
                    }
                    return null;
                  },
                  suffix: false,
                ),
                searchForm(
                  label: 'Step Description',
                  controller: stepDescctrl,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    return null;
                  },
                  suffix: false,
                ),
                Checkbox(
                    value: stepObj.complete,
                    onChanged: (value) {
                      stepObj.complete = !value!;
                    }),
                primaryBtn(
                    label: isEdit == true ? 'Edit Step' : 'Add Step',
                    width: double.infinity,
                    isLoading: isStepFormLoading,
                    function: () async {
                      isStepFormLoading.value = true;

                      if (_stepForm.currentState!.validate()) {
                        var holder = ProjectSteps(stepNamectrl.text,
                            stepDescctrl.text, stepObj.complete);
                        addProjectStep(isEdit, stepObj.name, holder);
                        stepNamectrl.text = '';
                        stepDescctrl.text = '';
                        Get.back();
                      }
                      await Future.delayed(const Duration(seconds: 2));
                      isStepFormLoading.value = false;
                      return;
                    })
              ],
            ));
  }
}
