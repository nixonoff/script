script_name('Auto-Censure')
script_authors('Connor Laffelay')
script_description('Script for auto censuring.')

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

local script_vers = 8
local script_vers_text = "0.8"

local update_url = "https://raw.githubusercontent.com/nixonoff/script/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://raw.githubusercontent.com/nixonoff/script/master/script.lua"
local script_path = thisScript().path

local badwords = {
	[1] = "�������", [2] = "��������", [3] = "��������", [4] = "�������", [5] = "��������", [6] = "��������", [7] = "�������", 
	[8] = "������", [9] = "�������", [10] = "�������", [11] = "������", [12] = "�������", [13] = "�����", [14] = "�����", 
	[15] = "�����", [16] = "�����", [17] = "��������", [18] = "������", [19] = "��������", [20] = "������", [21] = "���������", 
	[22] = "��������", [23] = "��������", [24] = "���������", [25] = "������", [26] = "�����", [27] = "�����", [28] = "�����", 
	[29] = "������", [30] = "��������", [31] = "������", [32] = "������", [33] = "�������", [34] = "������", [35] = "�������", 
	[36] = "�������", [37] = "������", [38] = "�����", [39] = "�����", [40] = "��������", [41] = "������", [42] = "�����", 
	[43] = "�������", [44] = "������", [45] = "��������", [46] = "�������", [47] = "��������", [48] = "�������", [49] = "��������", 
	[50] = "�������", [51] = "�������", [52] = "�������", [53] = "�������", [54] = "�����", [55] = "���������", [56] = "�����", 
	[57] = "������", [58] = "�������", [59] = "������", [60] = "�����", [61] = "�����", [62] = "�����", [63] = "������", 
	[64] = "��������", [65] = "��������", [66] = "��������", [67] = "��������", [68] = "�������", [69] = "������", [70] = "����", 
	[71] = "�����", [72] = "�����", [73] = "������", [74] = "�����", [75] = "������", [76] = "�����", [77] = "�����", 
	[78] = "���", [79] = "�����", [80] = "��������", [81] = "�����", [82] = "���", [83] = "���", [84] = "���", [85] = "����", [86] = "���"
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
		sampRegisterChatCommand("sinfo", function()
			sampShowDialog(24345, "{edce00}��� ����������", "{ed8e00}v.0.8 {c9c9c7}- ���������� ����������� �������� � ���� ��������������.\n{ed8e00}v.0.7 {c9c9c7}- �������� ��� ����������(/sinfo).\n{ed8e00}v.0.6 {c9c9c7}- ����������� ������.\n{ed8e00}v.0.5 {c9c9c7}- ���������� �������������� ���� � /sp.\n{ed8e00}v.0.4 {c9c9c7}- ����������� ������ �������������� � ���������.\n{ed8e00}v.0.3 {c9c9c7}- ��������� ��������������.\n{ed8e00}v.0.2 {c9c9c7}- ����������� ������ � ���������� ����� �����.\n{ed8e00}v.0.1 {c9c9c7}- ������ �������.", "�������", "", 0)
		end)
		downloadUrlToFile(update_url, update_path, function (id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateini = inicfg.load(nil, update_path)
				if tonumber(updateini.info.vers) > script_vers then 
					sampAddChatMessage("[AutoCensure] {F5F5DC} ������� ����������. ������:{A020F0} "..updateini.info.vers_text, 0xff4500)
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
					sampAddChatMessage("[AutoCensure] {F5F5DC} ���������� ������� ����������� ({A020F0}/sinfo{F5F5DC}).", 0xff4500)
					update_state = false
					thisScript():reload()
				end
			end)
			break
		end


		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and sp_active == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_RBUTTON) then
			interactive.v = not interactive.v
			sp_active = false
		end


		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeO == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("./mute "..idO.." 15 ����������� �������.")
			bad_activeO = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeO == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} �������� ��������.", 0x9000ff)
			bad_activeO = false
		end


		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeR == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("./mute "..idR.." 15 ����������� �������.")
			bad_activeR = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeR == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} �������� ��������.", 0x9000ff)
			bad_activeR = false
		end


		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeF == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("./mute "..idF.." 15 ����������� �������.")
			bad_activeF = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_activeF == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} �������� ��������.", 0x9000ff)
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

		imgui.Begin(u8"�������������� � "..nickSP.." ["..spID.."]", interactive)
			if imgui.Button(u8"��������", btn_size) then
				ban.v = not ban.v
			end
			if imgui.Button(u8"�������� � ������", btn_size) then
				jail.v = not jail.v
			end
			if imgui.Button(u8"������ ���", btn_size) then
				mute.v = not mute.v
			end
			if imgui.Button(u8"�������", btn_size) then
				kick.v = not kick.v
			end
			if imgui.Button(u8"���������", btn_size) then
				warn.v = not warn.v
			end
			if imgui.Button(u8"���� �������", btn_size) then
				sampSendChat("/skick "..sid)
			end
			if imgui.Button(u8"��������", btn_size) then
				sampSendMenuSelectRow(2)
			end 
			if imgui.Button(u8"�����������������", btn_size) then
				lua_thread.create(function()
					sampSendMenuSelectRow(0)
					wait(100)
					sampSendChat("/goto "..sid)
				end)
			end
			if imgui.Button(u8"��������������� � ����", btn_size) then
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
		imgui.Begin(u8"��������", ban)
			if imgui.Button(u8"���", btn_size) then
				sampSendChat("/ban "..sid.." 10 ���")
				ban.v = not ban.v
			end
			if imgui.Button(u8"���", btn_size) then
				sampSendChat("/ban "..sid.." 7 ���")
				ban.v = not ban.v
			end
			if imgui.Button(u8"���", btn_size) then
				sampSendChat("/ban "..sid.." 15 ���")
				ban.v = not ban.v
			end
			if imgui.Button(u8"��", btn_size) then
				sampSendChat("/ban "..sid.." 15 ��")
				ban.v = not ban.v
			end
			if imgui.Button(u8"��", btn_size) then
				sampSendChat("/ban "..sid.." 15 ��")
				ban.v = not ban.v
			end
			if imgui.Button(u8"����������� �����", btn_size) then
				sampSendChat("/ban "..sid.." 15 ���. ���.")
				ban.v = not ban.v
			end
		imgui.End()
	end


	if jail.v then

		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"�������� � ������", jail)
			if imgui.Button(u8"��", btn_size) then
				sampSendChat("/jail "..sid.." 30 ��")
				jail.v = not jail.v
			end
			if imgui.Button(u8"�� � ��", btn_size) then
				sampSendChat("/jail "..sid.." 40 �� � ��")
				jail.v = not jail.v
			end
			if imgui.Button(u8"���� ��������", btn_size) then
				sampSendChat("/jail "..sid.." 40 ���� ��������")
				jail.v = not jail.v
			end
			if imgui.Button(u8"����", btn_size) then
				sampSendChat("/jail "..sid.." 40 ����")
				jail.v = not jail.v
			end
		imgui.End()
	end


	if mute.v then

		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"������ ���", mute)
			if imgui.Button(u8"����������� �������", btn_size) then
				sampSendChat("/mute "..sid.." 15 ����������� �������")
				mute.v = not mute.v
			end
			if imgui.Button(u8"�����������", btn_size) then
				sampSendChat("/mute "..sid.." 20 ���")
				mute.v = not mute.v
			end
			if imgui.Button(u8"��������������", btn_size) then
				sampSendChat("/mute "..sid.." 30 ���������")
				mute.v = not mute.v
			end
			if imgui.Button(u8"����", btn_size) then
				sampSendChat("/mute "..sid.." 10 ����")
				mute.v = not mute.v
			end
			if imgui.Button(u8"����", btn_size) then
				sampSendChat("/mute "..sid.." 10 ����")
				mute.v = not mute.v
			end
			if imgui.Button(u8"���������� �����", btn_size) then
				sampSendChat("/mute "..sid.." 300 ����. ���.")
				mute.v = not mute.v
			end
		imgui.End()
	end


	if kick.v then

		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"�������", kick)
			if imgui.Button(u8"��", btn_size) then
				sampSendChat("/kick "..sid.." ��")
				kick.v = not kick.v
			end
			if imgui.Button(u8"�� ���", btn_size) then
				sampSendChat("/kick "..sid.." �� ���")
				kick.v = not kick.v
			end
			if imgui.Button(u8"������", btn_size) then
				sampSendChat("/kick "..sid.." ������")
				kick.v = not kick.v
			end
			if imgui.Button(u8"�����", btn_size) then
				sampSendChat("/kick "..sid.." �����")
				kick.v = not kick.v
			end
			if imgui.Button(u8"������", btn_size) then
				sampSendChat("/kick "..sid.." ������")
				kick.v = not kick.v
			end
		imgui.End()
	end


	if warn.v then

		imgui.SetNextWindowPos(imgui.ImVec2((x / 1.5), y / 2.95), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"���������", warn)
		if imgui.Button(u8"��", btn_size) then
			sampSendChat("/warn "..sid.." ��")
			warn.v = not warn.v
		end
		if imgui.Button(u8"����", btn_size) then
			sampSendChat("/warn "..sid.." ����")
			warn.v = not warn.v
		end
		if imgui.Button(u8"���� ��������", btn_size) then
			sampSendChat("/warn "..sid.." ���� ��������")
			warn.v = not warn.v
		end
		if imgui.Button(u8"���� ������", btn_size) then
			sampSendChat("/warn "..sid.." ���� ������")
			warn.v = not warn.v
		end
		if imgui.Button(u8"+�", btn_size) then
			sampSendChat("/warn "..sid.." +�")
			warn.v = not warn.v
		end
		if imgui.Button(u8"�����", btn_size) then
			sampSendChat("/warn "..sid.." �����")
			warn.v = not warn.v
		end
		if imgui.Button(u8"������", btn_size) then
			sampSendChat("/warn "..sid.." ������")
			warn.v = not warn.v
		end
		imgui.End()
	end


end

function sampev.onServerMessage(color, text)

	--[[spID = text:match("%[SP%].+%[(%d+)]")
	nckSP = sampGetPlayerNickname(spID)
	nickSP = nckSP:gsub("_", " ")
	if spID then
		sid = spID
		sp_active = true
	end]]


	textO, idO = text:match('%-(.+).+%[(%d+)]')
	local nckO = sampGetPlayerNickname(idO)
	local nickO = nckO:gsub("_", " ")
	if textO and idO then 
		for n, s in pairs(badwords) do
			if textO:find(s) then
				msgO = s
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nickO.." ["..idO.."] {F5F5DC}����������� ����������� �����:{00ffd9} "..msgO.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ����� ������ ��� ������� {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, ��� ������ {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
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
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nickR.." ["..idR.."] {F5F5DC}����������� ����������� �����:{00ffd9} "..msgR.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ����� ������ ��� ������� {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, ��� ������ {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
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
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nickF.." ["..idF.."] {F5F5DC}����������� ����������� �����:{00ffd9} "..msgF.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ����� ������ ��� ������� {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, ��� ������ {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_activeF = true
				end)
				break
			end
		end
	end


end

function sampev.onSendCommand(cmd)
	spID = cmd:match("%/sp (%d+)")
	nckSP = sampGetPlayerNickname(spID)
	nickSP = nckSP:gsub("_", " ")
	if spID ~= nil or spID ~= "" then
		sp_active = true
	end
end

function onScriptTerminate(script, quitGame) -- ���������� �������

    showCursor(false)
	lockPlayerControl(false)
	
end