import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../entity/PasswordEntry.dart';
import '../../entity/user.dart';
import '../../helpers/DatabaseHelper.dart';
import '../../helpers/EncryptionHelper.dart';


class Homecontroller extends GetxController {
  // ========================== 1. 基础状态 ==========================

  // 【核心数据源】只负责存储从数据库读出来的所有数据，不做任何删除/过滤
  final RxList<PasswordEntry> _allSourceList = <PasswordEntry>[].obs;

  // 【UI展示数据】最终给页面 ListView 使用的列表
  final RxList<PasswordEntry> displayList = <PasswordEntry>[].obs;

  // 搜索框控制器 & 状态
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  var isFocused = false.obs;

  // 搜索词状态
  final searchText = ''.obs;

  // Tab 状态 (0: 全部, 1: 常用)
  final selections = ["全部", "常用"];
  final _selectId = 0.obs;
  int get selectId => _selectId.value;
  set selectId(int value) => _selectId.value = value;

  // 是否点击了复制按钮
  final _copiedId = (-1).obs;
  int get copiedId => _copiedId.value;
  set copiedId(int value) => _copiedId.value = value;

  // 定义一个 Timer 变量，用于管理延时任务
  Timer? _resetTimer;
  
  // 长按相关状态
  final _longPressId = (-1).obs;
  int get longPressId => _longPressId.value;
  set longPressId(int value) => _longPressId.value = value;
  
  // 长按定时器
  Timer? _longPressTimer;
  
  // 长按是否已触发边框变色
  final _isLongPressBorderChanged = false.obs;
  bool get isLongPressBorderChanged => _isLongPressBorderChanged.value;
  set isLongPressBorderChanged(bool value) => _isLongPressBorderChanged.value = value;

  // ========================== 2. 初始化与监听 ==========================

  @override
  void onInit() {
    super.onInit();

    // 监听焦点
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });

    // 【核心逻辑】Pipeline 流水线
    // 监听：源数据变化 OR 搜索词变化 OR Tab切换
    // 只要这三个有任意一个变了，就自动重新计算 displayList
    everAll([_allSourceList, searchText, _selectId], (_) => _processPipeline());

    // 初始加载数据
    getAllPasswordEntries();
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchController.dispose();
    _resetTimer?.cancel();
    _longPressTimer?.cancel();
    super.onClose();
  }

  // ========================== 3. 数据处理流水线 ==========================

  /// 这是最关键的函数，统一处理筛选逻辑
  void _processPipeline() {
    // 1. 拿副本（基于全量数据开始处理）
    List<PasswordEntry> result = List.from(_allSourceList);

    // 2. 处理搜索过滤 (如果输入了字)
    if (searchText.value.isNotEmpty) {
      result = result.where((e) {
        return e.title.toLowerCase().contains(searchText.value.toLowerCase());
      }).toList();
    }

    // 3. 处理 Tab 过滤 (如果是"常用" Tab)
    if (selectId == 1) { // 假设 1 是常用
      result = _applyCommonLogic(result);
    }

    // 4. 赋值给 UI
    displayList.assignAll(result);
  }

  /// 提取出来的常用算法逻辑（纯函数，不修改外部状态）
  List<PasswordEntry> _applyCommonLogic(List<PasswordEntry> inputList) {
    // 过滤掉没用过的
    var tempList = inputList.where((element) => (element.usedCount ?? 0) > 0).toList();

    // 排序
    tempList.sort((a, b) {
      // 你的原始排序逻辑
      if (a.lastUsedTime == null || a.usedCount == null) return 1;
      if (b.lastUsedTime == null || b.usedCount == null) return -1;

      double scoreA = calculateScore(a.lastUsedTime!, a.usedCount!);
      double scoreB = calculateScore(b.lastUsedTime!, b.usedCount!);

      return scoreB.compareTo(scoreA); // 降序
    });

    // 取前5
    if (tempList.length > 5) {
      tempList = tempList.sublist(0, 5);
    }
    return tempList;
  }

  double calculateScore(DateTime lastUsedTime, int usedCount) {
    final hoursAgo = DateTime.now().difference(lastUsedTime).inHours;
    return usedCount / pow(hoursAgo + 2, 1.5);
  }

  // ========================== 4. 交互动作 ==========================

  // 从数据库拉取最新全量数据
  Future<void> getAllPasswordEntries() async {
    User? user = await Databasehelper().getFirstUser();
    if (user == null) return;

    var list = await Databasehelper().getAllPasswordEntries(user.id!);
    // 更新源数据，会自动触发 _processPipeline
    _allSourceList.assignAll(list);
  }

  // 搜索框文字改变
  void onSearchTextChange(String text) {
    searchText.value = text; // 仅仅更新变量，ever 会自动处理后续逻辑
  }

  // 清空搜索
  void onClearSearchText() {
    searchController.clear();
    searchText.value = ""; // 触发 pipeline
    focusNode.unfocus();
  }

  // 切换 Tab
  void changeSelection(int index) {
    selectId = index; // 仅仅更新变量，ever 会自动处理后续逻辑
  }

  // 【修复Bug】更新使用次数
  // 注意：这里必须接收具体的 item 对象，不能只接收 index
  // 因为 displayList 的 index 和 _allSourceList 的 index 是不一样的！
  void updateUsedCountAndLastUsedTime(PasswordEntry item, [bool isFresh = true]) async {
    DateTime lastUsedTime = DateTime.now();
    int usedCount = (item.usedCount ?? 0) + 1;

    PasswordEntry newItem = item.copyWith(
      lastUsedTime: lastUsedTime,
      usedCount: usedCount,
    );

    await Databasehelper().updatePasswordEntry(newItem);

    // 更新完数据库后，重新拉取数据，界面会自动刷新
    if(isFresh){
      getAllPasswordEntries();
    }

  }

  void onCopy(PasswordEntry entry) async{
    final decryptPassword = await EncryptionHelper().decryptPassword(entry.encryptedPassword, entry.nonce,entry.mac);
    Clipboard.setData(ClipboardData(text: decryptPassword));
    updateUsedCountAndLastUsedTime(entry, false);
    _copiedId.value = entry.id!;
    // 4. 启动 1 秒后复位的定时器
    _startResetTimer();
  }

  void _startResetTimer() {
    // 重要：每次点击先取消上一次的定时器
    // 这是为了防止快速点击时，旧的定时器把你新设置的状态给清空了
    _resetTimer?.cancel();
      // 1 秒后，清空 ID，UI 就会自动复原
    _resetTimer = Timer(Duration(milliseconds: 1500), (){
      _copiedId.value = -1;

      // 2. 动画结束了，这时候再去刷新列表数据
      // 这样用户既看到了变色，列表排序更新也不会显得突兀
      getAllPasswordEntries();
    });

  }
  
  // 长按开始
  void onLongPressStart(PasswordEntry entry) {
    // 取消之前的定时器
    _longPressTimer?.cancel();
    
    // 设置当前长按的ID
    longPressId = entry.id!;
    isLongPressBorderChanged = true;
    
    // 0.3秒后跳转到详情页
    _longPressTimer = Timer(Duration(milliseconds: 300), () async{
      if (longPressId == entry.id) {
        final decryptPassword = await EncryptionHelper().decryptPassword(entry.encryptedPassword, entry.nonce,entry.mac);
        final entryCopy = entry.copyWith(encryptedPassword: decryptPassword);
        Get.toNamed('/details', arguments: entryCopy);
        _longPressTimer = Timer(Duration(milliseconds: 300), () {
          resetLongPressState();
        });
      }
    });
  }
  
  // 长按结束（手指抬起）
  void onLongPressEnd() {
    resetLongPressState();
    // 取消定时器，但保持边框颜色状态
    _longPressTimer?.cancel();
  }
  
  // 重置长按状态
  void resetLongPressState() {
    _longPressTimer?.cancel();
    longPressId = -1;
    isLongPressBorderChanged = false;
  }
}