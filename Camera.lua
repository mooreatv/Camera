-- Camera addon -- (c) 2019 moorea@ymail.com
-- Covered by the GNU General Public License version 3 (GPLv3)
-- NO WARRANTY
-- (contact the author if you need a different license)
--
if Camera == nil then
  -- create table/namespace for most of this addon state
  -- and functions (cameraSaved containing the rest)
  Camera = {}
end

Camera.debug = 1

function Camera.Print(...)
  DEFAULT_CHAT_FRAME:AddMessage(...)
end

function Camera.Debug(msg)
  if Camera.debug == 1 then
    Camera.Print("Camera DBG: " .. msg, 0, 0.4, 1)
  end
end

function Camera.Help(msg)
  Camera.Print("Camera: " .. msg ..
              "\n/cam help -- this message\n/cam config -- open config\n/cam save x -- saves x\n/cam test -- show saved")
end

function Camera.Test(msg)
  Camera.Debug("Called test: " .. msg)
  Camera.Init() -- temp hack
  Camera.Print("Camera: test saved is \"" .. cameraSave.test .. "\".")
end

function Camera.Save(msg)
  Camera.Debug("Called save: " .. msg)
  Camera.Print("Camera: saving!")
  Camera.Init() -- temp hack
  cameraSave.test = msg
end

Camera.subcmd = {["s"] = Camera.Save, ["t"] = Camera.Test, ["h"] = Camera.Help}

function Camera.Slash(arg)
  Camera.Debug("Called slash command, args: " .. arg)
  if #arg == 0 then
    Camera.Help("commands")
    return
  end
  Camera.Debug("/cam " .. arg)
  local cmd = string.lower(string.sub(arg, 1, 1))
  local posRest = string.find(arg, " ")
  local rest = ""
  if not (posRest == nil) then
    rest = string.sub(arg, posRest + 1)
  end
  local funct = Camera.subcmd[cmd]
  if funct == nil then
    Camera.Help("unknown command " .. arg)
  else
    funct(rest)
  end
end

SlashCmdList["Camera_Slash_Command"] = Camera.Slash

SLASH_Camera_Slash_Command1 = "/cam"
SLASH_Camera_Slash_Command2 = "/camera"

Camera.first = 1

Camera.manifestVersion = GetAddOnMetadata("Camera", "Version")

function Camera.Init()
  Camera.Debug("Init() called.")
  if not (Camera.first == 1) then
    return
  end
  Camera.first = 0
  -- saved vars handling
  if cameraSave == nil then
    cameraSave = {}
    Camera.Print("Welcome to Camera: type \"/cam help\" for help")
    cameraSave.test = "camera saved sample"
    cameraSave.paused = 2
    cameraSave.version = Camera.manifestVersion
    cameraSave.revision = "@project-revision@"
  else
    if cameraSave.paused == 1 then
      Camera.Print("Camera is paused.")
    else
      Camera.Print("Camera loaded. Test saved: \"" .. cameraSave.test .. "\".")
    end
  end
  -- end save vars
end

Camera.Debug("Camera (re)loaded v" .. Camera.manifestVersion .. " (@project-version@ @project-revision@)")
