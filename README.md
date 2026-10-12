# 管算通-管道计算器

面向管道安装工、管工、焊工和现场技术人员的 iPhone 离线买断工具，聚焦弯头偏移、滚动偏移、坡度标高、切管长度与管材重量。

## 当前实现

- 5 个可编辑、即时更新的离线计算器。
- 输入边界校验、风险提示和计算过程展示。
- 本地历史、项目归档、收藏与显示设置。
- 结果复制与 iOS 系统分享。
- 坡度、弯头、重量、测量与复核参考内容。
- 首次启动说明、深色模式和 iPhone 竖屏布局。
- 10 项自动化测试及无签名 iOS Release 构建验证。

## 本地验收

```bash
flutter analyze
flutter test
flutter build ios --release --no-codesign
```

签名、上传与 App Store Connect 提交仍需使用开发者账号完成；支持 URL、隐私政策 URL、版权主体、审核联系人和中国大陆备案信息需在提交前替换为真实信息。

## 已确定事项

- App 正式名称：`管算通-管道计算器`
- 英文工作名：`Pipe QuickCalc`
- 商业模式：Paid App，一次购买
- 中国大陆首发价：`CN¥18`
- 首发平台：iPhone
- 首发地区：中国大陆
- 主要分类：工具
- 次要分类：效率
- Bundle ID 建议：`com.cc.guansuantong`
- SKU 建议：`GUANSUANTONG-IOS-2026`

## 文档

- [产品定位与定价](docs/01-product-brief.md)
- [产品需求文档 PRD](docs/02-prd.md)
- [iOS 商品元信息与 ASO](docs/03-ios-metadata-aso.md)
- [App Store Connect 基础字段](docs/04-appstore-connect.md)
- [关键词和竞品依据](docs/05-keyword-competitor-evidence.md)
- [计算口径与验收样例](docs/06-calculation-spec.md)

## 产品边界

V1 是现场几何、坡度和重量计算工具，不是流体设计软件，不计算泵选型、管网水力平衡、承压等级或施工合规结论。

## Google Play handoff

See [google-play/README.md](google-play/README.md) for English listing text, store graphics, screenshot drafts, Android capture instructions and release checks. Open [google-play/preview.html](google-play/preview.html) locally to review the materials.
