require 'moonloader'
require "lib.sampfuncs"
script_version('2')
local imgui             = require 'imgui'
local key               = require 'vkeys'
local encoding          = require 'encoding'
local a                 = require('moonloader').audiostream_state
local sp                = require "lib.samp.events"
local dlstatus          = require('moonloader').download_status
local tag               = '{FFFFFF}[{40E0D0}Tik{FFFFFF}Tok{FF6347}Tools{FFFFFF}]{8B008B}'
local autor             = 'Veni_Rush'
local vk                = 'Мой ВК - @veni_rush'
local wtext             = '~w~TikTokTools~n~by Veni_Rush~n~Loaded'
local sound             = loadAudioStream('moonloader/config/welcome.mp3')
local MODEL             = 0
local skinpng           = {}
local skinc             = imgui.ImBool(false)
local nick_admin        = imgui.ImBuffer(156)
local reasonban         = imgui.ImBuffer(157)
local bannick           = imgui.ImBuffer(158)
local timeban           = imgui.ImBuffer(4)
encoding.default        = 'CP1251'
u8                      = encoding.UTF8

function autoupdate(json_url, tag, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(tag)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage(('{FFFFFF}[{40E0D0}Tik{FFFFFF}Tok{FF6347}Tools{FFFFFF}]{8B008B}Обнаружено обновление с версии '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage(('{FFFFFF}[{40E0D0}Tik{FFFFFF}Tok{FF6347}Tools{FFFFFF}]{8B008B}Обновление к версии: '..updateversion..' завершено.'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage(('{FFFFFF}[{40E0D0}Tik{FFFFFF}Tok{FF6347}Tools{FFFFFF}]{8B008B}Обновление прервалось. Сообщите автору скрипта vk.com/veni_rush'), color)
                        update = false
                      end
                    end
                  end
                )
                end, tag
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Ошибка обновления, сообщите автору скрипта '..vk)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
  
function theme()
  imgui.SwitchContext()
  local style  = imgui.GetStyle()
  local colors = style.Colors
  local clr    = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2

  colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00);
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00);
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00);
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00);
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00);
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88);
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00);
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00);
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00);
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00);
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00);
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75);
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00);
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00);
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00);
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31);
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00);
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00);
    --colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00);
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31);
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31);
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00);
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00);
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00);
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00);
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00);
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00);
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00);
    --colors[clr.Column] = ImVec4(0.56, 0.56, 0.58, 1.00);
    --colors[clr.ColumnHovered] = ImVec4(0.24, 0.23, 0.29, 1.00);
    --colors[clr.ColumnActive] = ImVec4(0.56, 0.56, 0.58, 1.00);
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00);
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00);
    --colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16);
    --colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39);
    --colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63);
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00);
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63);
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00);
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43);
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73);
end
theme()

local main_window_state = imgui.ImBool(false)
local tab = imgui.ImInt(1)
local tabs = {
  u8'Информация',
  u8'Взаимодействие с сервером',
  u8'Фейковые наказания',
  u8'Смена скина',
  u8'Анимации',
}

local texture = imgui.CreateTextureFromFile(getWorkingDirectory().."\\config\\TikTokTools\\tiktoklogo.png")

function imgui.OnDrawFrame()
  if main_window_state.v then
    local X, Y = getScreenResolution()
    imgui.SetNextWindowSize(imgui.ImVec2(700, 400), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(X / 2, Y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'TikTokTools by Veni_Rush', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)
      imgui.Image(texture , imgui.ImVec2(141,52))
        imgui.SetCursorPos(imgui.ImVec2(0, 65))
        imgui.CustomMenu(tabs, tab, imgui.ImVec2(177, 30))
        imgui.SetCursorPos(imgui.ImVec2(190, 35))
        imgui.BeginChild('##main', imgui.ImVec2(500, 356), true)
            if tab.v == 1 then
              imgui.Text(u8' Привет, если ты скачал этот скриптик, то ты тик токер \n Скрипт сделан для помощи в съемках тиктоков по сампу. \n К вашему вниманию такие функции:  \n · Отключение/переподключение от сервера (Чтобы не мешали другие игроки) \n · Имитация краша \n · Воспоизведение анимаций **(чтобы сбить анимацию нажмите Z)** \n · Визуальная смена скина \n · Фейк бан/мут') 
            elseif tab.v == 2 then
              if imgui.Button(u8'Отключиться от сервера') then
                sampSetGamestate(5)
                sampAddChatMessage('Соеденение с севрвером разорвано.', -1)
              end
              if imgui.Button(u8'Переподключиться к серверу') then
                sampAddChatMessage('Реконнект.', -1)
                i, p = sampGetCurrentServerAddress()
                sampConnectToServer(i, p)
                main_window_state.v = not main_window_state.v
              end
            elseif tab.v == 3 then
              imgui.Text(u8'Внизу вы можете ввести причину бана и ник администратора.')
              imgui.PushItemWidth(270)
              imgui.InputText(u8'Никнейм администратора', nick_admin)
              imgui.InputText(u8'Никнейм игрока', bannick)
              imgui.InputText(u8'На сколько', timeban)
              imgui.InputText(u8'Причина', reasonban)
              imgui.PopItemWidth()
              if imgui.Button(u8'Выдать бан') then
                  sampAddChatMessage('{e3573c}Aдминистратор ' ..nick_admin.v.. ' забанил игрока ' ..bannick.v.. ' на '..timeban.v..' дней. Причина: ' ..reasonban.v,-1)
              -- main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Выдать мут') then
                  sampAddChatMessage('{e3573c}Aдминистратор ' ..nick_admin.v.. ' заглушил игрока ' ..bannick.v.. ' на '..timeban.v..' минут. Причина: ' ..reasonban.v,-1)
              -- main_window_state.v = not main_window_state.v
              end
            elseif tab.v == 4 then
              imgui.Text(u8'Используйте команду /setskin, или кнопку ниже.')
              if imgui.Button(u8'Смена скина.') then
                main_window_state.v = not main_window_state.v
                skinc.v = not skinc.v
              end
            elseif tab.v == 5 then
              if imgui.Button(u8'Открыть серверное меню анимаций') then 
                sampSendChat('/anims')
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Сесть') then 
                taskPlayAnim(PLAYER_PED, "SEAT_DOWN", "PED", 1000, false, false, false, false, 50000)
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Встать') then 
                taskPlayAnim(PLAYER_PED, "SEAT_UP", "PED", 1000, false, false, false, false, 1300)
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Сидеть') then 
                taskPlayAnim(PLAYER_PED, "SEAT_IDLE", "PED", 5000, false, false, false, false, 5000)
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Достаёт телефон') then 
                taskPlayAnim(PLAYER_PED, "PHONE_IN", "PED", 1000, false, false, false, false, 3500)
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Прячет телефон') then 
                taskPlayAnim(PLAYER_PED, "PHONE_OUT", "PED", 1000, false, false, false, false, 1800)
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Разговаривает по телефону') then 
                taskPlayAnim(PLAYER_PED, "PHONE_TALK", "PED", 1000, false, false, false, false, 50000)
                main_window_state.v = not main_window_state.v
              end
              if imgui.Button(u8'Жестикулирует руками') then  
                taskPlayAnim(PLAYER_PED, "RIOT_CHALLENGE", "RIOT", 1.73, false, false, false, false, 1800) 
                main_window_state.v = not main_window_state.v 
              end
              if imgui.Button(u8'Пьёт') then  
                taskPlayAnim(PLAYER_PED, "VEND_DRINK_P", "VENDING", 1.33, false, false, false, false, 1200) 
                main_window_state.v = not main_window_state.v 
              end
              if imgui.Button(u8'Пьёт 2') then  
                taskPlayAnim(PLAYER_PED, "VEND_DRINK2_P", "VENDING", 1.33, false, false, false, false, 12000) 
                main_window_state.v = not main_window_state.v 
              end
              if imgui.Button(u8'Умер получив пулевое ранение ') then  
                taskPlayAnim(PLAYER_PED, "KO_SHOT_STOM", "PED", 2.17, false, false, false, false, 50000) 
                main_window_state.v = not main_window_state.v 
              end
              if imgui.Button(u8'Стоит и осмтриватся ') then  
                taskPlayAnim(PLAYER_PED, "ROADCROSS", "PED",  2.00, false, false, false, false, 1800) 
                main_window_state.v = not main_window_state.v 
              end
              if imgui.Button(u8'Ловит такси') then  
                taskPlayAnim(PLAYER_PED, "IDLE_TAXI", "PED", 0.87, false, false, false, false, 1800) 
                main_window_state.v = not main_window_state.v 
              end
              if imgui.Button(u8'Кушает') then  
                taskPlayAnim(PLAYER_PED, "VEND_EAT_P", "VENDING", 1.67, false, false, false, false, 1600) 
                main_window_state.v = not main_window_state.v 
              end
            end
        imgui.EndChild()
    imgui.End()
  end
  ScreenX, ScreenY = getScreenResolution()
  if skinc.v then
    imgui.SetNextWindowPos(imgui.ImVec2(ScreenX / 2 , ScreenY / 2), imgui.Cond.FirsUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8("ID Скинов"), skinc, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize)
    kl = 0
    posvehx = 5
    posvehy = 95
    postextx = 10
    postexty = 95
    imgui.CenterText(u8"Выберите нужный вам скин кликом ЛКМ")
    imgui.CenterText(u8"Если у вас нету изображения - подожмите минуту и перезапустите скрипт")
    imgui.CenterText(u8"Прогресс можете отслеживать в консоли SAMPFUNCS")
    imgui.Separator()
    for i = 0, 311, 1 do
      imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
      imgui.BeginChild("##12dsgpokd" .. i, imgui.ImVec2(80, 95))
      imgui.EndChild()    

      if imgui.IsItemClicked() then
        MODEL = i
        _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
        set_player_skin(id, MODEL)
        skinc.v = false
        sampAddChatMessage(string.format("[Skinc] {FFFFFF} Вы выбрали скин под ID [%d]",MODEL) ,0x6495ED)
      end

      imgui.SetCursorPos(imgui.ImVec2(posvehx, posvehy))
      imgui.Image(skinpng[i], imgui.ImVec2(80, 95))

      postextx = postextx + 100
      posvehx = posvehx + 100
      kl = kl + 1
      if kl > 10 then
        kl = 0
        posvehx = 5
        postextx = 10
        posvehy = posvehy + 120
        postexty = posvehy + 90
      end
    end
    imgui.End()
  end
end

function main()
  while not isSampAvailable() do wait(0) end
  --printStyledString(wtext, 5000, 1)
result, playerid = sampGetPlayerIdByCharHandle(PLAYER_PED)
mynick = sampGetPlayerNickname(playerid)
  sampAddChatMessage('[{40E0D0}Tik{FFFFFF}Tok{FF6347}Tools{FFFFFF}]{8B008B} Loaded', -1)
  autoupdate("https://raw.githubusercontent.com/Venibon/TikTokTools/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Venibon/TikTokToolsbyVeni_Rush/main/update.json")
  if not doesDirectoryExist("moonloader\\config\\peds") then
    createDirectory("moonloader\\config\\peds")
  end
  for i = 0, 311, 1 do
    if not doesFileExist("moonloader\\config\\peds\\skin_" .. i .. ".png") then
      downloadUrlToFile("https://kak-tak.info/wp-content/uploads/2020/05/skin_" .. i .. ".png", "moonloader\\config\\peds\\skin_" .. i .. ".png", function (id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          print("[Skinc] {FFFFFF}Загружен файл Skin_" ..i.. ".png")
        end
      end)
    end
    skinpng[i] = imgui.CreateTextureFromFile(getGameDirectory() .. "\\moonloader\\config\\peds\\skin_" .. i .. ".png")
  end
  if not doesDirectoryExist("moonloader\\config\\TikTokTools") then createDirectory("moonloader\\config\\TikTokTools") end
  if not doesFileExist("moonloader\\config\\TikTOkTools\\tiktoklogo.png") then
    downloadUrlToFile("https://raw.githubusercontent.com/Venibon/TikTokTools/main/tiktoklogo.png", "moonloader\\config\\TikTokTools\\tiktoklogo.png", function (id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        print("[Skinc] {FFFFFF}Загружен файл tiktoklogo.png")
      end
    end)
  end
  sampRegisterChatCommand("setskin",function() skinc.v = not skinc.v end)
  sampRegisterChatCommand("tt", function() main_window_state.v = not main_window_state.v end)
  while true do
    wait(0)
    imgui.Process = main_window_state.v or skinc.v
    if isKeyJustPressed(VK_Z) then
      taskPlayAnim(PLAYER_PED, "SEAT_DOWN", "PED", 1, false, false, false, false, 1)
    end
  end
end

function imgui.CustomMenu(labels, selected, size, speed, centering)
  local bool = false
  speed = speed and speed or 0.2
  local radius = size.y * 0.50
  local draw_list = imgui.GetWindowDrawList()
  if LastActiveTime == nil then LastActiveTime = {} end
  if LastActive == nil then LastActive = {} end
  local function ImSaturate(f)
      return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
  end
  for i, v in ipairs(labels) do
      local c = imgui.GetCursorPos()
      local p = imgui.GetCursorScreenPos()
      if imgui.InvisibleButton(v..'##'..i, size) then
          selected.v = i
          LastActiveTime[v] = os.clock()
          LastActive[v] = true
          bool = true
      end
      imgui.SetCursorPos(c)
      local t = selected.v == i and 1.0 or 0.0
      if LastActive[v] then
          local time = os.clock() - LastActiveTime[v]
          if time <= 0.3 then
              local t_anim = ImSaturate(time / speed)
              t = selected.v == i and t_anim or 1.0 - t_anim
          else
              LastActive[v] = false
          end
      end
      local col_bg = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0,0,0,0))
      local col_box = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.Button] or imgui.ImVec4(0,0,0,0))
      local col_hovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
      local col_hovered = imgui.GetColorU32(imgui.ImVec4(col_hovered.x, col_hovered.y, col_hovered.z, (imgui.IsItemHovered() and 0.2 or 0)))
      draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + t * size.x, p.y + size.y), col_bg, 10.0)
      draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + size.x, p.y + size.y), col_hovered, 10.0)
      draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x+5, p.y + size.y), col_box)
      imgui.SetCursorPos(imgui.ImVec2(c.x+(centering and (size.x-imgui.CalcTextSize(v).x)/2 or 15), c.y+(size.y-imgui.CalcTextSize(v).y)/2))
      imgui.Text(v)
      imgui.SetCursorPos(imgui.ImVec2(c.x, c.y+size.y))
  end
  return bool
end

function onSendRpc(id, bs)
  if id == 25 then
    lua_thread.create(function()
    wait(2000)
    printStyledString(wtext, 5000, 1)
    if not doesFileExist(sound) then
    else
      sound = loadAudioStream('moonloader/config/welcome.mp3')
      setAudioStreamState(sound, a.PLAY)
    end
    end)
  end
end

function cmd()
    main_window_state.v = not main_window_state.v
end


function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end



function sp.onSetPlayerPos(x,y,z)
  if MODEL > 0 then
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    set_player_skin(id, MODEL)
  end
end

function set_player_skin(id, skin)
  local BS = raknetNewBitStream()
  raknetBitStreamWriteInt32(BS, id)
  raknetBitStreamWriteInt32(BS, skin)
  raknetEmulRpcReceiveBitStream(153, BS)
  raknetDeleteBitStream(BS)
end