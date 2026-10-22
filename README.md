<p align="center">
  <strong>语言：</strong>
  <a href="./README.md">简体中文</a> ·
  <a href="./README_EN.md">English</a> ·
  <a href="./README_JA.md">日本語</a>
</p>

# 柚子社将领包 / Yuzusoft Generals Pack

<p align="center">
  <strong>Hearts of Iron IV 同人模组 · GitHub 发布镜像</strong>
</p>

<p align="center">
  <a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3303751918">Steam Workshop</a>
  ·
  <a href="https://github.com/Fostanico/Yuzusoft-Generals-Pack">GitHub Release Repository</a>
  ·
  <a href="https://fostanico.github.io/Yuzusoft-Generals-Pack/">制作组鸣谢页</a>
  ·
  <a href="https://docs.qq.com/doc/DZVpkdWRBQ2hITFV2">Bug Report / Suggestions</a>
</p>

---

## 关于本仓库

这里是《柚子社将领包》的 **GitHub 公开发布仓库**。

本仓库主要用于：

- 发布与归档可供玩家下载的公开版本；
- 为无法正常使用 Steam Workshop 的玩家提供替代下载渠道；
- 保存公开版本文件与版本信息；
- 提供项目说明、安装方式、兼容性提示与反馈入口。

> [!IMPORTANT]
> **本仓库不是制作组的主要开发仓库。**
>
> 实际开发、代码重构、内部测试、分支管理与制作组协作在独立的私有开发仓库中进行。  
> 因此，本仓库中的提交历史并不能完整反映《柚子社将领包》的实际开发过程，也不应被视为完整的开发日志。

如果你只是希望正常游玩，优先推荐使用 Steam Workshop；如果 Steam 下载不便、需要手动安装或希望保留特定公开版本，则可以使用本仓库。

---

## 当前公开版本

| 项目 | 信息 |
|---|---|
| Mod 名称 | 柚子社将领包 |
| Mod Version | `1.19` |
| HOI4 `supported_version` | `1.19.3.0` |
| Steam Workshop ID | `3303751918` |
| GitHub 分支 | `main` |

> [!NOTE]
> GitHub 公开版本与 Steam Workshop 版本通常保持接近，但发布时间可能存在短暂差异。  
> 若两个渠道的文件状态不同，以制作组最新公告为准。

---

## 模组简介

《柚子社将领包》最初以将柚子社角色加入《Hearts of Iron IV》为核心，随后逐步扩展为包含角色、国家机制、决议、事件与自定义 UI 的综合型同人模组。

目前主要内容包括：

- 柚子社多部作品角色的将领、顾问与国家领导人；
- 部分 `9-nine-` 与 `NOeSIS` 角色内容；
- UI 化角色招募；
- 好感度与结婚系统；
- 大量角色专属事件、结婚超事件与彩蛋；
- 角色专属升级、任务与决议；
- 柚子主题陆军、海军与空军制造商；
- 工业、军校、军事改革等扩展机制；
- 塔罗牌与其他随机增益内容；
- 特殊单位、特殊装备与角色相关强化；
- 多套自定义 GUI；
- 初级扫雷（9×9、10 颗雷），包含 PARQUET 挑战和核心圈自由游玩两个入口；
- 旧作角色与早期机制持续重制中。

完整玩法说明、角色清单与最新更新内容请以 Steam Workshop 页面为准。

### 开始游玩

进入游戏后，在决议栏的“启用柚子将领包”中选择模式：青春版以将领内容为主，完整版开启大多数机制与剧情，联机削弱版减少部分高强度功能。选择后会打开启动 UI，可在其中查看游玩指南与鸣谢。

PARQUET 入口仍会询问是否游玩小游戏；选择游玩后，通过“PARQUET · 扫雷挑战”决议开始或继续。挑战首胜会招募茨木梨乃、城门翼并播放双人超事件；选择跳过也可直接获得这份剧情奖励。核心圈左上角的 SD 小人可以打开自由游玩，不触发这份剧情奖励。两个入口每盘扫雷胜利均给予 5 政治点，次数不限；关闭棋盘后可继续当前进度。

---

## 下载与安装

### 方法一：Steam Workshop（推荐）

订阅地址：

https://steamcommunity.com/sharedfiles/filedetails/?id=3303751918

Steam 会自动完成下载与更新，适合绝大多数玩家。

### 方法二：GitHub 手动安装

1. 下载本仓库 ZIP，将内容解压到 HOI4 用户目录下的 `mod/Yuzusoft-Generals-Pack/`。该目录内应直接包含 `descriptor.mod`、`common`、`events` 等文件与文件夹，避免多套一层目录。
2. 将其中的 `descriptor.mod` 复制到上一级 `mod` 目录，命名为 `Yuzusoft-Generals-Pack.mod`。这是启动器使用的外部描述符；仓库内的原文件保留。
3. 编辑外部 `Yuzusoft-Generals-Pack.mod`：保留原有字段，删除 `remote_file_id` 一行，并添加以下相对路径：

   ```text
   path="mod/Yuzusoft-Generals-Pack"
   ```

4. 重开 Paradox Launcher，将本地模组加入播放集并启用。同一播放集中只启用本地版或 Workshop 版中的一个，避免重复加载。

如果使用 Git 克隆，也需要按上述步骤创建外部描述符：

```bash
git clone https://github.com/Fostanico/Yuzusoft-Generals-Pack.git
```

> [!WARNING]
> 手动安装时，请特别注意旧版本残留文件。  
> 遇到异常时，建议先完全删除旧版目录，再重新复制当前版本。

---

## Steam 与 GitHub 有什么区别？

### Steam Workshop

适合：

- 普通玩家；
- 希望自动更新；
- 不想手动管理文件；
- 希望第一时间获得面向玩家发布的版本。

### GitHub

适合：

- Steam Workshop 下载不便；
- 希望手动备份某个公开版本；
- 希望查看公开发布文件；
- 需要手动安装；
- 希望通过 Git 进行版本归档。

本 GitHub 仓库 **不承担完整开发协作功能**，因此不建议仅根据这里的提交历史判断某项功能实际用了多久开发、由谁完成或经历了多少次内部重构。

---

## 游戏版本与兼容性

当前 `descriptor.mod` 声明支持：

```text
Hearts of Iron IV 1.19.3.0
```

模组包含较多角色、决议、事件、自定义 GUI 与公共脚本，因此与大型 HOI4 模组共同使用时，可能出现：

- GUI 冲突；
- 公共定义覆盖；
- 角色或国家脚本冲突；
- 事件 ID 或触发条件冲突；
- 特殊机制行为异常；
- 游戏版本更新后失效。

遇到兼容问题时，请尽量提供：

```text
HOI4 Version:
Yuzusoft Generals Pack Version:
Other Enabled Mods:
Reproduction Steps:
Expected Behaviour:
Actual Behaviour:
Relevant error.log:
Screenshot / Save:
```

信息越完整，问题通常越容易定位。

---

## Bug 反馈与建议

反馈文档：

https://docs.qq.com/doc/DZVpkdWRBQ2hITFV2

QQ 群：

```text
967395223
```

你也可以在群内：

- 报告 Bug；
- 提供角色文案；
- 提交结婚超事件创意；
- 讨论平衡与机制；
- 提供图片或 UI 素材；
- 反馈旧作重制建议。

---

## AI 使用声明 / AI Use Statement

本项目使用 OpenAI Codex、ChatGPT、Claude、Grok、Gemini 与 DeepSeek 参与代码实现、素材处理、文案整理、检查与调试。制作组提出需求、决定取舍并进行验收，对最终发布内容负责。

---

## 制作组 / Credits

制作组署名：

1. 牢八
2. 井向真琴
3. **伊尔诺** — Corresponding / Project coordination
4. VAN
5. 岛主
6. 在原七海（老登）
7. **huhu** — Corresponding
8. o5j
9. 彩云赤霞
10. 暮风昔云初（芳乃）
11. Верный
12. 夏目不是枣子姐
13. 柚子
14. 从凌
15. 拿破仑六世
16. 小枫

---

## 相关项目

### 柚子电台

经原作者同意，柚子电台内容已整合进本模组。

只希望收听柚子社 BGM 的玩家，也可以单独使用原电台模组：

https://steamcommunity.com/sharedfiles/filedetails/?id=3143387438

### 社群加强版

由社群成员基于本模组制作的加强版本：

https://steamcommunity.com/sharedfiles/filedetails/?id=3334303111

不建议与本模组同时启用。

---

## 声明

本项目为 **非官方、非商业性质的同人模组**。

- 本项目与 YUZUSOFT、Paradox Interactive 及相关版权方不存在官方隶属或合作关系；
- 原作角色、商标、音乐、美术及其他相关知识产权归各自权利人所有；
- 本仓库仅作为公开版本发布与归档渠道；
- 第三方素材的使用应遵循其原作者或权利人的授权条件；
- 未经明确说明，不应默认本仓库全部内容适用统一的开源许可证。

若相关权利人认为公开内容存在问题，请联系制作组处理。

---

## 致谢

感谢所有参与角色设计、代码、脚本、美术、文本、测试、翻译、兼容性维护和 Bug 反馈的制作组成员与玩家。

也感谢所有一路订阅、游玩、提出建议、贡献文案，以及不断想出奇怪新机制的人。

这个项目从一个简单的将领包逐渐走到今天，本身就是长期合作、持续更新和不断重构的结果。

**Ciallo～(∠・ω< )⌒☆**
