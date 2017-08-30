--[[
	Missing: Colourize Health Bars, Announce Interrupts, Style Chat Bubbles, Hide Chat Arrows, ImpBlizzardUI, Auto-Hide Quest Tracker, Highlight Killing Blows, PvP, Minify Blizzard Strings, Style Chat, Action Bars, Casting Bar Timer, Out of Range Indicator, Hide Portrait Spam
]]

local _, ImpBlizz = ...;

-- Set To ruRu
if( GetLocale() == "ruRU" )then

	-- Micro Menu
	ImpBlizz["Character"] = "Персонаж";
	ImpBlizz["Spellbook"] = "Способности";
	ImpBlizz["Talents"] = "Таланты";
	ImpBlizz["Achievements"] = "Достижения";
	ImpBlizz["Quest Log"] = "Журнал заданий";
	ImpBlizz["Guild"] = "Гильдия";
	ImpBlizz["Group Finder"] = "Поиск группы";
	ImpBlizz["Collections"] = "Коллекции";
	ImpBlizz["Adventure Guide"] = "Руководство Приключения";
	ImpBlizz["Shop"] = "Лавка";
	ImpBlizz["Swap Bags"] = "Переместить сумки";
	ImpBlizz["Log Out"] = "Выход из мира";
	ImpBlizz["Force Exit"] = "Выход из игры";

	-- Merchant
	ImpBlizz["Items Repaired from Guild Bank"] = "Вещи починены с помощью гильдейского банка";
	ImpBlizz["Can not Repair from Guild Bank"] = "Невозможно починить вещи с помощью гильдейского банка";
	ImpBlizz["Items Repaired from Own Money"] = "Вещи починены с затратами собственных денег";
	ImpBlizz["Sold Trash Items"] = "Продан ненужный хлам";

	-- Combat
	ImpBlizz[" killed "] = " Убит ";
	ImpBlizz["Killing Blow!"] = "Мертв";
	ImpBlizz["HP < 50% !"] = "Здоровье ниже < 50% !";
	ImpBlizz["HP < 25% !!!"] = "Здоровье ниже < 25% !!!";

	-- Config Headers
	ImpBlizz["Combat"] = "Бой";
	ImpBlizz["Miscellaneous"] = "Смешанный";
	ImpBlizz["User Interface"] = "Пользовательский интерфейс";

	-- Config Options
	ImpBlizz["Display Class Icon"] = "Отображать классовую иконку";
	ImpBlizz["Display Health Warnings"] = "Сообщать о количестве здоровья";
	ImpBlizz["Display PvP Kill Tracker"] = "Отслеживать убийство игроков";
	ImpBlizz["Display Class Colours"] = "Раскрасить здоровье под цвета классов";
	ImpBlizz["Auto Repair"] = "Авто починка";
	ImpBlizz["Use Guild Bank For Repairs"] = "Использовать гильдейский банк для починки";
	ImpBlizz["Auto Sell Trash"] = "Авто продажа хлама";
	ImpBlizz["AFK Mode"] = "АФК 3D модель";
	ImpBlizz["Display System Statistics"] = "Отображать пинг и фпс";
	ImpBlizz["Display Player Co-Ordinates"] = "Отображать координаты";
	ImpBlizz["Display Art"] = "Отображать грифонов снизу";
end
