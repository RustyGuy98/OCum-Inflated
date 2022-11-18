Scriptname OCumMCMScript extends SKI_ConfigBase

; Settings
int setCleanCumEnterWater
int setDisableCumShot
int setDisableCumDecals
int setDisableInflation
int setCumRegenSpeed
int setCumCleanupTimer
int setInflationCleanupTimer
int setCumBarKey
int setRealisticCumMode
int setCleanCumDecals
int setSquirtChance
int setClearInflation
int setResetDefaults
int setDisableFacialsForElins
int setDecoupleLevelSystem
int setMaxCum
int setMaxBellySize
int _levelSystemFlags

OCumScript property OCum auto


event OnInit()
	parent.OnInit()

	Modname = "OCum Ascended"
endEvent


event OnGameReload()
	parent.onGameReload()
endevent


event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)

	AddColoredHeader("$ocum_header_main_settings")
	setDisableCumShot = AddToggleOption("$ocum_option_disable_cum_shots", OCum.DisableCumshot)
	setDisableCumDecals = AddToggleOption("$ocum_option_disable_cum_decals", OCum.DisableCumDecal)
	setDisableInflation = AddToggleOption("$ocum_option_disable_cum_inflation", OCum.DisableInflation)
	setDisableFacialsForElins = AddToggleOption("$ocum_option_disable_facials_elins", OCum.DisableFacialsForElins)
	setCleanCumEnterWater = AddToggleOption("$ocum_option_clean_water_enter", OCum.cleanCumEnterWater)
	setRealisticCumMode = AddToggleOption("$ocum_option_realistic_cum_mode", OCum.realisticCumMode)
	setCumBarKey = AddKeyMapOption("$ocum_option_cum_bar_key", OCum.checkCumKey)
	AddEmptyOption()

	AddColoredHeader("$ocum_header_reset")
	setCleanCumDecals = AddToggleOption("$ocum_option_clean_cum_decals", false)
	setClearInflation = AddToggleOption("$ocum_option_clear_inflation", false)
	setResetDefaults = AddToggleOption("$ocum_option_reset_defaults", false)

	SetCursorPosition(1)

	AddColoredHeader("$ocum_header_adjustments")
	setSquirtChance = AddSliderOption("$ocum_option_squirt_chance", OCum.squirtChance, "{0}")
	setCumRegenSpeed = AddSliderOption("$ocum_option_cum_regen_speed", OCum.cumRegenSpeed, "{1}")
	setCumCleanupTimer = AddSliderOption("$ocum_option_cum_cleanup_timer", OCum.cumCleanupTimer, "{1}")
	setInflationCleanupTimer = AddSliderOption("$ocum_option_inflation_cleanup_timer", OCum.inflationCleanupTimer, "{1}")
	AddEmptyOption()
	
	AddColoredHeader("$ocum_header_ocum_inflated")
	setDecoupleLevelSystem = AddToggleOption("$ocum_option_decouple_level_system", OCum.DecoupleLevelSystem)
	if OCum.DecoupleLevelSystem
		_levelSystemFlags = OPTION_FLAG_NONE
	else
		_levelSystemFlags = OPTION_FLAG_DISABLED
	endIf
	
	setMaxCum = AddSliderOption("$ocum_option_max_cum", OCum.MaxCum, "{0}", _levelSystemFlags)
	setMaxBellySize = AddSliderOption("$ocum_option_max_belly_size", OCum.MaxBellySize, "{0}%")
	AddEmptyOption()
endEvent


event OnOptionSelect(int option)
	if (option == setCleanCumEnterWater)
		OCum.cleanCumEnterWater = !OCum.cleanCumEnterWater
		SetToggleOptionValue(setCleanCumEnterWater, OCum.cleanCumEnterWater)
	elseif (option == setDisableCumShot)
		OCum.DisableCumshot = !OCum.DisableCumshot
		SetToggleOptionValue(setDisableCumShot, OCum.DisableCumshot)
	elseif (option == setDisableCumDecals)
		OCum.DisableCumDecal = !OCum.DisableCumDecal
		SetToggleOptionValue(setDisableCumDecals, OCum.DisableCumDecal)
	elseif (option == setDisableInflation)
		OCum.DisableInflation = !OCum.DisableInflation
		SetToggleOptionValue(setDisableInflation, OCum.DisableInflation)
	elseif (option == setDisableFacialsForElins)
		OCum.DisableFacialsForElins = !OCum.DisableFacialsForElins
		SetToggleOptionValue(setDisableFacialsForElins, OCum.DisableFacialsForElins)
	elseif (option == setRealisticCumMode)
		OCum.realisticCumMode = !OCum.realisticCumMode
		SetToggleOptionValue(setRealisticCumMode, OCum.realisticCumMode)
	elseif (option == setCleanCumDecals)
		OCum.CleanCumTexturesFromAllActors()
		ShowMessage("$ocum_message_cum_cleaned", false)
	elseif (option == setClearInflation)
		OCum.RemoveBellyScaleFromAllActors()
		ShowMessage("$ocum_message_inflation_cleaned", false)
	elseif (option == setResetDefaults)
		ResetDefaults()
		ShowMessage("$ocum_message_defaults_reset", false)
	elseif (option == setDecoupleLevelSystem)
		OCum.DecoupleLevelSystem = !OCum.DecoupleLevelSystem
		SetToggleOptionValue(setDecoupleLevelSystem, OCum.DecoupleLevelSystem)
		ForcePageReset()
	endIf
endEvent


event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	If (option == setCumBarKey)
		bool continue = true

		if (conflictControl != "")
			string msg

			if (conflictName != "")
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
			endIf

			continue = ShowMessage(msg, true, "$ocum_message_box_option_yes", "$ocum_message_box_option_no")
		endIf

		if (continue)
			OCum.CheckCumKey = keyCode
			SetKeymapOptionValue(setCumBarKey, keyCode)
		endIf
	EndIf
endEvent


event OnOptionSliderOpen(int option)
	If (option == setCumRegenSpeed)
		SetSliderDialogStartValue(OCum.cumRegenSpeed)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 10)
		SetSliderDialogInterval(0.1)
	elseif (option == setSquirtChance)
		SetSliderDialogStartValue(OCum.squirtChance)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == setCumCleanupTimer)
		SetSliderDialogStartValue(OCum.cumCleanupTimer)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.5, 60)
		SetSliderDialogInterval(0.5)
	elseif (option == setInflationCleanupTimer)
		SetSliderDialogStartValue(OCum.inflationCleanupTimer)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.5, 60)
		SetSliderDialogInterval(0.5)
	elseif (option == setMaxCum)
		SetSliderDialogStartValue(OCum.MaxCum)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(1, 150)
		SetSliderDialogInterval(1)
	elseif (option == setMaxBellySize)
		SetSliderDialogStartValue(OCum.MaxBellySize)
		SetSliderDialogDefaultValue(60.0)
		SetSliderDialogRange(1, 100)
		SetSliderDialogInterval(1)
	EndIf
endEvent


event OnOptionSliderAccept(int option, float value)
	If (option == setCumRegenSpeed)
		OCum.cumRegenSpeed = value
		SetSliderOptionValue(setCumRegenSpeed, value, "{1}")
	elseif (option == setSquirtChance)
		OCum.squirtChance = value as int
		SetSliderOptionValue(setSquirtChance, value, "{0}")
	elseif (option == setCumCleanupTimer)
		OCum.cumCleanupTimer = value
		OCum.OCumSpell.SetNthEffectDuration(0, (value * 60) as int)
		SetSliderOptionValue(setCumCleanupTimer, value, "{1}")
	elseif (option == setInflationCleanupTimer)
		OCum.inflationCleanupTimer = value
		OCum.OCumInflationSpell.SetNthEffectDuration(0, (value * 60) as int)
		SetSliderOptionValue(setInflationCleanupTimer, value, "{1}")
	elseif (option == setMaxCum)
		OCum.MaxCum = value
		SetSliderOptionValue(setMaxCum, value, "{0}")
	elseif (option == setMaxBellySize)
		OCum.MaxBellySize = value
		SetSliderOptionValue(setMaxBellySize, value, "{0}%")
	EndIf
endEvent


event OnOptionHighlight(int option)
	if (option == setCleanCumEnterWater)
		SetInfoText("$ocum_highlight_clean_water_enter")
	elseif (option == setDisableCumShot)
		SetInfoText("$ocum_highlight_disable_cum_shots")
	elseif (option == setDisableCumDecals)
		SetInfoText("$ocum_highlight_disable_cum_decals")
	elseif (option == setDisableInflation)
		SetInfoText("$ocum_highlight_disable_cum_inflation")
	elseif (option == setDisableFacialsForElins)
		SetInfoText("$ocum_highlight_disable_facials_elins")
	elseif (option == setCumRegenSpeed)
		SetInfoText("$ocum_highlight_cum_regen_speed")
	elseif (option == setSquirtChance)
		SetInfoText("$ocum_highlight_squirt_chance")
	elseif (option == setCumCleanupTimer)
		SetInfoText("$ocum_highlight_cum_cleanup_timer")
	elseif (option == setInflationCleanupTimer)
		SetInfoText("$ocum_highlight_inflation_cleanup_timer")
	elseif (option == setCumBarKey)
		SetInfoText("$ocum_highlight_cum_bar_key")
	elseif (option == setRealisticCumMode)
		SetInfoText("$ocum_highlight_realistic_cum_mode")
	elseif (option == setCleanCumDecals)
		SetInfoText("$ocum_highlight_clean_cum_decals")
	elseif (option == setClearInflation)
		SetInfoText("$ocum_highlight_clear_inflation")
	elseif (option == setDecoupleLevelSystem)
		SetInfoText("$ocum_highlight_decouple_level_system")
	elseif (option == setMaxCum)
		SetInfoText("$ocum_highlight_max_cum")
	elseif (option == setMaxBellySize)
		SetInfoText("$ocum_highlight_max_belly_size")
	endif
endEvent


; Shamelessly copied from OStim's OSexIntegrationMCM.psc
bool Color1
function AddColoredHeader(String In)
	string Blue = "#6699ff"
	string Pink = "#ff3389"
	string Color

	If Color1
		Color = Pink
		Color1 = False
	Else
		Color = Blue
		Color1 = True
	EndIf

	AddHeaderOption("<font color='" + Color +"'>" + In)
endFunction


function ResetDefaults()
	OCum.cleanCumEnterWater = true
	SetToggleOptionValue(setCleanCumEnterWater, OCum.cleanCumEnterWater)

	OCum.DisableCumshot = false
	SetToggleOptionValue(setDisableCumShot, OCum.DisableCumshot)

	OCum.DisableCumDecal = false
	SetToggleOptionValue(setDisableCumDecals, OCum.DisableCumDecal)

	OCum.DisableInflation = false
	SetToggleOptionValue(setDisableInflation, OCum.DisableInflation)

	OCum.DisableFacialsForElins = false
	SetToggleOptionValue(setDisableFacialsForElins, OCum.DisableFacialsForElins)

	OCum.realisticCumMode = false
	SetToggleOptionValue(setRealisticCumMode, OCum.realisticCumMode)

	OCum.CheckCumKey = 157 ; Right Control
	SetKeymapOptionValue(setCumBarKey, 157)

	OCum.cumRegenSpeed = 1.0
	SetSliderOptionValue(setCumRegenSpeed, 1.0, "{1}")
	
	OCum.squirtChance = 25
	SetSliderOptionValue(setSquirtChance, 25.0, "{0}")

	OCum.cumCleanupTimer = 5
	OCum.OCumSpell.SetNthEffectDuration(0, 5 * 60)
	SetSliderOptionValue(setCumCleanupTimer, 5.0, "{1}")

	OCum.inflationCleanupTimer = 5
	OCum.OCumInflationSpell.SetNthEffectDuration(0, 5 * 60)
	SetSliderOptionValue(setInflationCleanupTimer, 5.0, "{1}")
	
	OCum.DecoupleLevelSystem = false
	SetToggleOptionValue(setDecoupleLevelSystem, OCum.DecoupleLevelSystem)
	
	OCum.MaxCum = 50
	SetSliderOptionValue(setMaxCum, 50.0, "{0}")
	
	OCum.MaxBellySize = 60
	SetSliderOptionValue(setMaxBellySize, 60.0, "{0}%")
endFunction
