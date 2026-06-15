import 'foundation/preview_scenario.dart';
import 'scenarios/widget_preview_scenarios.dart';

final previewScenarios = <PreviewScenario>[...widgetPreviewScenarios];

PreviewScenario previewScenarioById(String id) {
  return previewScenarios.singleWhere((scenario) => scenario.id == id);
}
