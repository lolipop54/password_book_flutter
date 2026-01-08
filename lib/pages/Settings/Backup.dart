import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/ui/colors.dart';

import 'package:password_book_flutter/controllers/BackupController.dart';

class Backup extends StatefulWidget {
  const Backup({super.key});

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  late final BackupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BackupController());
  }

  @override
  void dispose() {
    Get.delete<BackupController>();
    super.dispose();
  }

  Future<void> _showBackupPasswordDialog() async {
    controller.resetBackupState();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Obx(() => AlertDialog(
              title: Text('创建备份'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!controller.isBackupCreated.value) ...[
                      Text(
                        '请输入备份主密码生成加密密钥，备份主密码将作为恢复数据的唯一凭证，请牢记！',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: controller.backupPasswordController,
                        obscureText: controller.backupPasswordObscure.value,
                        decoration: InputDecoration(
                          labelText: '备份主密码',
                          border: OutlineInputBorder(),
                          hintText: '请输入备份主密码',
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.backupPasswordObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            onPressed: () {
                              controller.backupPasswordObscure.value = !controller.backupPasswordObscure.value;
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        '成功导出 ${controller.exportedCount.value} 项密码数据',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '加密备份数据：',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            controller.encryptedBackup.value,
                            style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                if (!controller.isBackupCreated.value) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            bool success = await controller.createBackup();
                            if (success) {
                              setState(() {});
                            }
                          },
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('创建'),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () async {
                      await controller.copyToClipboard();
                    },
                    child: Text('复制'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('确认'),
                  ),
                ],
              ],
            ));
          },
        );
      },
    );
  }

  Future<void> _showRestoreBackupDialog() async {
    controller.resetRestoreState();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Obx(() => AlertDialog(
              title: Text('恢复备份'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '从加密备份中恢复密码数据，注意，这将替换当前所有密码条目！',
                      style: TextStyle(fontSize: 14, color: Colors.red[600]),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: controller.currentPasswordController,
                      obscureText: controller.currentPasswordObscure.value,
                      decoration: InputDecoration(
                        labelText: '当前主密码',
                        border: OutlineInputBorder(),
                        hintText: '请输入当前主密码以验证身份',
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.currentPasswordObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          onPressed: () {
                            controller.currentPasswordObscure.value = !controller.currentPasswordObscure.value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: controller.restorePasswordController,
                      obscureText: controller.restorePasswordObscure.value,
                      decoration: InputDecoration(
                        labelText: '备份主密码',
                        border: OutlineInputBorder(),
                        hintText: '请输入备份主密码',
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.restorePasswordObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          onPressed: () {
                            controller.restorePasswordObscure.value = !controller.restorePasswordObscure.value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: controller.restoreDataController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: '备份数据',
                        border: OutlineInputBorder(),
                        hintText: '请粘贴加密备份数据',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: controller.isRestoring.value
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text('取消'),
                ),
                ElevatedButton(
                  onPressed: controller.isRestoring.value
                      ? null
                      : () async {
                          bool success = await controller.restoreBackup();
                          if (success) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: controller.isRestoring.value
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('恢复'),
                ),
              ],
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Text('备份与恢复', style: TextStyle(fontSize: 48)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorGray,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.warning_amber_outlined),
                    ),

                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('备份/恢复功能可以帮您生成所有密码的加密备份，您随时可以通过加载备份信息恢复密码数据。'),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 175,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorGray,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(Icons.backup, size: 32,color: Theme.of(context).colorScheme.onSurface,),
                          Text('备份数据', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 24),)
                        ],
                      ),
                    ),

                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('将所有密码导出为加密备份，密码将以您的主密码加密，以确保安全性。'),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          _showBackupPasswordDialog();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                            alignment: Alignment.center,
                            width: 120,
                            height: 48,
                          child: Text('创建备份', style: TextStyle(fontSize: 16, color: colorWhite),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 175,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorGray,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(Icons.settings_backup_restore, size: 32,color: Theme.of(context).colorScheme.onSurface,),
                          Text('恢复数据', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 24),)
                        ],
                      ),
                    ),

                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('从加密备份中恢复密码数据，注意，这将替换当前所有密码条目！'),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          _showRestoreBackupDialog();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          alignment: Alignment.center,
                          width: 120,
                          height: 48,
                          child: Text('恢复备份', style: TextStyle(fontSize: 16, color: colorWhite),),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
