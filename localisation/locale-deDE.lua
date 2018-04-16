--[[
    localisation\template.lua

    The template that all other localisation files hould be based off of.
]]
local _, Loc = ...;

--[[
    'frFR' French (France)
    'deDE' German (Germany)
    'enGB  English (Great Brittan) if returned, can substitute 'enUS' for consistancy
    'enUS' English (America)
    'itIT' Italian (Italy)
    'koKR' Korean (Korea) RTL - right-to-left
    'zhCN' Chinese (China) (simplified) implemented LTR left-to-right in WoW
    'zhTW' Chinese (Taiwan) (traditional) implemented LTR left-to-right in WoW
    'ruRU' Russian (Russia)
    'esES' Spanish (Spain)
    'esMX' Spanish (Mexico)
    'ptBR' Portuguese (Brazil)
]]
if (GetLocale() == 'deDE') then

    -- Configuration
    Loc['Miscellaneous'] = 'Verschiedenes';

    Loc['Enable AFK Mode'] = 'Aktiviere AFK Modus';
    Loc['After you go AFK the interface will fade away, pan your camera and display your Character in all their glory.'] = 'Nachdem du AFK gehst, wird das Interface ausgeblendet, die Kamera wird gedreht und dein Charakter wird in gesamter Größe angezeigt.';

    Loc['Auto Repair'] = 'Automatisches Reparieren.';
    Loc['Automatically repairs your armour when you visit a merchant that can repair.'] = 'Repariert automatisch deine Rüstung wenn du einen Händler ansprichst, der reparieren kann.';
    Loc['Items Repaired'] = 'Ausrüstung wurde repariert.';

    Loc['Use Guild Bank For Repairs'] = 'Verwende Gildenbank zum Reparieren.';
    Loc['When automatically repairing allow the use of Guild Bank funds.'] = 'Wenn automatisch repariert wird, erlaube die Nutzung des Gildenbankkapitals.';
    Loc['Items Repaired from Guild Bank'] = 'Ausrüstung wurde repariert von der Gildenbank.';

    Loc['Auto Sell Trash'] = 'Verkaufe automatisch Schrott.';
    Loc['Automatically sells any grey items that are in your inventory.'] = 'Verkaufe automatisch alle grauchen Items, die sich in deinem Inventar befinden.';
    Loc['Sold Trash Items'] = 'Schrott wurde verkauft.';

    Loc['Dynamic Objective Tracker'] = 'Dynamische Quest-Zielanzeige';
    Loc['When you enter an instanced area the Objective Tracker will automatically close.'] = 'Wenn du eine Instanz betrittst, wird die dynamische Quest-Zielanzeige automatisch geschlossen.';

    Loc['Chat'] = 'Chat';

    Loc['Style Chat'] = 'Chat gestalten.';
    Loc['Styles the Blizzard Chat frame to better match the rest of the UI'] = 'Gestaltet den Chat, um dem rest des Interfaces besser zu entsprechen.';

    Loc['Minify Blizzard Strings'] = 'Verkürzen von Blizzard Nachrichten.';
    Loc['Shortens chat messages such as Loot Received, Exp Gain, Skill Gain and Chat Channels.'] = 'Verkürzt Chat Nachrichten, wie Ausrüstung erhalten, Erfahrung gewonnen, Fähigkeit erhöht und Chat Channel beigetreten.';

    -- Combat Strings
    Loc['Combat'] = 'Kampf';

    Loc['Display Health Warnings'] = 'Zeige Warnungen zum Lebensstand';
    Loc['Displays a five second warning when Player Health is less than 50% and 25%.'] = 'Zeige 5 Sekunden eine Warnung, wenn die Spielergesundheit weniger als 50% und als 25% beträgt.';
    Loc['HP < 50% !'] = 'LP < 50% !';
    Loc['HP < 25% !!!'] = 'LP < 25% !!!';

    Loc['Frames'] = 'Anzeige';

    Loc['Primary'] = 'Grundlegend';

    Loc['Style Unit Frames'] = 'Gestalte Spieler Anzeige.';
    Loc['Tweaks textures and structure of Unit Frames.'] = 'Optimiert Texturen und Strukturen der Spieler Anzeigen.';
    Loc['Player and Target Frame Scale'] = 'Spieler und Ziel Anzeige Skalierung.';
    
    Loc['Player Frame'] = 'Spieler Anzeige';
    Loc['Display Class Colours'] = 'Zeige Klassenfarben';
    Loc['Colours your Health bar to match the current class.'] = 'Färbe deine Lebensleiste in der Farbe deiner aktuellen Klasse.';
    
    Loc['Hide Portrait Spam'] = 'Verstecke Portrait Spam.';
    Loc['Hides the damage text that appears over the Player portrait when damaged or healed.'] = 'Verstecke den Schadenstext, der über dem Spielerportrait erscheint wenn dieser Schaden erleidet oder geheilt wird.';
    Loc['Hide Out of Combat'] = 'Verstecke Anzeige außerhalb des Kampfes.';
    Loc['Hides the Player Frame when you are out of combat, have no target and are at full health.'] = 'Versteckt die Spieleranzeige wenn du außerhalb des Kampfes bist, kein Ziel gewählt hast und volles Leben hast.';

    Loc['Target Frame'] = 'Ziel Anzeige';
    Loc['Colours Target Health bar to match their class.'] = 'Färbe die Lebensleiste deines Ziels in der Farbe der jeweiligen Klasse.';
    Loc['Buffs On Top'] = 'Stärkungszauber oben';
    Loc['Displays the Targets Buffs above the Unit Frame.'] = 'Zeige die Stärkungszauber oben an der Zielanzeige an.';

    Loc['Target of Target Frame'] = 'Ziel des Ziels Anzeige';
    Loc['Colours Target of Target Health bar to match their class.'] = 'Färbe die Ziel des Ziels Anzeige in der Farbe der jeweiligen Klasse.';

    Loc['Focus Frame'] = 'Fokus Anzeige';
    Loc['Colours Focus Health bar to match their class.'] = 'Färbe die Fokus Anzeige in der Farbe der jeweiligen Klasse.';

    Loc['Action Bars'] = 'Aktionsleisten';

    Loc['Cast Bars'] = 'Zauberleisten';
    Loc['Cast Bar Timer'] = 'Zauberleisten Zähler';
    Loc['Adds a timer in seconds above the Cast Bar.'] = 'Fügt der Zauberleiste des Spielers oberhalb einen Zähler in Sekunden hinzu.';
    Loc['Cast Bar Scale'] = 'Zauberleisten Skalierung.';
    Loc['Target Cast Bar Timer'] = 'Ziel Zauberleisten Zähler';
    Loc["Adds a timer in seconds above the Target's Cast Bar."] = 'Fügt der Zauberleiste des Ziels oberhalb einen Zähler in Sekunden hinzu.';
    Loc['Focus Cast Bar Timer'] = 'Fokus Zauberleisten Zähler';
    Loc["Adds a timer in seconds above the Focus' Cast Bar."] = 'Fügt der Zauberleiste des Fokus oberhalb einen Zähler in Sekunden hinzu.';

    Loc['Out of Range Indicator'] = 'Reichweitenanzeige';
    Loc['When an Ability is not usable due to range the entire Button is highlighted Red.'] = 'Wenn eine Fähigkeit nicht benutzbar ist aufgrund der Reichweite, färbe diese rot.';
    
    Loc['Disabling Hides Macro Name Text and Hotkey Text from the specified Action Bar'] = 'Versteckt den Makro Namenstext und Schnelltastentext von der jeweiligen Aktionsleiste.';
    Loc['Show Main Action Bar Text'] = 'Zeige Hauptaktionsleistentext';
    Loc['Show Bottom Left Bar Text'] = 'Zeige unteren linken Leistentext';
    Loc['Show Bottom Right Bar Text'] = 'Zeige unteren rechten Leistentext';
    Loc['Show Right 1 Bar Text'] = 'Zeige Rechte Leiste 1 Text';
    Loc['Show Right 2 Bar Text'] = 'Zeige Rechte Leiste 2 Text';
    Loc['Show Art'] = 'Zeige Texturen';
    Loc['Toggling Hides the Action Bar Texture.'] = 'Versteckt die Hauptleistentexturen.';
    
    Loc['Action Bar Scale'] = 'Aktionsleisten Skalierung';

    Loc['Buffs and Debuffs'] = 'Stärkungs- und Schwächungszauber';
    Loc['Buffs and Debuffs Scale'] = 'Stärkungs- und Schwächungszauber Skalierung';

    Loc['Announce Interrupts'] = 'Verkünde Unterbrechungen';
    Loc['When you interrupt a target your character announces this to an appropriate sound channel.'] = 'Wenn ein Zauber unterbrochen wird durch dich, wird dies im entsprechenden Kanal verkündet.';

    Loc['Mini Map'] = 'Minikarte';
    Loc['Display Player Co-Ordinates'] = 'Zeige Spieler Koordinaten';
    Loc['Adds a frame to the Mini Map showing the players location in the world. Does not work in Dungeons.'] = 'Fügt der Minikarte eine Anzeige hinzu, die den Standort des Charakters in der Welt als Koordinate anzeigt. Funktioniert nicht in Instanzen.';

    Loc['Display System Statistics'] = 'Zeige System Statistiken';
    Loc['Displays FPS and Latency above the Mini Map.'] = 'Zeige Framerate und Latenz über der Minikarte an.';

    Loc['Replace Zoom Functionality'] = 'Ersetze Zoom Funktionalität';
    Loc['Hides the Zoom Buttons and enables scroll wheel zooming.'] = 'Versteckt die Zoom Knöpfe und erlaubt zoomen per Mausrad.';

    Loc['World Map'] = 'Weltkarte';

    Loc['Show Instance Portals'] = 'Zeige Instanzportale';
    Loc['Displays the location of old world Raids and Dungeons.'] = 'Zeige die Orte von alten Schlachtzügen und Instanzen an.';

    Loc['Show Cursor Co-ordinates'] = 'Zeige Cursor Koordinaten';
    Loc['Displays the world location of where you are highlighting.'] = 'Zeige den Ort an dem du dich befindest hervorgehoben an.';

    Loc['PvP'] = 'PvP';
    Loc['Highlight Killing Blows'] = 'Hebe Todesstöße hervor.';
    Loc['When you get a Killing Blow in a Battleground or Arena this will be displayed prominently in the center of the screen.'] = 'Wenn du einen Todesstoß ausführst in einem Schlachtfeld oder einer Arena, wird dieser in der Mitte des Bildschirms groß angezeigt.';
    Loc['Killing Blow!'] = 'Todesstoß!';

    Loc['Automatic Ressurection'] = 'Automatisches Wiederbeleben.';
    Loc['When you die in a Battleground you are automatically ressurected.'] = 'Wenn du in einem Schlachtfeld stirbst, wirst du automatisch wiederbelebt.';

    Loc['Character'] = 'Charakterinfo';
    Loc['Spellbook'] = 'Zauberbuch';
    Loc['Talents'] = 'Talente';
    Loc['Achievements'] = 'Erfolge';
    Loc['Quest Log'] = 'Questlog';
    Loc['Guild'] = 'Gilde';
    Loc['Group Finder'] = 'Dungeonbrowser';
    Loc['PvP'] = 'PvP';
    Loc['Collections'] = 'Sammlungen';
    Loc['Adventure Guide'] = 'Abenteuerführer';
    Loc['Shop'] = 'Shop';
    Loc['Swap Bags'] = 'Tausche Taschen';
    Loc['Talents now available under the Minimap Right-Click Menu!'] = 'Talente sind nun über die Minikarte erreichbar (Rechtsklickmenü)!';
    Loc['Group Finder and Adventure Guide now available under the Minimap Right-Click Menu!'] = 'Dungeonbrowser und Abenteuerführer sind nun über die Minikarte erreichbar (Rechtsklickmenü)!';

    Loc['Target'] = 'Ziel';
    Loc['Trivial'] = 'Gewöhnlich';
    Loc['Normal'] = 'Normal';
    Loc['Rare'] = 'Rar';
    Loc['Elite'] = 'Elite';
    Loc['Rare Elite'] = 'Rar Elite';
    Loc['World Boss'] = 'Weltboss';

    Loc['Tooltips'] = 'Tooltip';
    Loc['Anchor To Mouse'] = 'An Mauszeiger heften.';
    Loc['The Tooltip will always display at the mouse location.'] = 'Der Tooltip wird immer am Mauszeiger angezeigt.';

    Loc['Style Tooltips'] = 'Gestalte Tooltip';
    Loc['Adjusts the Fonts and behavior of the default Tooltips.'] = 'Verändert die Schriftart und das Verhalten der allgemeinen Tooltips.';
    
    Loc['Guild Colour'] = 'Gildenfarbe';

    Loc['Hostile Border'] = 'Verfeindeter Rahmen';
    Loc['Colours the Border of the Tooltip based on the hostility of the target.'] = 'Färbt den Rand des Tooltips basierend von der feindlichkeit des Ziels.';

    Loc['Class Coloured Name'] = 'Name in Klassenfarbe';
    Loc['Colours the name of the Target to match their Class.'] = 'Färbt den Namen des Ziels in der jeweiligen Klassenfarbe.';

    Loc['Show Target of Target'] = 'Zeige Ziel des Ziels.';
    Loc['Displays who / what the unit is targeting. Coloured by Class.'] = 'Zeigt wen/was das Ziel gerade im Ziel hat. Gefärbt nach der Klasse.';
    
    Loc['Class Colour Health Bar'] = 'Lebensbalken in Klassenfarbe';
    Loc['Colours the Tooltip Health Bar by Class.'] = 'Färbt den Lebensbalken des Tooltips in der jeweiligen Klassenfarbe.';

    Loc['Achievement Screenshot'] = 'Bildschirmfoto bei Erfolg';
    Loc['Automatically take a screenshot upon earning an achievement.'] = 'Schießt automatisch beim erreichen eines Erfolges ein Bildschirmfoto.';

    Loc['Kill Feed'] = 'Todesmelder';

    Loc['Enable Kill Feed'] = 'Schalte den Todesmelder ein.';
    Loc['Displays a feed of the last 5 kills that occur around you when in Instances and optionally out in the World.'] = 'Zeigt einen Melder von den letzten 5 Todesstößen an der in der Welt um dich herum passiert, in Instanzen und wenn eingeschaltet auch in der Welt.';

    Loc['Show In World'] = 'Zeige in der Welt';
    Loc['Displays the Kill Feed when solo in the world.'] = 'Zeige den Todesmelder, wenn du dich alleine in der Welt befindest.';

    Loc['Show In Dungeons'] = 'Zeige in Instanzen.';
    Loc['Displays the Kill Feed when in 5 man Dungeons.'] = 'Zeige den Todesmelder, wenn du dich in 5er Instanzen befindest.';

    Loc['Show In Raids'] = 'Zeige in Schlachtzügen.';
    Loc['Displays the Kill Feed when in Raids.'] = 'Zeige den Todesmelder, wenn du dich in einem Schlachtzug befindest.';

    Loc['Show In PvP'] = 'Zeige im PvP';
    Loc['Displays the Kill Feed when in Instanced PvP (Arenas and Battlegrounds).'] = 'Zeige den Todesmelder, wenn du dich im PvP Kampf befindest (Arena oder Schlachtfelder).';

    Loc['Show Casted Spell'] = 'Zeige ausgeführte Fähigkeit';
    Loc['Show the Spell that caused a death.'] = 'Zeige die Fähigkeit, die den Tod zur Folge hatte.';

    Loc['Show Damage'] = 'Zeige Schaden';
    Loc['Show how much damage the Creature or Player took.'] = 'Zeige, wie viel Scahden die Kreatur oder der Spieler erlitten hat.';

    Loc['Hide When Inactive'] = 'Verstecke, wenn inaktiv';
    Loc['Hides the Kill Feed after no new events have occured for a short period.'] = 'Versteckt den Todesmelder, wenn keine weiteren Meldungen ausgelöst werden nach einem kurzen Moment.';

    Loc['Font Size'] = 'Schriftgröße';
    Loc['Kill Feed Spacing'] = 'Todesmelder Abstand';

    Loc[' killed '] = ' tötete ';
    Loc['with'] = 'mit';
    Loc['Melee'] = 'Nahkampf';
end
