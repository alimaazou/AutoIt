#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <Misc.au3>
#include <Math.au3>
#include <IE.au3>
#include "ImageSearch2015.au3"
#include <MsgBoxConstants.au3>

; Script Start - Add your code below here
;Opt("MustDeclareVars", 1)

; Check to execute only one instance of this script at a time
If _Singleton("UNIQUE_REALM_GRINDER_KONG", 1) == 0 Then
	MsgBox($MB_ICONERROR, "Warning", "An occurence of this script is already running")
	Exit(1)
EndIf

; Setup script
HotKeySet("{ESC}", "QuitScript")
Global $isAutoClickerOn = False
Local Const $rgURL = "http://www.kongregate.com/games/divinegames/realm-grinder"
Local Const $autoClickerHK = "F8"

; Create a browser window to Realm Grinder and maximize it
Local $objRealmGrinder = _IEAttach($rgURL, "url")
;_IECreate($rgURL)
;MaximizeWindow($objRealmGrinder)
WinSetOnTop($objRealmGrinder, "", $WINDOWS_ONTOP)

; Get a reference to the flash window
Local $objRGFlash = ControlGetPos("[CLASS:IEFrame]", "", "MacromediaFlashPlayerActiveX1")

; Get the screen-relative (mouse) coordinates of the currently focused IE window
Local $IEWindowHandle = ControlGetHandle("[CLASS:IEFrame]", "", "Client Caption1")
Local $IEWindowCoords = WinGetPos($IEWindowHandle)
Local $iXIE = _Max($IEWindowCoords[0], 0)
Local $iYIE = _Max($IEWindowCoords[1], 0)
MsgBox(0, "IE Window Coords (Screen Relative)", "X: " & $iXIE & @CRLF & "Y: " & $iYIE)

; Get the browser-relative (control) coordinates of the flash game
Local $iX = $objRGFlash[0]
Local $iY = $objRGFlash[1]
MsgBox(0, "RG Coordinates (Browser Relative)", "X: " & $iX & @CRLF & "Y: " & $iY)

; Get the Width and Height of the flash game window
Local $iWidth  = $objRGFlash[2]
Local $iHeight = $objRGFlash[3]
MsgBox(0, "Flash Size", "Width: " & $iWidth & @CRLF & "Height: " & $iHeight)

; Game Items
Local Const $chestBox = [$iXIE + $iX + 0.5 * $iWidth, $iYIE + $iY + 0.8 * $iHeight]

; Neutral Spells
Local Const $taxCollection = [$iXIE + $iX + 0.1375 * $iWidth, $iYIE + $iY + 0.05 * $iHeight]
Local Const $taxCollectionManaCost = 200

Local Const $callToArms    = [$taxCollection[0], $taxCollection[1] + 1 * 55]
Local Const $callToArmsManaCost = 400
Local Const $callToArmsDuration = 20 * 1000

; Faction Spells
Local Const $factionSpellOne  = [$taxCollection[0], $taxCollection[1] + 2 * 55]
Local Const $factionSpellTwo  = [$taxCollection[0], $taxCollection[1] + 3 * 55]

; Stats
Local Const $manaRegen = 10.9
Local Const $manaPool  = 1409
Global $manaTotal = $manaPool
Global $isManaUpdateRegistered = False
Global $isBrainwaveOn = False

AdlibRegister("CheckManaLevel", 500)

Global $x = 0, $y = 0
Local $angelRE = _ImageSearchArea(@ScriptDir & "/pictures/angelRE.png", 1, $iXIE + $iX, $iYIE + $iY, $objRGFlash[2], $objRGFlash[3], $x, $y)

MsgBox(0, "Coordinates", "X: " & $x & @CRLF & "Y: " & $y)

QuitScript()


While True
	FacelessRotation($manaTotal, $manaRegen)
	;Sleep(_Max((1100 - $manaTotal)/$manaRegen * 1000, 1000))
	Sleep((($manaPool - $manaTotal)/$manaRegen) * 1000)
WEnd

Func MaximizeWindow(Const ByRef $IEAppObj)
	Local $hRGWin  = _IEPropertyGet($objRealmGrinder, "hwnd")
	WinSetOnTop($objRealmGrinder, "", $WINDOWS_ONTOP)
	WinSetState($hRGWin, "", @SW_RESTORE)
	WinSetState($hRGWin, "", @SW_MAXIMIZE)
	Sleep(3500)
EndFunc

Func SetAutoClicker($state)
	If NOT $state AND $isAutoClickerOn Then
		Send("{" & $autoClickerHK & "}")
		$isAutoClickerOn = False
	ElseIf $state AND NOT $isAutoClickerOn Then
		Send("{" & $autoClickerHK & "}")
		$isAutoClickerOn = True
	EndIf
EndFunc

Func QuitScript()
	Exit(0)
EndFunc

Func WaitForManaRefill(ByRef $currentMana, Const ByRef $desiredMana, Const ByRef $manaReg)
	While($currentMana < $desiredMana)
		MouseMove($chestBox[0], $chestBox[1], 5)
		SetAutoClicker(True)
		Sleep(1000)
		SetAutoClicker(False)
	WEnd
EndFunc

Func CheckManaLevel()
	If $manaTotal < $manaPool AND NOT $isManaUpdateRegistered Then
		$isManaUpdateRegistered = True
		AdlibRegister("UpdateTotalMana", 1000)
	ElseIf $manaTotal == $manaPool Then
		$isManaUpdateRegistered = False
		AdlibUnRegister("UpdateTotalMana")
	EndIf
EndFunc

Func UpdateTotalMana()
	$manaTotal += $manaRegen
	If $manaTotal > $manaPool Then
		$manaTotal = $manaPool
	EndIf
EndFunc

Func AngelRotation(ByRef $manaTotal, Const ByRef $manaReg)
	Local $godsHandDuration  = 30 * 1000   ; In mS
	Local $godsHandManaCost  = 800
	Local $holyLightDuration = 15 * 1000  ; In mS
	Local $holyLightManaCost = 800

	; TimeStamps
	Local $godsHandTimeStamp
	Local $holyLightTimeStamp
	Local $CTATimeStamp

	; Toogle off autoclicker if on
	SetAutoClicker(False)

	; Cast God's Hand
	MouseMove($factionSpellTwo[0], $factionSpellTwo[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$godsHandTimeStamp = TimerInit()
	$manaTotal -= $godsHandManaCost

	If $manaTotal < $callToArmsManaCost Then
		WaitForManaRefill($manaTotal, $callToArmsManaCost, $manaRegen)
	EndIf

	; Cast CTA
	MouseMove($callToArms[0], $callToArms[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$CTATimeStamp = TimerInit()
	$manaTotal -= $callToArmsManaCost

	If $manaTotal < $holyLightManaCost Then
		WaitForManaRefill($manaTotal, $holyLightManaCost, $manaRegen)
	EndIf

	; Cast Holy Light
	MouseMove($factionSpellOne[0], $factionSpellOne[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$holyLightTimeStamp = TimerInit()
	$manaTotal -= $holyLightManaCost

	; Start autoclicking chest box
	MouseMove($chestBox[0], $chestBox[1], 5)
	SetAutoClicker(True)

	Local $minDuration = _Min(_Min($godsHandDuration - TimerDiff($godsHandTimeStamp), _
								   $holyLightDuration - TimerDiff($holyLightTimeStamp)), _
							  $callToArmsDuration - TimerDiff($CTATimeStamp))

	; Keep autoclicking until spells are almost off
	While $minDuration >= 1500
		$minDuration -= 1000
		Sleep(1000)
	WEnd
	SetAutoClicker(False)

	; Get Tax Collections
	MouseMove($taxCollection[0], $taxCollection[1], 5)
	While $manaTotal >= $taxCollectionManaCost
		MouseClick($MOUSE_CLICK_LEFT)
		$manaTotal -= $taxCollectionManaCost
	WEnd

	MouseMove($chestBox[0], $chestBox[1], 5)
	SetAutoClicker(True)
EndFunc

Func ElvenRotation(ByRef $manaTotal, Const ByRef $manaReg)
	Local $moonBlessingDuration  = 20 * 1000   ; In mS
	Local $moonBlessingManaCost  = 700
	Local $holyLightDuration = 15 * 1000  ; In mS
    Local $holyLightManaCost = 800

	; Toogle off autoclicker if on
	SetAutoClicker(False)

	; Cast Moon Blessing
	MouseMove($factionSpellTwo[0], $factionSpellTwo[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$manaTotal -= $moonBlessingManaCost

	If $manaTotal < $callToArmsManaCost Then
		WaitForManaRefill($manaTotal, $callToArmsManaCost, $manaRegen)
	EndIf

	; Cast CTA
	MouseMove($callToArms[0], $callToArms[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$manaTotal -= $callToArmsManaCost

	; Start autoclicking chest box
	MouseMove($chestBox[0], $chestBox[1], 5)
	SetAutoClicker(True)
EndFunc

Func TurnBrainwaveOff()
	$isBrainwaveOn = False
	AdlibUnRegister("TurnBrainwaveOff")
EndFunc

Func FacelessRotation(ByRef $manaTotal, Const ByRef $manaReg)
	Local $gemGrinderDuration  = 20 * 1000   ; In mS
	Local $gemGrinderManaCost  = 1000
	Local $brainwaveDuration = 600 * 1000  ; In mS
    Local $brainwaveManaCost = 600

	; Toogle off autoclicker if on
	SetAutoClicker(False)

	; Cast Brainwave
	If NOT $isBrainwaveOn Then
		MouseMove($factionSpellTwo[0], $factionSpellTwo[1], 5)
		AdlibRegister("TurnBrainwaveOff", 600*1000)
		MouseClick($MOUSE_CLICK_LEFT)
		$manaTotal -= $brainwaveManaCost
		$isBrainwaveOn = True

		; Start autoclicking chest box
		MouseMove($chestBox[0], $chestBox[1], 5)
		SetAutoClicker(True)

		Return
	EndIf

	If $manaTotal < $callToArmsManaCost Then
		WaitForManaRefill($manaTotal, $callToArmsManaCost, $manaRegen)
	EndIf

	; Cast CTA
	MouseMove($callToArms[0], $callToArms[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$manaTotal -= $callToArmsManaCost

	If $manaTotal < $gemGrinderManaCost Then
		WaitForManaRefill($manaTotal, $gemGrinderManaCost, $manaRegen)
	EndIf

	; Cast GemGrinder
	MouseMove($factionSpellOne[0], $factionSpellOne[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$manaTotal -= $gemGrinderManaCost

	; Start autoclicking chest box
	MouseMove($chestBox[0], $chestBox[1], 5)
	SetAutoClicker(True)
EndFunc

Func FairyRotation(ByRef $manaTotal, Const ByRef $manaReg)
	Local $holyLightDuration  = 10 * 1000   ; In mS
	Local $holyLightManaCost  = 900
	Local $fairyChantingDuration = 10 * 1000  ; In mS
    Local $fairyChantingManaCost = 1000

	; Toogle off autoclicker if on
	SetAutoClicker(False)

	; Cast CTA
	MouseMove($callToArms[0], $callToArms[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$manaTotal -= $callToArmsManaCost

	If $manaTotal < $fairyChantingManaCost Then
		WaitForManaRefill($manaTotal, $fairyChantingManaCost, $manaRegen)
	EndIf

	; Cast Fairy Chanting
	MouseMove($factionSpellTwo[0], $factionSpellTwo[1], 5)
	MouseClick($MOUSE_CLICK_LEFT)
	$manaTotal -= $fairyChantingManaCost

	; Start autoclicking chest box
	MouseMove($chestBox[0], $chestBox[1], 5)
	SetAutoClicker(True)
EndFunc