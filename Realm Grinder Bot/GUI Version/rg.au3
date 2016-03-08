#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.2
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Misc.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListViewEx.au3>

Opt("GUIOnEventMode", 1)

; Check to execute only one instance of this script at a time
If _Singleton("UNIQUE_REALM_GRINDER_KONG", 1) == 0 Then
	MsgBox($MB_ICONERROR, "Warning", "An occurence of this script is already running")
	Exit (1)
EndIf

#cs
	struct {
	string sSpellName;
	int iManaCost;
	int iDuration;
	} Spell;
#ce

; - - - - - C O N S T A N T S - - - - -
Global Const $MAX_SKILLS = 6
Global Const $SPELLS_NUMBER = 3+3+9+2

Func WriteInitializationFile()
	Local Const $sFilePath = @ScriptDir & "\Data.ini"
	;MsgBox(0, "TT", $sFilePath)

	Local $aSection[][2] = [[$SPELLS_NUMBER*3, ""], _
                        	["Name1", "Tax Collection"],    ["Cost1", 200],   ["Duration1", 30], _
							["Name2", "Call to Arms"],      ["Cost2", 400],   ["Duration2", 20], _
							["Name3", "Spiritual Surge"],   ["Cost3", 2500],  ["Duration3", 20], _
							["Name4", "Holy Light"],        ["Cost4", 900],   ["Duration4", 10], _
							["Name5", "Blood Frenzy"],      ["Cost5", 600],   ["Duration5", 20], _
							["Name6", "Gem Grinder"],       ["Cost6", 1000],  ["Duration6", 20], _
							["Name7", "Fairy Chanting"],    ["Cost7", 1000],  ["Duration7", 10], _
							["Name8", "Moon Blessing"],     ["Cost8", 700],   ["Duration8", 20], _
							["Name9", "God's Hand"],        ["Cost9", 900],   ["Duration9", 20], _
							["Name10", "Goblin's Greed"],   ["Cost10", 800],  ["Duration10", 5], _
							["Name11", "Night Time"],       ["Cost11", 1000], ["Duration11", 20], _
							["Name12", "Hellfire Blast"],   ["Cost12", 1000], ["Duration12", 20], _
							["Name13", "Lightning Strike"], ["Cost13", 900],  ["Duration13", 20], _
							["Name14", "Brain Wave"],       ["Cost14", 600],  ["Duration14", 10], _
							["Name15", "Grand Balance"],    ["Cost15", 1000], ["Duration15", 20], _
							["Name16", "Diamond Pickaxe"],  ["Cost16", 1000], ["Duration16", 10], _
							["Name17", "Combo Strike"],     ["Cost17", 800],  ["Duration17", 20]]

	IniWriteSection($sFilePath, "Spells", $aSection)
EndFunc

WriteInitializationFile()
Global Const $g_tagSpell = "STRUCT; int iDuration; int iManaCost; char Name[20]; ENDSTRUCT"
Global $g_atagSpell[$SPELLS_NUMBER]
For $i = 0 To $SPELLS_NUMBER - 1
	$g_atagSpell[$i] = DllStructCreate($g_tagSpell)
Next

Local $aSpells = IniReadSection(@ScriptDir & "\Data.ini", "Spells")
If Not @error Then
	For $i = 0 To $SPELLS_NUMBER - 1
			DllStructSetData($g_atagSpell[$i], "iDuration", $aSpells[(3*$i+1)+2][1])
			DllStructSetData($g_atagSpell[$i], "iManaCost", $aSpells[(3*$i+1)+1][1])
			DllStructSetData($g_atagSpell[$i], "Name", $aSpells[3*$i+1][1])
	Next
EndIf

;For $i = 0 To UBound($g_atagSpell) - 1
;	MsgBox(0, "TT", DllStructGetData($g_atagSpell[$i], "Name") & @CRLF & _
;					DllStructGetData($g_atagSpell[$i], "iManaCost") & @CRLF & _
;					DllStructGetData($g_atagSpell[$i], "iDuration"))
;Next

#Region ### START Koda GUI section ### Form=c:\users\marru\desktop\rg\bot\rgb.kxf
$hForm1 = GUICreate("Realm Grinder Bot", 301, 381, 336, 224)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

$idTab_Primary = GUICtrlCreateTab(0, 0, 300, 312)

; - - - - - R O Y A L - E X C H A N G E S - T A B - - - - -
$idTabItem_RE = GUICtrlCreateTabItem("Royal Exchanges")
$idLabel_RE = GUICtrlCreateLabel("Select which royal exchanges you wish to buy:", 12, 31, 224, 17)
$idCheckBox_FairyRE = GUICtrlCreateCheckbox("Fairy", 48, 54, 97, 17)
$idCheckBox_ElvenRE = GUICtrlCreateCheckbox("Elven", 48, 86, 97, 17)
$idCheckBox_AngelicRE = GUICtrlCreateCheckbox("Angelic", 48, 118, 97, 17)
$idCheckBox_GoblinRE = GUICtrlCreateCheckbox("Goblin", 48, 150, 97, 17)
$idCheckBox_UndeadRE = GUICtrlCreateCheckbox("Undead", 48, 182, 97, 17)
$idCheckBox_DemonicRE = GUICtrlCreateCheckbox("Demonic", 48, 214, 97, 17)
$idCheckBox_DwarvenRE = GUICtrlCreateCheckbox("Dwarven", 48, 246, 97, 17)
$idCheckBox_DrowRECb = GUICtrlCreateCheckbox("Drow", 48, 278, 97, 17)
$idPic_FairyREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\fairyRE.bmp", 20, 51, 24, 24)
$idPic_ElvenREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\elvenRE.bmp", 20, 83, 24, 24)
$idPic_AngelicREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\angelRE.bmp", 20, 115, 24, 24)
$idPic_GoblinREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\goblinRE.bmp", 20, 147, 24, 24)
$idPic_UndeadREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\undeadRE.bmp", 20, 179, 24, 24)
$idPic_DemonicREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\demonRE.bmp", 20, 211, 24, 24)
$idPic_DwarvenREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\dwarfRE.bmp", 20, 243, 24, 24)
$idPic_DrowREIcon = GUICtrlCreatePic(@ScriptDir & "\icons\drowRE.bmp", 20, 275, 24, 24)

; - - - - - F A C T I O N -  U P G R A D E S - T A B - - - - -
$idTabItem_FactionUpgrade = GUICtrlCreateTabItem("Faction Upgrades")

; - - - - - C H A R A C T E R - S T A T S - T A B - - - - -
$idTabItem_CharacterStats = GUICtrlCreateTabItem("Character Stats")
GUICtrlSetState($idTabItem_CharacterStats, $GUI_SHOW)

$idLabel_Faction = GUICtrlCreateLabel("Select your faction: ", 12, 31, 98, 25, $SS_CENTERIMAGE)
$idCombo_Faction = GUICtrlCreateCombo("", 130, 34, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData($idCombo_Faction, "None|Fairy|Elf|Angel|Goblin|Undead|Demon|Titan|Druid|Faceless", "None")
GUICtrlSetOnEvent($idCombo_Faction, "FactionComboChange")

$idLabel_Prestige = GUICtrlCreateLabel("Select prestige faction: ", 12, 64, 111, 25, $SS_CENTERIMAGE)
$idCombo_Prestige = GUICtrlCreateCombo("", 130, 67, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData($idCombo_Prestige, "None", "None")
GUICtrlSetOnEvent($idCombo_Prestige, "PrestigeComboChange")

$idListView_Skills = GUICtrlCreateListView("Skills", 12, 105, 139, 134, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOSORTHEADER, $LVS_NOSCROLL))
GUICtrlSendMsg($idListView_Skills, $LVM_SETCOLUMNWIDTH, 0, 136)
GUICtrlSetTip($idListView_Skills, "Drag skills to cast")
ControlDisable($hForm1, "", HWnd(_GUICtrlListView_GetHeader($idListView_Skills)))  ; Prevent resizing of columns
Global $g_aidListViewItems_Skills[$MAX_SKILLS] = [GUICtrlCreateListViewItem("Tax Collection", $idListView_Skills), _
												  GUICtrlCreateListViewItem("Call To Arms", $idListView_Skills)]
$iLV_Skills = _GUIListViewEx_Init($idListView_Skills, $g_aidListViewItems_Skills, 0, 0, True)

$idListView_Casts = GUICtrlCreateListView("Cast", 150, 105, 139, 134, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOSORTHEADER, $LVS_NOSCROLL))
GUICtrlSendMsg($idListView_Casts, $LVM_SETCOLUMNWIDTH, 0, 136)
ControlDisable($hForm1, "", HWnd(_GUICtrlListView_GetHeader($idListView_Casts)))  ; Prevent resizing of columns
Global $g_aidListViewItems_Casts[$MAX_SKILLS]
$iLV_Casts = _GUIListViewEx_Init($idListView_Casts, $g_aidListViewItems_Casts, 0, 0, True)

$idLabel_ManaPool = GUICtrlCreateLabel("Mana Pool: ", 12, 248, 61, 25, $SS_CENTERIMAGE)
$idInput_ManaPool = GUICtrlCreateInput("", 80, 251, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit($idInput_ManaPool, 6)
GUICtrlSetTip($idInput_ManaPool, "Maximum mana pool")

$idLabel_ManaReg = GUICtrlCreateLabel("Mana Regeneration: ", 12, 280, 104, 25, $SS_CENTERIMAGE)
$idInput_ManaReg = GUICtrlCreateInput("", 123, 283, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit($idInput_ManaReg, 6)
GUICtrlSetTip($idInput_ManaReg, "Mana regeneration per second")

$idButton_Start = GUICtrlCreateButton("START", 32, 332, 73, 25)
GUICtrlSetFont($idButton_Start, 8, 800, 0, "MS Sans Serif")
;GUICtrlSetOnEvent($idButton_Start, "StartButtonClick")

$idButton_Stop = GUICtrlCreateButton("STOP", 192, 332, 73, 25)
GUICtrlSetFont($idButton_Stop, 8, 800, 0, "MS Sans Serif")
;GUICtrlSetOnEvent($idButton_Stop, "StopButtonClick")

GUISetState(@SW_SHOW)
_GUIListViewEx_MsgRegister()

#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func FactionComboChange()
	Local Static $sLastSelectedFaction = ""

	Local $sCurrentFaction = GUICtrlRead($idCombo_Faction, 1)
	If $sCurrentFaction == $sLastSelectedFaction Then
		Return
	EndIf

	; Clear "Skills" List View
	$g_aidListViewItems_Skills = _GUIListViewEx_ReadToArray($idListView_Skills)
	_GUIListViewEx_SetActive($iLV_Skills)
	For $i = 0 To UBound($g_aidListViewItems_Skills) - 1
		_GUIListViewEx_Delete(String($i))
	Next

	; Clear "Cast" List View
	$g_aidListViewItems_Casts = _GUIListViewEx_ReadToArray($idListView_Casts)
	_GUIListViewEx_SetActive($iLV_Casts)
	For $i = 0 To UBound($g_aidListViewItems_Casts) - 1
		_GUIListViewEx_Delete(String($i))
	Next

	GuiCtrlSetState($idCombo_Prestige, $GUI_ENABLE)
	GUICtrlSetData($idCombo_Prestige, "|None", "None")

	_GUIListViewEx_SetActive($iLV_Skills)

	_GUIListViewEx_Insert("Tax Collection")
	_GUIListViewEx_Insert("Call To Arms")

	Switch $sCurrentFaction
		Case "Fairy"
			_GUIListViewEx_Insert("Holy Light")
			_GUIListViewEx_Insert("Fairy Chanting")
			GUICtrlSetData($idCombo_Prestige, "Dwarf")

		Case "Elf"
			_GUIListViewEx_Insert("Holy Light")
			_GUIListViewEx_Insert("Moon Blessing")
			GUICtrlSetData($idCombo_Prestige, "Dwarf")

		Case "Angel"
			_GUIListViewEx_Insert("Holy Light")
			_GUIListViewEx_Insert("God's Hand")
			GUICtrlSetData($idCombo_Prestige, "Dwarf")

		Case "Goblin"
			_GUIListViewEx_Insert("Blood Frenzy")
			_GUIListViewEx_Insert("Goblin's Greed")
			GUICtrlSetData($idCombo_Prestige, "Drow")

		Case "Undead"
			_GUIListViewEx_Insert("Blood Frenzy")
			_GUIListViewEx_Insert("Night Time")
			GUICtrlSetData($idCombo_Prestige, "Drow")

		Case "Demon"
			_GUIListViewEx_Insert("Blood Frenzy")
			_GUIListViewEx_Insert("Hellfire Blast")
			GUICtrlSetData($idCombo_Prestige, "Drow")

		Case "Titan"
			_GUIListViewEx_Insert("Gem Grinder")
			_GUIListViewEx_Insert("Lightning Strike")
			GuiCtrlSetState($idCombo_Prestige, $GUI_DISABLE)

		Case "Druid"
			_GUIListViewEx_Insert("Gem Grinder")
			_GUIListViewEx_Insert("Grand Balance")
			GuiCtrlSetState($idCombo_Prestige, $GUI_DISABLE)

		Case "Faceless"
			_GUIListViewEx_Insert("Gem Grinder")
			_GUIListViewEx_Insert("Brainwave")
			GuiCtrlSetState($idCombo_Prestige, $GUI_DISABLE)
	EndSwitch

	$sLastSelectedFaction = $sCurrentFaction
	PrestigeComboChange()
EndFunc

Func PrestigeComboChange()
	Local Static $sLastSelectedPrestige = ""

	Local $sCurrentPrestige = GUICtrlRead($idCombo_Prestige, 1)
	;MsgBox(0, "TT", $sLastSelectedPrestige & " + " & $sCurrentPrestige)
	If $sCurrentPrestige == $sLastSelectedPrestige Then
		Return
	EndIf

	; Clear "Skills" List View
	$g_aidListViewItems_Skills = _GUIListViewEx_ReadToArray($idListView_Skills)
	_GUIListViewEx_SetActive($iLV_Skills)
	For $i = 0 To UBound($g_aidListViewItems_Skills) - 1
		If $g_aidListViewItems_Skills[$i][0] == "Diamond Pickaxe" OR _
		   $g_aidListViewItems_Skills[$i][0] == "Combo Strike" Then
				_GUIListViewEx_Delete(String($i))
		EndIf
	Next

	; Clear "Cast" List View
	$g_aidListViewItems_Casts = _GUIListViewEx_ReadToArray($idListView_Casts)
	_GUIListViewEx_SetActive($iLV_Casts)
	For $i = 0 To UBound($g_aidListViewItems_Casts) - 1
		If $g_aidListViewItems_Casts[$i][0] == "Diamond Pickaxe" OR _
		   $g_aidListViewItems_Casts[$i][0] == "Combo Strike" Then
				_GUIListViewEx_Delete(String($i))
		EndIf
	Next

	_GUIListViewEx_SetActive($iLV_Skills)
	Switch $sCurrentPrestige
		Case "Dwarf"
			_GUIListViewEx_Insert("Diamond Pickaxe")

		Case "Drow"
			_GUIListViewEx_Insert("Combo Strike")
	EndSwitch

	$sLastSelectedPrestige = $sCurrentPrestige
EndFunc   ;==>PrestigeComboChange

Func Quit()
	Exit (0)
EndFunc   ;==>Quit
