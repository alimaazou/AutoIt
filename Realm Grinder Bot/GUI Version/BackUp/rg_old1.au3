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

Opt("GUIOnEventMode", 1)

; Check to execute only one instance of this script at a time
If _Singleton("UNIQUE_REALM_GRINDER_KONG", 1) == 0 Then
	MsgBox($MB_ICONERROR, "Warning", "An occurence of this script is already running")
	Exit(1)
EndIf

#cs
struct {
	string sSpellName;
	int iManaCost;
	int iDuration;
} Spell;
#ce

; - - - - - C O N S T A N T S - - - - -
Global Enum $eNeutral, $eGood, $eEvil
Global Enum $eFairy, $eElf, $eAngel, $eGoblin, $eUndead, $eDemon, _
            $eTitan, $eDruid, $eFaceless, $eDwarf, $eDrow
Global Const $MAX_SKILLS = 4

Global Const $g_tagSpell   = "STRUCT; int iDuration; int iManaCost; char Name[20]; ENDSTRUCT"


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
GUICtrlSetState($idTabItem_CharacterStats,$GUI_SHOW)

$idLabel_Faction = GUICtrlCreateLabel("Select your faction: ", 12, 31, 98, 25, $SS_CENTERIMAGE)
$idCombo_Faction = GUICtrlCreateCombo("", 130, 34, 145, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idCombo_Faction, "None|Fairy|Elf|Angel|Goblin|Undead|Demon|Titan|Druid|Faceless", "None")
GUICtrlSetOnEvent($idCombo_Faction, "FactionComboChange")

$idLabel_Prestige = GUICtrlCreateLabel("Select prestige faction: ", 12, 64, 111, 25, $SS_CENTERIMAGE)
$idCombo_Prestige = GUICtrlCreateCombo("", 130, 67, 145, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idCombo_Prestige, "None|Dwarf|Drow", "None")

$idListView_Skills = GUICtrlCreateListView("Skills|Cast", 12, 105, 274, 134, BitOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_NOSORTHEADER))
GUICtrlSendMsg($idListView_Skills, $LVM_SETCOLUMNWIDTH, 0, 135)
GUICtrlSendMsg($idListView_Skills, $LVM_SETCOLUMNWIDTH, 1, 135)
Global $aidListViewItems_Skills[$MAX_SKILLS] = [GUICtrlCreateListViewItem("Tax Collection", $idListView_Skills), _
						                        GUICtrlCreateListViewItem("Call To Arms", $idListView_Skills)]

;$SkillListView_0 = GUICtrlCreateListViewItem("Tax Collection", $SkillListView)
;$SkillListView_1 = GUICtrlCreateListViewItem("Call To Arms", $SkillListView)

$idLabel_ManaPool = GUICtrlCreateLabel("Mana Pool: ", 12, 248, 61, 25, $SS_CENTERIMAGE)
$idInput_ManaPool = GUICtrlCreateInput("", 80, 251, 57, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetLimit($idInput_ManaPool, 6)
GUICtrlSetTip($idInput_ManaPool, "Maximum mana pool")

$idLabel_ManaReg = GUICtrlCreateLabel("Mana Regeneration: ", 12, 280, 104, 25, $SS_CENTERIMAGE)
$idInput_ManaReg = GUICtrlCreateInput("", 123, 283, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetLimit($idInput_ManaReg, 6)
GUICtrlSetTip($idInput_ManaReg, "Mana regeneration per second")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
    Sleep(100)
WEnd

Func FactionComboChange()
	Switch GUICtrlRead($idCombo_Faction, 1)

GUICtrlCreateListViewItem("Crara", $idListView_Skills)
EndFunc

Func Quit()
	Exit(0)
EndFunc


