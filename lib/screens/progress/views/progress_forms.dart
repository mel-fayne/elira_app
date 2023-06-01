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

  final bool isFormEdit;
  final String btnLabel;
  final StudentProject studProject;

  const CrudProjectForm(
      {Key? key,
      required this.isFormEdit,
      required this.studProject,
      required this.btnLabel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return CrudProjectFormState(isFormEdit, studProject, btnLabel);
  }
}

class CrudProjectFormState extends State<CrudProjectForm> {
  late bool isFormEdit;
  late StudentProject studProject;
  late String btnLabel;

  CrudProjectFormState(this.isFormEdit, this.studProject, this.btnLabel);

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
    projectSteps = [...studProject.steps];
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
        popupHeader(label: isFormEdit ? 'Update Project' : 'Create Project'),
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
            maxLines: 7,
            boxHeight: 130.0,
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
        projectSteps.isEmpty
            ? const Text('No Steps Added', style: kWhiteTitle)
            : Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Project Checklist', style: kLightPurTxt),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ...projectSteps.map(buildProjectSteps).toList()
                        ],
                      )
                    ])),
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
                              margin: const EdgeInsets.only(right: 5),
                              child: const Icon(Icons.add)),
                          const Text(
                            'Add Project Step',
                            style: kLightPurTxt,
                          )
                        ],
                      ))),
            ])),
        primaryBtn(
            label: btnLabel,
            width: double.infinity,
            isLoading: progressCtrl.crudBtnLoading,
            function: () async {
              if (_projectForm.currentState!.validate()) {
                progressCtrl.currentProject.name = namectrl.text;
                progressCtrl.currentProject.description = descctrl.text;
                progressCtrl.currentProject.gitLink = gitlinkctrl.text;
                progressCtrl.currentProject.studentId = progressCtrl.studentId!;
                progressCtrl.currentProject.steps = projectSteps;
                var status = 'Ongoing';
                var progress = 0.0;
                int completed = 0;
                for (var step in projectSteps) {
                  if (step.complete) {
                    completed += 1;
                  }
                }
                if (projectSteps.isNotEmpty &&
                    completed == projectSteps.length) {
                  status = 'Completed';
                  progress = 100.0;
                } else {
                  progress = (completed / projectSteps.length) * 100.0;
                }
                progressCtrl.currentProject.status = status;
                progressCtrl.currentProject.progress = progress;

                if (isFormEdit) {
                  await progressCtrl.updateStudentProject();
                } else {
                  await progressCtrl.createStudentProject();
                }
                Get.back();
              }
            }),
        isFormEdit
            ? primaryBtn(
                label: 'Complete Project',
                bgColor: kPriMaroon,
                width: double.infinity,
                isLoading: progressCtrl.crudBtnLoading,
                function: () async {
                  if (_projectForm.currentState!.validate()) {
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
                    await progressCtrl.updateStudentProject();
                    Get.back();
                  }
                })
            : const SizedBox(),
        primaryBtn(
            label: 'Delete Project',
            width: double.infinity,
            bgColor: kPriRed,
            isLoading: progressCtrl.crudBtnLoading,
            function: () async {
              progressCtrl.currentProject = studProject;
              await progressCtrl.deleteStudentProject();
            })
      ],
    );
  }

  Widget buildProjectSteps(ProjectSteps projectStep) =>
      buildSingleStep(projectStep: projectStep);

  Widget buildSingleStep({required ProjectSteps projectStep}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: kPriGrey, borderRadius: BorderRadius.circular(7)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Icon(
              projectStep.complete
                  ? Icons.check_circle_outline
                  : Icons.circle_outlined,
              size: 24,
              color: kPriDark,
            ),
          ),
          Text(
            projectStep.name,
            style: kDarkTxt,
          )
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
        ])
      ]),
    );
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
                  maxLines: 2,
                  controller: stepDescctrl,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    return null;
                  },
                  suffix: false,
                ),
                CheckboxListTile(
                  value: stepObj.complete,
                  onChanged: (value) {
                    setState(() {
                      stepObj.complete = value!;
                    });
                  },
                  title: const Text(
                    'Step Completed',
                    style: kWhiteTxt,
                  ),
                ),
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
