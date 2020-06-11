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
	[1] = "ахуеная", [2] = "ахуенная", [3] = "ахуенное", [4] = "ахуенно", [5] = "ахуенную", [6] = "ахуенные", [7] = "ахуеное", 
	[8] = "ахуено", [9] = "ахуеную", [10] = "ахуеные", [11] = "ахуеть", [12] = "блядина", [13] = "блядь", [14] = "блять", 
	[15] = "бля", [16] = "ебала", [17] = "заебался", [18] = "ебанат", [19] = "ебанашка", [20] = "ебаная", [21] = "ебанулась", 
	[22] = "ебанутая", [23] = "ебанутся", [24] = "ебануться", [25] = "ебаный", [26] = "ебать", [27] = "еблан", [28] = "еблет", 
	[29] = "еблоид", [30] = "ебнуться", [31] = "заебал", [32] = "наебал", [33] = "заебись", [34] = "заебок", [35] = "проебал", 
	[36] = "наебано", [37] = "наебка", [38] = "нахуй", [39] = "нихуя", [40] = "отпиздил", [41] = "охуела", [42] = "охуел", 
	[43] = "охуеная", [44] = "охуена", [45] = "охуенная", [46] = "охуенна", [47] = "охуенное", [48] = "охуенно", [49] = "охуенную", 
	[50] = "охуеную", [51] = "охуеные", [52] = "пидораз", [53] = "пидорас", [54] = "пидор", [55] = "спизданул", [56] = "пизда", 
	[57] = "пиздец", [58] = "пиздошь", [59] = "пиздуй", [60] = "пизду", [61] = "пизды", [62] = "похуй", [63] = "съебал", 
	[64] = "проебано", [65] = "пизданул", [66] = "спиздили", [67] = "спиздила", [68] = "спиздил", [69] = "сьебал", [70] = "ебал", 
	[71] = "уебан", [72] = "уебок", [73] = "уебище", [74] = "хуево", [75] = "хуесос", [76] = "хуета", [77] = "хуила", 
	[78] = "хуи", [79] = "хуйня", [80] = "хуйланза", [81] = "хуйло", [82] = "хуй", [83] = "хую", [84] = "хуя", [85] = "хуёво"
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
					sampAddChatMessage("[AutoCensure] {F5F5DC} Найдено обновление. Версия:{A020F0} "..updateini.info.vers_text, 0xff4500)
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
					sampAddChatMessage("[AutoCensure] {F5F5DC} Обновление успешно установлено. Текущая версия:{A020F0} "..script_vers_text, 0xff4500)
					thisScript():reload()
				end
			end)
			break
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active1 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("/mute "..id1.." 15 мат.")
			bad_active1 = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active1 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} Действие отменено.", 0x9000ff)
			bad_active1 = false
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active2 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("/mute "..id2.." 15 мат.")
			bad_active2 = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active2 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} Действие отменено.", 0x9000ff)
			bad_active2 = false
		end

		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active3 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_Y) then
			sampSendChat("/mute "..id3.." 15 мат.")
			bad_active3 = false
		end
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and bad_active3 == true and isKeyDown(VK_MENU) and isKeyJustPressed(VK_N) then
			sampAddChatMessage("[AutoCensure]{F5F5DC} Действие отменено.", 0x9000ff)
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
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nick1.." ["..id1.."] {F5F5DC}использовал запрещенное слово:{00ffd9} "..msg1.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} Чтобы выдать мут нажмите {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, для отмены {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
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
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nick2.." ["..id2.."] {F5F5DC}использовал запрещенное слово:{00ffd9} "..msg2.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} Чтобы выдать мут нажмите {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, для отмены {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
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
					sampAddChatMessage("[AutoCensure]{F5F5DC} {00ffd9} "..nick3.." ["..id3.."] {F5F5DC}использовал запрещенное слово:{00ffd9} "..msg3.."!", 0x9000ff)
					sampAddChatMessage("[AutoCensure]{F5F5DC} Чтобы выдать мут нажмите {008f02}Alt{F5F5DC}+{008f02}Y{F5F5DC}, для отмены {ab0000}Alt{F5F5DC}+{ab0000}N", 0x9000ff)
					bad_active3 = true
				end)
				break
			end
		end
	end
end