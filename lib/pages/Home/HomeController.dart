import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entity/PasswordEntry.dart';
import '../../entity/user.dart';
import '../../helpers/DatabaseHelper.dart';


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
  void updateUsedCountAndLastUsedTime(PasswordEntry item) async {
    DateTime lastUsedTime = DateTime.now();
    int usedCount = (item.usedCount ?? 0) + 1;

    PasswordEntry newItem = item.copyWith(
      lastUsedTime: lastUsedTime,
      usedCount: usedCount,
    );

    await Databasehelper().updatePasswordEntry(newItem);

    // 更新完数据库后，重新拉取数据，界面会自动刷新
    getAllPasswordEntries();
  }
}