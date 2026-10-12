// Generated from google-play/english-translations.json.
/// Compile with --dart-define=APP_LANGUAGE=en for the overseas variant.
/// The default Chinese build retains its current labels and data keys.
const useEnglish =
    String.fromEnvironment('APP_LANGUAGE', defaultValue: 'zh') == 'en';

abstract final class AppStrings {
  static String formula(Object? value0) =>
      useEnglish ? 'Formula: $value0' : '公式：$value0';
  static String note(Object? value0) =>
      useEnglish ? '\nNote: $value0' : '\n提示：$value0';
  static const carbonSteel = useEnglish ? 'Carbon steel' : '碳钢';
  static const label304StainlessSteel = useEnglish
      ? '304 stainless steel'
      : '304 不锈钢';
  static const label316StainlessSteel = useEnglish
      ? '316 stainless steel'
      : '316 不锈钢';
  static const aluminum = useEnglish ? 'Aluminum' : '铝';
  static const copper = useEnglish ? 'Copper' : '紫铜';
  static const offset = useEnglish ? 'Offset' : '目标偏移量';
  static const leftTakeOff = useEnglish ? 'Left take-off' : '左端扣除';
  static const rightTakeOff = useEnglish ? 'Right take-off' : '右端扣除';
  static const netCutLength = useEnglish ? 'Net cut length' : '净切管长度';
  static const centerlineTravel = useEnglish ? 'Centerline travel' : '斜管中心线行程';
  static const horizontalAdvance = useEnglish ? 'Horizontal advance' : '水平推进量';
  static const totalTakeOff = useEnglish ? 'Total take-off' : '总扣除量';
  static String travelOffsetSin(Object? value0) => useEnglish
      ? 'Travel = offset / sin($value0°)'
      : '行程 = 偏移量 ÷ sin($value0°)';
  static const fittingTakeOffsExceedTheCenterlineTravelCheckTheDimensions =
      useEnglish
      ? 'Fitting take-offs exceed the centerline travel. Check the dimensions.'
      : '管件扣除量超过中心线行程，请复核尺寸。';
  static const horizontalAndVerticalOffsetsCannotBothBeZero = useEnglish
      ? 'Horizontal and vertical offsets cannot both be zero.'
      : '水平偏移和垂直偏移不能同时为 0';
  static const trueOffset = useEnglish ? 'True offset' : '真实偏移量';
  static const rollAngle = useEnglish ? 'Roll angle' : '滚动角';
  static const centerlineTravelHeaa717 = useEnglish
      ? 'Centerline travel'
      : '中心线行程';
  static String trueOffsetHVTravelTrueOffsetSin(Object? value0) => useEnglish
      ? 'True offset = √(H² + V²); travel = true offset / sin($value0°)'
      : '真实偏移 = √(H² + V²)，行程 = 真实偏移 ÷ sin($value0°)';
  static const calculatedFromAbsoluteDimensionsCheckTheOffsetDirectionOnSite =
      useEnglish
      ? 'Calculated from absolute dimensions. Check the offset direction on site.'
      : '已按绝对尺寸计算，请确认现场偏移方向。';
  static const centerDistance = useEnglish ? 'Center distance' : '中心距';
  static const centerToCenterDistance = useEnglish
      ? 'Center-to-center distance'
      : '两连接点中心距';
  static const netCutLengthCenterDistanceLeftTakeOffRightTakeOff = useEnglish
      ? 'Net cut length = center distance − left take-off − right take-off'
      : '净切管长度 = 中心距 − 左端扣除 − 右端扣除';
  static const takeOffsExceedTheCenterDistanceDoNotUseThisResultForCutting =
      useEnglish
      ? 'Take-offs exceed the center distance. Do not use this result for cutting.'
      : '扣除量超过中心距，当前结果不可用于下料。';
  static const outsideDiameter = useEnglish ? 'Outside diameter' : '外径';
  static const wallThickness = useEnglish ? 'Wall thickness' : '壁厚';
  static const length = useEnglish ? 'Length' : '长度';
  static const materialDensity = useEnglish ? 'Material density' : '材料密度';
  static const wallThicknessMustBeLessThanHalfTheOutsideDiameter = useEnglish
      ? 'Wall thickness must be less than half the outside diameter.'
      : '壁厚必须小于外径的一半';
  static const quantityMustBeAPositiveWholeNumber = useEnglish
      ? 'Quantity must be a positive whole number.'
      : '数量必须为正整数';
  static const insideDiameter = useEnglish ? 'Inside diameter' : '内径';
  static const crossSectionalArea = useEnglish ? 'Cross-sectional area' : '截面积';
  static const weightPerMetre = useEnglish ? 'Weight per metre' : '每米理论重量';
  static const weightPerPipe = useEnglish ? 'Weight per pipe' : '单根重量';
  static const totalLength = useEnglish ? 'Total length' : '总长度';
  static const totalWeight = useEnglish ? 'Total weight' : '总重量';
  static const estimatedMaterialCost = useEnglish
      ? 'Estimated material cost'
      : '估算材料成本';
  static const area4ODIDWeightAreaLengthDensity = useEnglish
      ? 'Area = π/4 × (OD² − ID²); weight = area × length × density'
      : '截面积 = π/4 × (外径² − 内径²)，重量 = 截面积 × 长度 × 密度';
  static const theoreticalWeightVariesWithMaterialGradeTolerancesCoatingsAndActualDim =
      useEnglish
      ? 'Theoretical weight varies with material grade, tolerances, coatings and actual dimensions.'
      : '理论重量受材料牌号、制造公差、涂层和实际尺寸影响。';
  static const totalDistance = useEnglish ? 'Total distance' : '总距离';
  static const pointSpacing = useEnglish ? 'Point spacing' : '测点间距';
  static const totalFall = useEnglish ? 'Total fall' : '总落差';
  static const totalRise = useEnglish ? 'Total rise' : '总升高';
  static const endElevation = useEnglish ? 'End elevation' : '终点标高';
  static const equivalentSlope = useEnglish ? 'Equivalent slope' : '坡度等价';
  static String pointElevationStartElevationDistanceSlope(Object? value0) =>
      useEnglish
      ? 'Point elevation = start elevation $value0 distance × slope'
      : '测点标高 = 起点标高 $value0 距离 × 坡度';
  static const horizontalDistance = useEnglish ? 'Horizontal distance' : '水平距离';
  static const fall = useEnglish ? 'Fall' : '落差';
  static const fallHorizontalDistanceSlope = useEnglish
      ? 'Fall = horizontal distance × slope'
      : '落差 = 水平距离 × 坡度';
  static const slope = useEnglish ? 'Slope' : '坡度';
  static const slopeFallHorizontalDistance = useEnglish
      ? 'Slope = fall / horizontal distance'
      : '坡度 = 落差 ÷ 水平距离';
  static const downwardSlope = useEnglish ? 'Downward slope' : '下降坡度';
  static const upwardSlope = useEnglish ? 'Upward slope' : '上升坡度';
  static const startElevation = useEnglish ? 'Start elevation' : '起点标高';
  static const elevationChange = useEnglish ? 'Elevation change' : '高差';
  static const slopeEndElevationStartElevationHorizontalDistance = useEnglish
      ? 'Slope = (end elevation − start elevation) / horizontal distance'
      : '坡度 = (终点标高 − 起点标高) ÷ 水平距离';
  static const angleMustBeGreaterThan0AndLessThan90 = useEnglish
      ? 'Angle must be greater than 0° and less than 90°.'
      : '角度必须大于 0° 且小于 90°';
  static String mustBeGreaterThanZero(Object? value0) =>
      useEnglish ? '$value0 must be greater than zero.' : '$value0必须大于 0';
  static String cannotBeNegative(Object? value0) =>
      useEnglish ? '$value0 cannot be negative.' : '$value0不能小于 0';
  static const pipeQuickCalc = useEnglish ? 'Pipe QuickCalc' : '管算通';
  static const rollingOffset = useEnglish ? 'Rolling offset' : '滚动偏移';
  static const slopeElevation = useEnglish ? 'Slope & elevation' : '坡度标高';
  static const cutLength = useEnglish ? 'Cut length' : '切管长度';
  static const pipeWeight = useEnglish ? 'Pipe weight' : '管材重量';
  static const checkTheDimensionsThenMakeTheCut = useEnglish
      ? 'Check the dimensions.\nThen make the cut.'
      : '现场尺寸，\n算清再下料。';
  static const offsetsElevationsCutLengthsAndPipeWeightCoreCalculationsWorkOffline =
      useEnglish
      ? 'Offsets, elevations, cut lengths and pipe weight. Core calculations work offline.'
      : '弯头偏移、坡度标高、切管长度与管材重量，一次买断，完全离线。';
  static const yourDataStaysOnYourDeviceCheckTheDimensionsAndResultsBeforeCuttingOrIn =
      useEnglish
      ? 'Your data stays on your device. Check the dimensions and results before cutting or installing.'
      : '数据只保存在本机。结果用于放样辅助，切割与安装前请由专业人员复核。';
  static const startWithMetricUnits = useEnglish
      ? 'Start with metric units'
      : '使用公制开始';
  static const calculate = useEnglish ? 'Calculate' : '计算';
  static const projects = useEnglish ? 'Projects' : '项目';
  static const reference = useEnglish ? 'Reference' : '参考';
  static const settings = useEnglish ? 'Settings' : '设置';
  static const elbowOffset = useEnglish ? 'Elbow offset' : '弯头偏移';
  static const singlePlaneOffset = useEnglish ? 'Single-plane offset' : '单平面放样';
  static const horizontalVerticalOffsets = useEnglish
      ? 'Horizontal + vertical offsets'
      : '水平 + 垂直偏移';
  static const fallAndElevationPoints = useEnglish
      ? 'Fall and elevation points'
      : '落差与测点表';
  static const centerDistanceAndTakeOffs = useEnglish
      ? 'Center distance and take-offs'
      : '中心距扣除';
  static const theoreticalWeightEstimate = useEnglish
      ? 'Theoretical weight estimate'
      : '理论重量估算';
  static const fieldCalculationsMetric = useEnglish
      ? 'Field calculations · Metric'
      : '现场常用计算 · 公制';
  static const offline = useEnglish ? 'Offline' : '离线';
  static const allCalculators = useEnglish ? 'All calculators' : '全部计算器';
  static const recentResults = useEnglish ? 'Recent results' : '最近结果';
  static String records(Object? value0) =>
      useEnglish ? '$value0 records' : '$value0 条';
  static const yourCompletedCalculationsAppearHere = useEnglish
      ? 'Your completed calculations appear here.'
      : '完成一次计算后，结果会自动保存在这里。';
  static const checkTheInputValues = useEnglish
      ? 'Check the input values.'
      : '请检查输入数值';
  static const removeFavorite = useEnglish ? 'Remove favorite' : '取消收藏';
  static const favorites = useEnglish ? 'Favorites' : '收藏';
  static const inputs = useEnglish ? 'Inputs' : '输入';
  static const results = useEnglish ? 'Results' : '计算结果';
  static const enterAllRequiredValues = useEnglish
      ? 'Enter all required values.'
      : '请输入完整参数';
  static const copy = useEnglish ? 'Copy' : '复制';
  static const opening = useEnglish ? 'Opening' : '打开中';
  static const share = useEnglish ? 'Share' : '分享';
  static const save = useEnglish ? 'Save' : '保存';
  static const elbowAngle = useEnglish ? 'Elbow angle' : '弯头角度';
  static const custom = useEnglish ? 'Custom' : '自定义';
  static const customAngle = useEnglish ? 'Custom angle' : '自定义角度';
  static const leftCenterToEnd = useEnglish ? 'Left center-to-end' : '左端中心至端面';
  static const rightCenterToEnd = useEnglish
      ? 'Right center-to-end'
      : '右端中心至端面';
  static const horizontalOffsetH = useEnglish
      ? 'Horizontal offset H'
      : '水平偏移 H';
  static const verticalOffsetV = useEnglish ? 'Vertical offset V' : '垂直偏移 V';
  static const calculationMode = useEnglish ? 'Calculation mode' : '计算模式';
  static const findFallFromDistanceAndSlope = useEnglish
      ? 'Find fall from distance and slope'
      : '已知距离和坡度，求落差';
  static const findSlopeFromDistanceAndFall = useEnglish
      ? 'Find slope from distance and fall'
      : '已知距离和落差，求坡度';
  static const findSlopeFromStartAndEndElevations = useEnglish
      ? 'Find slope from start and end elevations'
      : '已知起止标高，求坡度';
  static const generateElevationPoints = useEnglish
      ? 'Generate elevation points'
      : '按间距生成测点标高表';
  static const direction = useEnglish ? 'Direction' : '方向';
  static const down = useEnglish ? 'Down' : '下降';
  static const up = useEnglish ? 'Up' : '上升';
  static const leftTakeOffHc4599a = useEnglish ? 'Left take-off' : '左端扣除尺寸';
  static const rightTakeOffHb548fa = useEnglish ? 'Right take-off' : '右端扣除尺寸';
  static const lengthPerPipe = useEnglish ? 'Length per pipe' : '单根长度';
  static const quantity = useEnglish ? 'Quantity' : '数量';
  static const pipes = useEnglish ? 'pipes' : '根';
  static const material = useEnglish ? 'Material' : '材料';
  static const unitPriceOptional = useEnglish
      ? 'Unit price (optional)'
      : '参考单价（可选）';
  static const currencyKg = useEnglish ? 'currency/kg' : '元/kg';
  static const resultCopied = useEnglish ? 'Result copied' : '结果已复制';
  static String cannotOpenSharing(Object? value0) =>
      useEnglish ? 'Cannot open sharing: $value0' : '无法打开分享：$value0';
  static const cannotOpenSharingTryAgain = useEnglish
      ? 'Cannot open sharing. Try again.'
      : '无法打开系统分享，请稍后重试';
  static const savedToHistory = useEnglish ? 'Saved to history' : '已保存到历史记录';
  static const saveCalculation = useEnglish ? 'Save calculation' : '保存计算结果';
  static const saveToHistoryOrAProject = useEnglish
      ? 'Save to history or a project'
      : '可保存到历史或指定项目';
  static const historyOnly = useEnglish ? 'History only' : '仅保存到历史';
  static const savedToHistoryHc7ff90 = useEnglish
      ? 'Saved to history'
      : '已保存到历史';
  static const addedToProject = useEnglish ? 'Added to project' : '已加入项目';
  static const elevationPoints = useEnglish ? 'Elevation points' : '测点标高表';
  static const calculationSteps = useEnglish ? 'Calculation steps' : '计算过程';
  static const groupCalculationsByJobOrArea = useEnglish
      ? 'Group calculations by job or area'
      : '按现场或区域归档计算结果';
  static const newProject = useEnglish ? 'New project' : '新建项目';
  static const noProjectsYet = useEnglish ? 'No projects yet' : '还没有项目';
  static const createAProjectThenAddResultsFromAnyCalculator = useEnglish
      ? 'Create a project, then add results from any calculator.'
      : '新建项目后，可在计算结果页将记录归档。';
  static const deleteThisProjectAndItsRecords = useEnglish
      ? 'Delete this project and its records?'
      : '删除项目及其中记录？';
  static const noLocation = useEnglish ? 'No location' : '未填写位置';
  static String recordsHf44ecf(Object? value0, Object? value1) =>
      useEnglish ? '$value0 · $value1 records' : '$value0  ·  $value1 条记录';
  static const noRecordsInThisProject = useEnglish
      ? 'No records in this project'
      : '项目中暂无记录';
  static const completeACalculationThenChooseSave = useEnglish
      ? 'Complete a calculation, then choose Save.'
      : '打开任一计算器，完成计算后选择“保存”。';
  static const slopeConversions = useEnglish ? 'Slope conversions' : '坡度单位换算';
  static const percentPerMilleMmMRatioAndAngle = useEnglish
      ? 'Percent, per mille, mm/m, ratio and angle'
      : '百分比、千分比、mm/m、比值与角度';
  static const elbowAngleMultipliers = useEnglish
      ? 'Elbow angle multipliers'
      : '弯头角度乘数';
  static const quickChecksFor2253045And60 = useEnglish
      ? 'Quick checks for 22.5°, 30°, 45° and 60°'
      : '22.5°、30°、45°、60° 快速复核';
  static const pipeWeightFormula = useEnglish
      ? 'Pipe weight formula'
      : '管材重量公式';
  static const roundPipeAreaAndTheoreticalWeight = useEnglish
      ? 'Round-pipe area and theoretical weight'
      : '圆管截面积与理论重量计算';
  static const fieldMeasurements = useEnglish ? 'Field measurements' : '现场测量方法';
  static const centerDistanceAndCenterToEndDimensions = useEnglish
      ? 'Center distance and center-to-end dimensions'
      : '中心距与中心至端面尺寸';
  static const resultChecklist = useEnglish ? 'Result checklist' : '结果复核清单';
  static const checkBeforeCuttingWeldingOrInstalling = useEnglish
      ? 'Check before cutting, welding or installing'
      : '切割、焊接、安装前逐项确认';
  static const scopeAndSafety = useEnglish ? 'Scope and safety' : '安全与责任说明';
  static const formulaAssumptionsAndLimitations = useEnglish
      ? 'Formula assumptions and limitations'
      : '公式适用范围和使用边界';
  static const formulasAndPracticalChecks = useEnglish
      ? 'Formulas and practical checks'
      : '自编公式说明与现场复核要点';
  static const decimalSlopeSFallHorizontalDistance = useEnglish
      ? 'Decimal slope s = fall / horizontal distance.'
      : '坡度小数 s = 落差 ÷ 水平距离。';
  static const format = useEnglish ? 'Format' : '表示方式';
  static const conversion = useEnglish ? 'Conversion' : '换算';
  static const percent = useEnglish ? 'Percent' : '百分比';
  static const perMille = useEnglish ? 'Per mille' : '千分比';
  static const millimetresPerMetre = useEnglish
      ? 'Millimetres per metre'
      : '毫米每米';
  static const ratio = useEnglish ? 'Ratio' : '比值';
  static const angle = useEnglish ? 'Angle' : '角度';
  static const example22020MmM1501146 = useEnglish
      ? 'Example: 2% = 20‰ = 20 mm/m = 1:50 ≈ 1.146°.'
      : '示例：2% = 20‰ = 20 mm/m = 1:50 ≈ 1.146°。';
  static const centerlineTravelTOffsetOSinAdvanceAOTan = useEnglish
      ? 'Centerline travel T = offset O / sin(θ); advance A = O / tan(θ).'
      : '斜管中心线行程 T = 偏移 O ÷ sin(θ)；推进 A = O ÷ tan(θ)。';
  static const travelMultiplier1Sin = useEnglish
      ? 'Travel multiplier 1/sin(θ)'
      : '行程乘数 1/sin(θ)';
  static const useMultipliersForQuickChecksOnlyUseActualMeasurementsAndFittingTakeOff =
      useEnglish
      ? 'Use multipliers for quick checks only. Use actual measurements and fitting take-offs before cutting.'
      : '乘数只用于快速复核，正式下料仍应使用实际输入和管件扣除尺寸。';
  static const insideDiameterDOutsideDiameterD2WallThicknessT = useEnglish
      ? 'Inside diameter d = outside diameter D − 2 × wall thickness t.'
      : '内径 d = 外径 D − 2 × 壁厚 t。';
  static const areaA4DDTheoreticalWeightALengthDensity = useEnglish
      ? 'Area A = π/4 × (D² − d²).\nTheoretical weight = A × length × density.'
      : '截面积 A = π/4 × (D² − d²)。\n理论重量 = A × 长度 × 密度。';
  static const referenceDensityIsNotAMaterialAcceptanceValueGradeTolerancesAndCoating =
      useEnglish
      ? 'Reference density is not a material acceptance value. Grade, tolerances and coatings affect actual weight.'
      : '参考密度不是材料验收值；牌号、公差、涂层会影响实际重量。';
  static const centerDistanceTheDistanceBetweenTheTwoFittingCenterlineIntersections =
      useEnglish
      ? 'Center distance: the distance between the two fitting centerline intersections.'
      : '中心距：两个连接管件中心线交点之间的距离。';
  static const centerToEndTheDistanceFromTheFittingCenterlineIntersectionToItsConnect =
      useEnglish
      ? 'Center-to-end: the distance from the fitting centerline intersection to its connection face.'
      : '中心至端面：从管件中心线交点量到焊口或连接端面的距离。';
  static const dimensionsVaryByStandardPressureClassAndManufacturerUseActualFittingsO =
      useEnglish
      ? 'Dimensions vary by standard, pressure class and manufacturer. Use actual fittings or manufacturer data.'
      : '不同标准、压力等级、系列和厂家尺寸可能不同，应以现场实物或厂家资料为准。';
  static const useConsistentUnitsDoNotMixMetricAndImperial = useEnglish
      ? 'Use consistent units; do not mix metric and imperial.'
      : '单位是否一致，英制与公制没有混用';
  static const confirmWhetherReferencePointsAreCenterlinesOrFaces = useEnglish
      ? 'Confirm whether reference points are centerlines or faces.'
      : '测量基准点是否都是中心线或端面';
  static const checkElbowAngleDirectionAndRollPlane = useEnglish
      ? 'Check elbow angle, direction and roll plane.'
      : '弯头角度、方向和滚动面是否正确';
  static const checkTheFittingTakeOffAtEachEnd = useEnglish
      ? 'Check the fitting take-off at each end.'
      : '左右管件扣除尺寸是否分别核对';
  static const allowSeparatelyForInsulationBevelsWeldShrinkageAndInstallation =
      useEnglish
      ? 'Allow separately for insulation, bevels, weld shrinkage and installation.'
      : '保温、坡口、焊缝收缩或安装余量是否另行考虑';
  static const haveCriticalDimensionsCheckedIndependently = useEnglish
      ? 'Have critical dimensions checked independently.'
      : '关键尺寸是否由第二人独立复核';
  static const thisToolAssistsWithGeometrySlopeAndTheoreticalWeightItDoesNotReplaceEn =
      useEnglish
      ? 'This tool assists with geometry, slope and theoretical weight. It does not replace engineering design, approval, inspection or professional sign-off.'
      : '本工具用于现场几何、坡度和理论重量的计算辅助，不替代设计、审图、验收或专业人员签字。';
  static const thisToolDoesNotDeterminePressureRatingsMaterialSuitabilityWeldingProce =
      useEnglish
      ? 'This tool does not determine pressure ratings, material suitability, welding procedures or installation compliance.'
      : '本工具不提供承压等级、材料适用性、焊接工艺或施工合规结论。';
  static const beforeFabricationOrInstallationAQualifiedPersonMustCheckTheDrawingAppl =
      useEnglish
      ? 'Before fabrication or installation, a qualified person must check the drawing, applicable requirements and site conditions.'
      : '施工、切割、焊接和安装前，必须由具备相应能力的人员结合图纸、规范与现场条件复核。';
  static const displayRecordsAndPrivacy = useEnglish
      ? 'Display, records and privacy'
      : '显示、记录与隐私';
  static const display = useEnglish ? 'Display' : '显示';
  static const decimalPlaces = useEnglish ? 'Decimal places' : '结果小数位';
  static String places(Object? value0) =>
      useEnglish ? '$value0 places' : '$value0 位';
  static const appearance = useEnglish ? 'Appearance' : '外观';
  static const system = useEnglish ? 'System' : '跟随系统';
  static const light = useEnglish ? 'Light' : '浅色';
  static const dark = useEnglish ? 'Dark' : '深色';
  static const data = useEnglish ? 'Data' : '数据';
  static const saveHistoryAutomatically = useEnglish
      ? 'Save history automatically'
      : '自动保存历史';
  static const upTo200RecentRecordsStoredOnThisDevice = useEnglish
      ? 'Up to 200 recent records, stored on this device'
      : '最多保留最近 200 条，仅存储在本机';
  static const clearUnfiledHistory = useEnglish
      ? 'Clear unfiled history'
      : '清空非项目历史';
  static const about = useEnglish ? 'About' : '关于';
  static const privacyPolicy = useEnglish ? 'Privacy policy' : '隐私政策';
  static const noDataCollection = useEnglish ? 'No data collection' : '不收集数据';
  static const pipeQuickCalcHasNoAccountsAdsAnalyticsOrTrackingSDKsProjectsHistoryAnd =
      useEnglish
      ? 'Pipe QuickCalc has no accounts, ads, analytics or tracking SDKs. Projects, history and settings stay on your device. Results are sent to the system share sheet only when you choose Share. Uninstalling removes app-local data.'
      : '管算通不要求注册，不接入广告、分析或第三方追踪。项目、历史和设置仅保存在设备本地。只有在你主动使用分享功能时，结果才会交给系统分享面板。删除 App 会同时删除本地数据。';
  static const support = useEnglish ? 'Support' : '支持与反馈';
  static const forHelpWithCalculationsOrTheAppContact1535883467QqComRemoveConfidentia =
      useEnglish
      ? 'For help with calculations or the app, contact 1535883467@qq.com. Remove confidential project details from screenshots before sending them.'
      : '如需反馈计算口径或使用问题，请在 App Store 商品页使用“App 支持”链接联系开发者。请勿发送包含敏感项目资料的截图。';
  static const version = useEnglish ? 'Version' : '版本';
  static const resultsAreCalculationAidsVerifyDimensionsAndConditionsBeforeFabricatio =
      useEnglish
      ? 'Results are calculation aids. Verify dimensions and conditions before fabrication.'
      : '结果仅用于估算、放样辅助和技术参考。施工前必须复核。';
  static const projectName = useEnglish ? 'Project name' : '项目名称';
  static const locationOrAreaOptional = useEnglish
      ? 'Location or area (optional)'
      : '位置或区域（可选）';
  static const cancel = useEnglish ? 'Cancel' : '取消';
  static const create = useEnglish ? 'Create' : '创建';
  static const confirm = useEnglish ? 'Confirm' : '请确认';
  static const delete = useEnglish ? 'Delete' : '删除';
  static String decimalPlacesH9115ec(Object? value0) =>
      useEnglish ? '$value0 decimal places' : '$value0 位小数';
  static const clearAllHistoryThatIsNotFiledInAProject = useEnglish
      ? 'Clear all history that is not filed in a project?'
      : '清空所有未归档到项目的历史记录？';
  static const ok = useEnglish ? 'OK' : '知道了';
  static const chillerRoomRetrofit = useEnglish
      ? 'Chiller room retrofit'
      : '冷冻机房改造';
  static const areaALevelB1 = useEnglish ? 'Area A · Level B1' : 'A 区 B1 层';
  static const workshopFireLine = useEnglish ? 'Workshop fire line' : '二号车间消防管';
  static const productionBuildingLevel2 = useEnglish
      ? 'Production building · Level 2'
      : '生产楼 2F';
  static const centerDistance4800Mm = useEnglish
      ? 'Center distance 480.0 mm'
      : '中心距 480.0 mm';
  static const h320MmV360Mm45Elbow = useEnglish
      ? 'H 320 mm · V 360 mm · 45° elbow'
      : '横向 320 mm · 竖向 360 mm · 45° 弯头';
  static const endElevation24160Mm = useEnglish
      ? 'End elevation 2,416.0 mm'
      : '终点标高 2,416.0 mm';
  static const length12MSlope07 = useEnglish
      ? 'Length 12 m · Slope 0.7%'
      : '长度 12 m · 坡度 0.7%';
  static const cutLength18260Mm = useEnglish
      ? 'Cut length 1,826.0 mm'
      : '下料长度 1,826.0 mm';
  static const centers2000MmTakeOff174Mm = useEnglish
      ? 'Centers 2,000 mm · Take-off 174 mm'
      : '中心距 2,000 mm · 扣除 174 mm';
  static const totalWeight1864Kg = useEnglish
      ? 'Total weight 186.4 kg'
      : '总重 186.4 kg';
}
