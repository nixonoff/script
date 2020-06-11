script_name('Auto-Censure')
script_authors('Connor Laffelay')
script_description('Script for auto censuring.')
script_properties("work-in-pause")

require "lib.moonloader"
require "lib.sampfuncs"
local dlstatus = require("moonloader").download_status
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8 
local key = require 'vkeys'
local sampev = require 'lib.samp.events'

update_state = false

local script_vers = 3
local script_vers_text = "0.3"

local update_url = "https://raw.githubusercontent.com/nixonoff/script/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://raw.githubusercontent.com/nixonoff/script/master/script.lua"
local script_path = thisScript().path

local badwords = {
	[1] = "�������", [2] = "��������", [3] = "��������", [4] = "�������", [5] = "��������", [6] = "��������", [7] = "�������", 
	[8] = "������", [9] = "�������", [10] = "�������", [11] = "������", [12] = "�������", [13] = "�����", [14] = "�����", 
	[15] = "���", [16] = "�����", [17] = "��������", [18] = "������", [19] = "��������", [20] = "������", [21] = "���������", 
	[22] = "��������", [23] = "��������", [24] = "���������", [25] = "������", [26] = "�����", [27] = "�����", [28] = "�����", 
	[29] = "������", [30] = "��������", [31] = "������", [32] = "������", [33] = "�������", [34] = "������", [35] = "�������", 
	[36] = "�������", [37] = "������", [38] = "�����", [39] = "�����", [40] = "��������", [41] = "������", [42] = "�����", 
	[43] = "�������", [44] = "������", [45] = "��������", [46] = "�������", [47] = "��������", [48] = "�������", [49] = "��������", 
	[50] = "�������", [51] = "�������", [52] = "�������", [53] = "�������", [54] = "�����", [55] = "���������", [56] = "�����", 
	[57] = "������", [58] = "�������", [59] = "������", [60] = "�����", [61] = "�����", [62] = "�����", [63] = "������", 
	[64] = "��������", [65] = "��������", [66] = "��������", [67] = "��������", [68] = "�������", [69] = "������", [70] = "����", 
	[71] = "�����", [72] = "�����", [73] = "������", [74] = "�����", [75] = "������", [76] = "�����", [77] = "�����", 
	[78] = "���", [79] = "�����", [80] = "��������", [81] = "�����", [82] = "���", [83] = "���", [84] = "���", [85] = "����"
}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
		downloadUrlToFile(update_url, update_path, function (id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateini = inicfg.load(nil, update_path)
				if tonumber(updateini.info.vers) <= script_vers then
					sampAddChatMessage("[AutoCensure] {F5F5DC} AutoCensure is written by {A020F0}Connor Laffelay", 0xff4500)
				else 
					sampAddChatMessage("[AutoCensure] {F5F5DC} ������� ����������. ������:{A020F0} "..updateini.info.vers_text, 0xff4500)
					update_state = true
				end
				os.remove(update_path)
			end
		end)
    while true do
		wait(100)
		if update_state then
			downloadUrlToFile(script_url, script_path, function (id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("[AutoCensure] {F5F5DC} ���������� ������� �����������. ������� ������:{A020F0} "..script_vers_text, 0xff4500)
					thisScript():reload()
				end
			end)
			break
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active1 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("/mute "..id1.." 15 ���.")
			bad_active1 = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active1 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} �������� ��������.", 0x9000ff)
			bad_active1 = false
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active2 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("/mute "..id2.." 15 ���.")
			bad_active2 = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active2 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} �������� ��������.", 0x9000ff)
			bad_active2 = false
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active3 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("/mute "..id3.." 15 ���.")
			bad_active3 = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active3 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} �������� ��������.", 0x9000ff)
			bad_active3 = false
		end

    end
end

function sampev.onServerMessage(color, text)
	text1, id1 = text:match('(.+).+%[(%d+)]')
	local nck1 = sampGetPlayerNickname(id1)
	local nick1 = nck1:gsub("_", " ")
	if text1 and id1 then 
		for n, s in pairs(badwords) do
			if text1:find(s) then
				msg1 = s
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nick1.." ["..id1.."] {F5F5DC}����������� ����������� �����:{00ffd9} "..msg1.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ����� ������ ��� ������� {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, ��� ������ {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_active1 = true
				end)
				break
			end
		end
	end
	id2, text2 = text:match("%[R%].+%[(%d+)]%:(.+)")
	local nck2 = sampGetPlayerNickname(id2)
	local nick2 = nck2:gsub("_", " ")
	if id2 and text2 then 
		for q, w in pairs(badwords) do
			if text2:find(w) then
				msg2 = w
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nick2.." ["..id2.."] {F5F5DC}����������� ����������� �����:{00ffd9} "..msg2.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ����� ������ ��� ������� {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, ��� ������ {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_active2 = true
				end)
				break
			end
		end
	end
	id3, text3 = text:match("%[F%].+%[(%d+)]%:(.+)")
	local nck3 = sampGetPlayerNickname(id3)
	local nick3 = nck3:gsub("_", " ")
	if id3 and text3 then 
		for k, m in pairs(badwords) do
			if text3:find(m) then
				msg3 = m
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nick3.." ["..id3.."] {F5F5DC}����������� ����������� �����:{00ffd9} "..msg3.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} ����� ������ ��� ������� {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, ��� ������ {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_active3 = true
				end)
				break
			end
		end
	end
end