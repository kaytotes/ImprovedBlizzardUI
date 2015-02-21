local _, imp = ...;

-- Set To ruRu
if( GetLocale() == "ruRU" )then

	-- Micro Menu
	imp["Character"] = "Персонаж";
	imp["Spellbook"] = "Способности";
	imp["Talents"] = "Таланты";
	imp["Achievements"] = "Достижения";
	imp["Quest Log"] = "Журнал заданий";
	imp["Guild"] = "Гильдия";
	imp["Group Finder"] = "Поиск группы";
	imp["Collections"] = "Коллекции";
	imp["Dungeon Journal"] = "Атлас подземелий";
	imp["Swap Bags"] = "Переместить сумки";
	imp["BlizzImp Options"] = "BlizzImp oпции"
	imp["Log Out"] = "Выход из мира";
	imp["Force Exit"] = "Выход из игры";

	-- Merchant
	imp["Items Repaired from Guild Bank"] = "Вещи починены с помощью гильдейского банка";
	imp["Can not Repair from Guild Bank"] = "Невозможно починить вещи с помощью гильдейского банка";
	imp["Items Repaired from Own Money"] = "Вещи починены с затратами собственных денег";
	imp["Sold Trash Items"] = "Продан ненужный хлам";

	-- Combat
	imp[" killed "] = " Убит ";
	imp["Killing Blow!"] = "Мертв";
	imp["HP < 50% !"] = "Здоровье ниже < 50% !";
	imp["HP < 25% !!!"] = "Здоровье ниже < 25% !!!";

	-- Config Headers
	imp["Combat"] = "Бой";
	imp["Miscellaneous"] = "Смешанный";
	imp["User Interface"] = "Пользовательский интерфейс";
	imp["Chat"] = "Chat"; -- NEEDS LOCALIZATION

	-- Config Options
	imp["Display Class Icon"] = "Отображать классовую иконку";
	imp["Display Health Warnings"] = "Сообщать о количестве здоровья";
	imp["Display PvP Kill Tracker"] = "Отслеживать убийство игроков";
	imp["Display PvP Killing Blow Indicator"] = "Отображать надпись Убит";
	imp["Display Class Colours"] = "Раскрасить здоровье под цвета классов";
	imp["Auto Repair"] = "Авто починка";
	imp["Use Guild Bank For Repairs"] = "Использовать гильдейский банк для починки";
	imp["Auto Sell Trash"] = "Авто продажа хлама";
	imp["AFK Mode"] = "АФК 3D модель";
	imp["Display System Statistics"] = "Отображать пинг и фпс";
	imp["Display Player Co-Ordinates"] = "Отображать координаты";
	imp["Display Art"] = "Отображать грифонов снизу";
	imp["Modify Chat"] = "Modify Chat"; -- NEEDS LOCALIZATION
end