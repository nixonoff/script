script_name('Auto-Censure')
script_authors('Connor Laffelay')
script_description('Script for auto censuring.')
script_properties("work-in-pause")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require("moonloader").download_status
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8 
local key = require 'vkeys'
local sampev = require 'lib.samp.events'

local interactive = imgui.ImBool(false)
local ban = imgui.ImBool(false)
local jail = imgui.ImBool(false)
local mute = imgui.ImBool(false)
local kick = imgui.ImBool(false)
local warn = imgui.ImBool(false)

local id_buffer = imgui.ImBuffer(5)

update_state = false

local script_vers = 5
local script_vers_text = "0.5"

local update_url = "https://raw.githubusercontent.com/nixonoff/script/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://raw.githubusercontent.com/nixonoff/script/master/script.lua"
local script_path = thisScript().path

local badwords = {
	[1] = "àõóåíàÿ", [2] = "àõóåííàÿ", [3] = "àõóåííîå", [4] = "àõóåííî", [5] = "àõóåííóþ", [6] = "àõóåííûå", [7] = "àõóåíîå", 
	[8] = "àõóåíî", [9] = "àõóåíóþ", [10] = "àõóåíûå", [11] = "àõóåòü", [12] = "áëÿäèíà", [13] = "áëÿäü", [14] = "áëÿòü", 
	[15] = "áëÿ", [16] = "åáàëà", [17] = "çàåáàëñÿ", [18] = "åáàíàò", [19] = "åáàíàøêà", [20] = "åáàíàÿ", [21] = "åáàíóëàñü", 
	[22] = "åáàíóòàÿ", [23] = "åáàíóòñÿ", [24] = "åáàíóòüñÿ", [25] = "åáàíûé", [26] = "åáàòü", [27] = "åáëàí", [28] = "åáëåò", 
	[29] = "åáëîèä", [30] = "åáíóòüñÿ", [31] = "çàåáàë", [32] = "íàåáàë", [33] = "çàåáèñü", [34] = "çàåáîê", [35] = "ïðîåáàë", 
	[36] = "íàåáàíî", [37] = "íàåáêà", [38] = "íàõóé", [39] = "íèõóÿ", [40] = "îòïèçäèë", [41] = "îõóåëà", [42] = "îõóåë", 
	[43] = "îõóåíàÿ", [44] = "îõóåíà", [45] = "îõóåííàÿ", [46] = "îõóåííà", [47] = "îõóåííîå", [48] = "îõóåííî", [49] = "îõóåííóþ", 
	[50] = "îõóåíóþ", [51] = "îõóåíûå", [52] = "ïèäîðàç", [53] = "ïèäîðàñ", [54] = "ïèäîð", [55] = "ñïèçäàíóë", [56] = "ïèçäà", 
	[57] = "ïèçäåö", [58] = "ïèçäîøü", [59] = "ïèçäóé", [60] = "ïèçäó", [61] = "ïèçäû", [62] = "ïîõóé", [63] = "ñúåáàë", 
	[64] = "ïðîåáàíî", [65] = "ïèçäàíóë", [66] = "ñïèçäèëè", [67] = "ñïèçäèëà", [68] = "ñïèçäèë", [69] = "ñüåáàë", [70] = "åáàë", 
	[71] = "óåáàí", [72] = "óåáîê", [73] = "óåáèùå", [74] = "õóåâî", [75] = "õóåñîñ", [76] = "õóåòà", [77] = "õóèëà", 
	[78] = "õóè", [79] = "õóéíÿ", [80] = "õóéëàíçà", [81] = "õóéëî", [82] = "õóé", [83] = "õóþ", [84] = "õóÿ", [85] = "õó¸âî"
}

function apply_custom_style()

    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5.0, 3.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0
    colors[clr.Text]            		= ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]        	= ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]           		= ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[clr.ChildWindowBg]       	= ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]            		= ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]           		= colors[clr.PopupBg]
    colors[clr.Border]            		= ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]        	= ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]            		= ImVec4(0.16, 0.29, 0.48, 0.54)
    colors[clr.FrameBgHovered]      	= ImVec4(0.26, 0.39, 0.98, 0.40)
    colors[clr.FrameBgActive]       	= ImVec4(0.26, 0.39, 0.98, 0.67)
    colors[clr.TitleBg]            		= ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]       	= ImVec4(0.16, 0.29, 0.48, 1.00)
    colors[clr.TitleBgCollapsed]   		= ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.MenuBarBg]           	= ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]        		= ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]       	= ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]	= ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive] 	= ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CheckMark]           	= ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.SliderGrab]         		= ImVec4(0.24, 0.52, 0.88, 1.00)
    colors[clr.SliderGrabActive]    	= ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.Button]            		= ImVec4(0.26, 0.39, 0.98, 0.40)
    colors[clr.ButtonHovered]       	= ImVec4(0.26, 0.39, 0.98, 1.00)
    colors[clr.ButtonActive]        	= ImVec4(0.06, 0.53, 0.98, 1.00)
    colors[clr.Header]            		= ImVec4(0.26, 0.39, 0.98, 0.31)
    colors[clr.HeaderHovered]       	= ImVec4(0.26, 0.39, 0.98, 0.80)
    colors[clr.HeaderActive]        	= ImVec4(0.26, 0.39, 0.98, 1.00)
    colors[clr.Separator]           	= colors[clr.Border]
    colors[clr.SeparatorHovered]    	= ImVec4(0.26, 0.39, 0.98, 0.78)
    colors[clr.SeparatorActive]     	= ImVec4(0.26, 0.39, 0.98, 1.00)
    colors[clr.ResizeGrip]          	= ImVec4(0.26, 0.39, 0.98, 0.25)
    colors[clr.ResizeGripHovered]   	= ImVec4(0.26, 0.39, 0.98, 0.67)
    colors[clr.ResizeGripActive]    	= ImVec4(0.26, 0.39, 0.98, 0.95)
    colors[clr.CloseButton]        		= ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]  	= ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]   	= ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]           	= ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]    	= ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]       	= ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]	= ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]      	= ImVec4(0.26, 0.39, 0.98, 0.35)
    colors[clr.ModalWindowDarkening]	= ImVec4(0.80, 0.80, 0.80, 0.35)

end
apply_custom_style()

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
		downloadUrlToFile(update_url, update_path, function (id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateini = inicfg.load(nil, update_path)
				if tonumber(updateini.info.vers) > script_vers then 
					sampAddChatMessage("[AutoCensure] {F5F5DC} Íàéäåíî îáíîâëåíèå. Âåðñèÿ:{A020F0} "..updateini.info.vers_text, 0xff4500)
					update_state = true
				end
				if tonumber(updateini.info.vers) <= script_vers and not update_state then
					sampAddChatMessage("[AutoCensure] {F5F5DC} AutoCensure is written by {A020F0}Connor Laffelay", 0xff4500)
				end
				os.remove(update_path)
			end
		end)
    while true do
		wait(100)
		imgui.Process = interactive.v
		if update_state then
			downloadUrlToFile(script_url, script_path, function (id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("[AutoCensure] {F5F5DC} Îáíîâëåíèå óñïåøíî óñòàíîâëåíî.", 0xff4500)
					update_state = false
					thisScript():reload()
				end
			end)
			break
		end
		if interactive.v or ban.v or jail.v or mute.v or kick.v or warn.v then
            if not isCharInAnyCar(PLAYER_PED) then
				lockPlayerControl(true)
            end
        else
            lockPlayerControl(false)
        end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and sp_active == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_RBUTTON) then
			interactive.v = not interactive.v
			sp_active = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeO == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("./mute "..idO.." 15 íåöåíçóðíàÿ ëåêñèêà.")
			bad_activeO = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeO == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} Äåéñòâèå îòìåíåíî.", 0x9000ff)
			bad_activeO = false
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeR == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("./mute "..idR.." 15 íåöåíçóðíàÿ ëåêñèêà.")
			bad_activeR = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeR == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} Äåéñòâèå îòìåíåíî.", 0x9000ff)
			bad_activeR = false
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeF == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("./mute "..idF.." 15 íåöåíçóðíàÿ ëåêñèêà.")
			bad_activeF = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeF == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} Äåéñòâèå îòìåíåíî.", 0x9000ff)
			bad_activeF = false
		end

    end
end

function imgui.OnDrawFrame()
	local x, y = getScreenResolution()
	imgui.SetNextWindowPos(imgui.ImVec2(x / 2, y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(400, 274), imgui.Cond.FirstUseEver)
	local btn_size = imgui.ImVec2(385, 24)
	if interactive.v then
		imgui.Begin(u8"Âçàèìîäåéñòâèå ñ "..nickSP, interactive)
			if imgui.Button(u8"Çàáàíèòü", btn_size) then
				ban.v = not ban.v
			end
			if imgui.Button(u8"Ïîñàäèòü â òþðüìó", btn_size) then
				jail.v = not jail.v
			end
			if imgui.Button(u8"Âûäàòü ìóò", btn_size) then
				mute.v = not mute.v
			end
			if imgui.Button(u8"Êèêíóòü", btn_size) then
				kick.v = not kick.v
			end
			if imgui.Button(u8"Çàâàðíèòü", btn_size) then
				warn.v = not warn.v
			end
			if imgui.Button(u8"Òèõî êèêíóòü", btn_size) then
				sampSendChat("./skick "..sid)
			end
			if imgui.Button(u8"Ñëàïíóòü", btn_size) then
				sampSendMenuSelectRow(2)
				---sampSendMenuSelectRow(0)
			end 
			if imgui.Button(u8"Òåëåïîðòèðîâàòüñÿ", btn_size) then
				lua_thread.create(function()
					sampSendMenuSelectRow(0)
					wait(100)
					sampSendChat("/goto "..sid)
				end)
			end
			if imgui.Button(u8"Òåëåïîðòèðîâàòü ê ñåáå", btn_size) then
				lua_thread.create(function()
					sampSendMenuSelectRow(0)
					wait(100)
					sampSendChat("/gethere "..sid)
				end)
			end
		imgui.End()
	end
	if ban.v then
		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Çàáàíèòü", ban)
			if imgui.Button(u8"×èò", btn_size) then
				sampSendChat("./ban "..sid.." 10 ×èò")
				ban.v = not ban.v
			end
			if imgui.Button(u8"Áîò", btn_size) then
				sampSendChat("./ban "..sid.." 7 Áîò")
				ban.v = not ban.v
			end
			if imgui.Button(u8"Àèì", btn_size) then
				sampSendChat("./ban "..sid.." 15 Àèì")
				ban.v = not ban.v
			end
			if imgui.Button(u8"ÃÌ", btn_size) then
				sampSendChat("./ban "..sid.." 15 ÃÌ")
				ban.v = not ban.v
			end
			if imgui.Button(u8"ÂÕ", btn_size) then
				sampSendChat("./ban "..sid.." 15 ÂÕ")
				ban.v = not ban.v
			end
			if imgui.Button(u8"Îñêîðáëåíèå ðîäíè", btn_size) then
				sampSendChat("./ban "..sid.." 15 Îñê. ðîä.")
				ban.v = not ban.v
			end
		imgui.End()
	end
	if jail.v then
		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Ïîñàäèòü â òþðüìó", jail)
			if imgui.Button(u8"ÄÌ", btn_size) then
				sampSendChat("./jail "..sid.." 30 Äì")
				jail.v = not jail.v
			end
			if imgui.Button(u8"ÄÌ â ÇÇ", btn_size) then
				sampSendChat("./jail "..sid.." 40 Äì â çç")
				jail.v = not jail.v
			end
			if imgui.Button(u8"Ñáèâ ïåðåêàòà", btn_size) then
				sampSendChat("./jail "..sid.." 40 Ñáèâ ïåðåêàòà")
				jail.v = not jail.v
			end
			if imgui.Button(u8"Ñáèâ", btn_size) then
				sampSendChat("./jail "..sid.." 40 Ñáèâ")
				jail.v = not jail.v
			end
		imgui.End()
	end
	if mute.v then
		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Âûäàòü ìóò", mute)
			if imgui.Button(u8"Íåöåíçóðíàÿ ëåêñèêà", btn_size) then
				sampSendChat("./mute "..sid.." 15 Íåöåíçóðíàÿ ëåêñèêà")
				mute.v = not mute.v
			end
			if imgui.Button(u8"Îñêîðáëåíèÿ", btn_size) then
				sampSendChat("./mute "..sid.." 20 Îñê")
				mute.v = not mute.v
			end
			if imgui.Button(u8"Íåàäåêâàòíîñòü", btn_size) then
				sampSendChat("./mute "..sid.." 30 Íåàäåêâàò")
				mute.v = not mute.v
			end
			if imgui.Button(u8"Êàïñ", btn_size) then
				sampSendChat("./mute "..sid.." 10 Êàïñ")
				mute.v = not mute.v
			end
			if imgui.Button(u8"Ôëóä", btn_size) then
				sampSendChat("./mute "..sid.." 10 Ôëóä")
				mute.v = not mute.v
			end
			if imgui.Button(u8"Óïîìèíàíèå ðîäíè", btn_size) then
				sampSendChat("./mute "..sid.." 300 Óïîì. ðîä.")
				mute.v = not mute.v
			end
		imgui.End()
	end
	if kick.v then
		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Êèêíóòü", kick)
			if imgui.Button(u8"ÄÌ", btn_size) then
				sampSendChat("./kick "..sid.." Äì")
				kick.v = not kick.v
			end
			if imgui.Button(u8"ÄÌ êàð", btn_size) then
				sampSendChat("./kick "..sid.." Äì êàð")
				kick.v = not kick.v
			end
			if imgui.Button(u8"Ïîìåõà", btn_size) then
				sampSendChat("./kick "..sid.." Ïîìåõà")
				kick.v = not kick.v
			end
			if imgui.Button(u8"ÍîíÐÏ", btn_size) then
				sampSendChat("./kick "..sid.." ÍîíÐÏ")
				kick.v = not kick.v
			end
			if imgui.Button(u8"Áàãîþç", btn_size) then
				sampSendChat("./kick "..sid.." Áàãîþç")
				kick.v = not kick.v
			end
		imgui.End()
	end
	if warn.v then
		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Çàâàðíèòü", warn)
		if imgui.Button(u8"ÄÌ", btn_size) then
			sampSendChat("./warn "..sid.." Äì")
			warn.v = not warn.v
		end
		if imgui.Button(u8"Ñáèâ", btn_size) then
			sampSendChat("./warn "..sid.." Ñáèâ")
			warn.v = not warn.v
		end
		if imgui.Button(u8"Ñáèâ ïåðåêàòà", btn_size) then
			sampSendChat("./warn "..sid.." Ñáèâ ïåðåêàòà")
			warn.v = not warn.v
		end
		if imgui.Button(u8"Ñáèâ àïòåêè", btn_size) then
			sampSendChat("./warn "..sid.." Ñáèâ àïòåêè")
			warn.v = not warn.v
		end
		if imgui.Button(u8"+Ñ", btn_size) then
			sampSendChat("./warn "..sid.." +Ñ")
			warn.v = not warn.v
		end
		if imgui.Button(u8"Îòâîä", btn_size) then
			sampSendChat("./warn "..sid.." Îòâîä")
			warn.v = not warn.v
		end
		if imgui.Button(u8"Áàãîþç", btn_size) then
			sampSendChat("./warn "..sid.." Áàãîþç")
			warn.v = not warn.v
		end
		imgui.End()
	end
end

function sampev.onServerMessage(color, text)
	spID = text:match("%[SP%].+%[(%d+)]")
	local nckSP = sampGetPlayerNickname(spID)
	nickSP = nckSP:gsub("_", " ")
	if spID then
		sid = spID
		sp_active = true
	end
	textO, idO = text:match('%-(.+).+%[(%d+)]')
	local nckO = sampGetPlayerNickname(idO)
	local nickO = nckO:gsub("_", " ")
	if textO and idO then 
		for n, s in pairs(badwords) do
			if textO:find(s) then
				msgO = s
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nickO.." ["..idO.."] {F5F5DC}èñïîëüçîâàë çàïðåùåííîå ñëîâî:{00ffd9} "..msgO.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ×òîáû âûäàòü ìóò íàæìèòå {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, äëÿ îòìåíû {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_activeO = true
				end)
				break
			end
		end
	end
	idR, textR = text:match("%[R%].+%[(%d+)]%:(.+)")
	local nckR = sampGetPlayerNickname(idR)
	local nickR = nckR:gsub("_", " ")
	if idR and textR then 
		for q, w in pairs(badwords) do
			if textR:find(w) then
				msgR = w
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nickR.." ["..idR.."] {F5F5DC}èñïîëüçîâàë çàïðåùåííîå ñëîâî:{00ffd9} "..msgR.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ×òîáû âûäàòü ìóò íàæìèòå {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, äëÿ îòìåíû {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_activeR = true
				end)
				break
			end
		end
	end
	idF, textF = text:match("%[F%].+%[(%d+)]%:(.+)")
	local nckF = sampGetPlayerNickname(idF)
	local nickF = nckF:gsub("_", " ")
	if idF and textF then 
		for k, m in pairs(badwords) do
			if textF:find(m) then
				msgF = m
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nickF.." ["..idF.."] {F5F5DC}èñïîëüçîâàë çàïðåùåííîå ñëîâî:{00ffd9} "..msgF.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ×òîáû âûäàòü ìóò íàæìèòå {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, äëÿ îòìåíû {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_activeF = true
				end)
				break
			end
		end
	end
end

function onScriptTerminate(script, quitGame) -- îòêëþ÷åíèå ñêðèïòà
    showCursor(false)
    lockPlayerControl(false)
end
