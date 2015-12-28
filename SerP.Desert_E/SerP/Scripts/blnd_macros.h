#define PROJECT_PREFIX SerP
#define COMPONENT_NAME blnd
#define QUOTE(VAR1) #VAR1
#define FNC(VAR1) PROJECT_PREFIX##_##COMPONENT_NAME##_fnc_##VAR1
#define VAR(VAR1) PROJECT_PREFIX##_##COMPONENT_NAME##_var_##VAR1
#define GVAR(VAR1,VAR2) (missionNameSpace getVariable ['PROJECT_PREFIX##_##COMPONENT_NAME##_var_##VAR1',VAR2])
#define SVAR(VAR1,VAR2) (missionNameSpace setVariable ['PROJECT_PREFIX##_##COMPONENT_NAME##_var_##VAR1',VAR2])