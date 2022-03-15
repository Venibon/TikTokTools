require 'moonloader'
script_version('2')
local imgui             = require 'imgui'
local key               = require 'vkeys'
local encoding          = require 'encoding'
local a                 = require('moonloader').audiostream_state
local hook              = require "lib.samp.events"
local tag               = '{FFe300}[Ломка]{0060FF} '
local autor             = 'Veni_Rush'
local vk                = 'Мой ВК - @veni_rush'
local wtext             = '~w~TikTokTools~n~by Veni_Rush~n~Loaded'
local sound             = loadAudioStream('moonloader/config/welcome.mp3')
encoding.default        = 'CP1251'
u8                      = encoding.UTF8


function autoupdate(json_url, prefix, url)
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
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
 
function apply_custom_style()
  --source: https://www.unknowncheats.me/forum/direct3d/189635-imgui-style-settings.html
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4

  style.WindowPadding = imgui.ImVec2(15, 15)
  style.WindowRounding = 1.5
  style.FramePadding = imgui.ImVec2(5, 5)
  style.FrameRounding = 4.0
  style.ItemSpacing = imgui.ImVec2(12, 8)
  style.ItemInnerSpacing = imgui.ImVec2(8, 6)
  style.IndentSpacing = 25.0
  style.ScrollbarSize = 15.0
  style.ScrollbarRounding = 9.0
  style.GrabMinSize = 5.0
  style.GrabRounding = 3.0

  colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
  colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
  colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
  colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
  colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
  colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
  colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()
local main_window_state = imgui.ImBool(false)
function imgui.OnDrawFrame()
  if main_window_state.v then 
    imgui.SetNextWindowSize(imgui.ImVec2(500, 1000), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'TikTokTools by Veni_Rush', main_window_state)
    imgui.Text(u8' Привет, если ты скачал этот скриптик, то ты тик токер \n Скрипт сделан для помощи в съемках тиктоков по сампу. \n К вашему вниманию такие функции:  \n · Отключение/переподключение от сервера (Чтобы не мешали другие игроки) \n · Воспоизведение анимаций **(чтобы сбить анимацию нажмите Z)** \n · Визуальная смена скина ')
      if imgui.CollapsingHeader(u8'Взаимодействие с сервером') then
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
      end
      if imgui.CollapsingHeader(u8'Смена скина') then
        imgui.Text(u8'Используйте команду /setskin или кнопку ниже.')
      if imgui.Button(u8'Смена скина') then
        sampProcessChatInput('/setskin')
        main_window_state.v = not main_window_state.v
      end
      end
      if imgui.CollapsingHeader(u8'Анимации') then
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
    imgui.End()
  end
end

function main()
  while not isSampAvailable() do wait(0) end
  sampRegisterChatCommand('ttt',cmd)
sampAddChatMessage('123123')
  autoupdate("https://raw.githubusercontent.com/Venibon/TikTokToolsbyVeni_Rush/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Venibon/TikTokToolsbyVeni_Rush/main/update.json")
    while true do
      imgui.Process = main_window_state.v
    wait(0)
      if isKeyJustPressed(VK_Z) then
        taskPlayAnim(PLAYER_PED, "SEAT_DOWN", "PED", 1, false, false, false, false, 1)
      end
  end
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


