local Fatality = loadstring(game:HttpGet("https://raw.githubusercontent.com/aseramong67-afk/Fatality-UI/refs/heads/master/src/source.luau"))();
local Notification = Fatality:CreateNotifier();

Fatality:Loader({
	Name = "FATALITY",
	Duration = 4
});

Notification:Notify({
	Title = "FATALITY",
	Content = "Hello, "..game.Players.LocalPlayer.DisplayName..' Welcome back!',
	Icon = "clipboard"
})

-- // PastaSense ESP (embedded from PastaSense/modules/esp.lua) --\\
local ESP = (function()
local ESP = {}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

function ESP.New(S, ESPFlags, connections)
    local M = {}
    M.players = {}
    M.tracerList = {}

    local guiParent = nil
    pcall(function()
        local gh = nil
        if type(_G) == "table" then
            gh = rawget(_G, "gethui")
        end
        if type(gh) == "function" then
            guiParent = gh()
        end
    end)
    if guiParent == nil then
        guiParent = game:GetService("CoreGui")
    end
    M.screengui = Instance.new("ScreenGui")
    M.screengui.Parent = guiParent
    M.cache = Instance.new("ScreenGui")
    M.cache.Parent = guiParent


    M.screengui.IgnoreGuiInset = true
    M.screengui.Name = "\0"
    M.cache.Enabled = false

    local fonts = {}; do


        local ok = pcall(function()
            local isfileFn, writefileFn, delfileFn, gcaFn = nil, nil, nil, nil
            if type(_G) == "table" then
                isfileFn = rawget(_G, "isfile")
                writefileFn = rawget(_G, "writefile")
                delfileFn = rawget(_G, "delfile")
                gcaFn = rawget(_G, "getcustomasset")
            end
            assert(type(isfileFn) == "function", "no isfile")
            assert(type(writefileFn) == "function", "no writefile")
            assert(type(gcaFn) == "function", "no getcustomasset")
            local function Register_Font(Name, Weight, Style, Asset)
                if not isfileFn(Asset.Id) then
                    writefileFn(Asset.Id, Asset.Font)
                end
                if isfileFn(Name .. ".font") and type(delfileFn) == "function" then
                    delfileFn(Name .. ".font")
                end
                local Data = {
                    name = Name,
                    faces = {
                        {
                            name = "Normal",
                            weight = Weight,
                            style = Style,
                            assetId = gcaFn(Asset.Id),
                        },
                    },
                }
                writefileFn(Name .. ".font", HttpService:JSONEncode(Data))
                return gcaFn(Name .. ".font")
            end
            local ProggyTiny = Register_Font("adwdawdwadadwadawdawdawdawd!", 100, "Normal", {
                Id = "ProggyTinyyyy.ttf",
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf"),
            })
            fonts = {
                main = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            }
        end)
        if not ok or not fonts.main then
            pcall(function()
                fonts = { main = Font.fromEnum(Enum.Font.Code) }
            end)
        end
    end

    local function curCamera() return workspace.CurrentCamera end

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new
    local dim_offset = UDim2.fromOffset
    local rgb = Color3.fromRGB
    local esp = M

    function esp:box_solve(torso)
        if not torso then return nil, nil, nil end
        local cam = curCamera()
        if not cam then return nil, nil, nil end
        local camCF = cam.CFrame
        local up = torso.CFrame.UpVector
        local camUp = camCF.UpVector
        local Distance = (torso.Position - camCF.Position).Magnitude
        local Top, TopIsRendered = cam:WorldToViewportPoint(torso.Position + up * 1.8 + camUp)
        local Bottom = cam:WorldToViewportPoint(torso.Position - up * 2.5 - camUp)
        local Width = math.max(math.floor(math.abs(Top.X - Bottom.X)), 3)
        local Height = math.max(math.floor(math.max(math.abs(Bottom.Y - Top.Y), Width / 2)), 3)
        local BoxSize = Vector2.new(math.floor(math.max(Height / 1.5, Width)), Height)
        local BoxPosition = Vector2.new(math.floor(Top.X * 0.5 + Bottom.X * 0.5 - BoxSize.X * 0.5), math.floor(math.min(Top.Y, Bottom.Y)))
        return BoxSize, BoxPosition, TopIsRendered, Distance
    end

    function esp:create(instance, options)
        local ins = Instance.new(instance)
        for prop, value in pairs(options) do
            if value ~= nil then
                ins[prop] = value
            end
        end
        return ins
    end

    local function buildName(player)
        local d = ESPFlags["Name_DisplayName"]
        local u = ESPFlags["Name_UserName"]
        if d and u then
            return string.format("%s (@%s)", player.DisplayName, player.Name)
        elseif d then
            return player.DisplayName
        elseif u then
            return "@" .. player.Name
        else
            return ""
        end
    end

    function esp:create_object(player)
        esp[player.Name] = { objects = {}, info = { character = nil, humanoid = nil, rootpart = nil } }
        local data = esp[player.Name]
        local objects = data.objects

        objects["holder"] = esp:create("Frame", {
            Parent = esp.screengui;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 0);
            Visible = false;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        objects["box_outline"] = esp:create("UIStroke", {
            Parent = (ESPFlags["Boxes"] and ESPFlags["Box_Type"] ~= "Corner" and objects["holder"]) or esp.cache;
            LineJoinMode = Enum.LineJoinMode.Miter;
        })

        objects["name"] = esp:create("TextLabel", {
            FontFace = fonts.main;
            Parent = objects["holder"];
            TextColor3 = ESPFlags["Name_Color"].Color;
            BorderColor3 = rgb(0, 0, 0);
            Text = buildName(player);
            Name = "\0";
            TextStrokeTransparency = 0;
            AnchorPoint = vec2(0, 1);
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, -5);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 9;
        })

        objects["box_handler"] = esp:create("Frame", {
            Parent = (ESPFlags["Boxes"] and ESPFlags["Box_Type"] ~= "Corner" and objects["holder"]) or esp.cache;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        objects["box_color"] = esp:create("UIStroke", {
            Color = rgb(255, 255, 255);
            LineJoinMode = Enum.LineJoinMode.Miter;
            Name = "\0";
            Parent = objects["box_handler"];
        })

        objects["outline"] = esp:create("Frame", {
            Parent = objects["box_handler"];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        esp:create("UIStroke", {
            Parent = objects["outline"];
            LineJoinMode = Enum.LineJoinMode.Miter;
        })


        objects["corners"] = esp:create("Frame", {
            Visible = true;
            BorderColor3 = rgb(0, 0, 0);
            Parent = ESPFlags["Boxes"] and ESPFlags["Box_Type"] == "Corner" and objects["holder"] or esp.cache;
            BackgroundTransparency = 1;
            Position = dim2(0, -1, 0, 2);
            Name = "\0";
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
        })

        objects["1"] = esp:create("Frame", {
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(0, 0, 0, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0.4, 0, 0, 3);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["1"];
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["2"] = esp:create("Frame", {
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(0, 0, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 3, 0.25, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["2"];
            Position = dim2(0, 1, 0, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["3"] = esp:create("Frame", {
            AnchorPoint = vec2(1, 0);
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(1, 0, 0, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0.4, 0, 0, 3);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["3"];
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["4"] = esp:create("Frame", {
            AnchorPoint = vec2(1, 0);
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(1, 0, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 3, 0.25, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["4"];
            Position = dim2(0, 1, 0, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["5"] = esp:create("Frame", {
            AnchorPoint = vec2(0, 1);
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(0, 0, 1, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0.4, 0, 0, 3);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["5"];
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["6"] = esp:create("Frame", {
            BorderColor3 = rgb(0, 0, 0);
            Rotation = 180;
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(0, 0, 1, -5);
            AnchorPoint = vec2(0, 1);
            Size = dim2(0, 3, 0.25, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["6"];
            Position = dim2(0, 1, 0, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["7"] = esp:create("Frame", {
            AnchorPoint = vec2(1, 1);
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(1, 0, 1, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0.4, 0, 0, 3);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["7"];
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })

        objects["8"] = esp:create("Frame", {
            BorderColor3 = rgb(0, 0, 0);
            Rotation = 180;
            Parent = objects["corners"];
            Name = "line";
            Position = dim2(1, 0, 1, -5);
            AnchorPoint = vec2(1, 1);
            Size = dim2(0, 3, 0.25, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        esp:create("Frame", {
            Parent = objects["8"];
            Position = dim2(0, 1, 0, -2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = ESPFlags["Box_Color"].Color;
        })


        objects["corner_fills"] = {}
        for _, line in objects["corners"]:GetChildren() do
            local fill = line:FindFirstChild("Frame")
            if fill then objects["corner_fills"][#objects["corner_fills"] + 1] = fill end
        end


        local ok, tracer = pcall(Drawing.new, "Line")
        if ok and tracer then
            tracer.Thickness = 1
            tracer.Transparency = 1
            tracer.Visible = false
            objects["tracer"] = tracer
            M.tracerList[#M.tracerList + 1] = tracer
        end


        objects["healthbar_holder"] = esp:create("Frame", {
            AnchorPoint = vec2(1, 0);
            Parent = ESPFlags["Healthbar"] and objects["holder"] or esp.cache;
            Name = "\0";
            Position = dim2(0, -5, 0, -1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 4, 1, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0);
        })
        objects["healthbar"] = esp:create("Frame", {
            Parent = objects["healthbar_holder"];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255);
        })


        objects["distance"] = esp:create("TextLabel", {
            FontFace = fonts.main;
            TextColor3 = ESPFlags["Distance_Color"].Color;
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = ESPFlags["Distance"] and objects["holder"] or esp.cache;
            TextStrokeTransparency = 0;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 1, 5);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 9;
        })


        objects["weapon"] = esp:create("TextLabel", {
            FontFace = fonts.main;
            TextColor3 = ESPFlags["Weapon_Color"].Color;
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = esp.cache;
            TextStrokeTransparency = 0;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 1, 19);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 9;
        })


        data.health_changed = function(value)
            if not ESPFlags["Healthbar"] then return end
            local holder = objects["holder"]
            if not holder or holder.Parent == nil then return end
            local humanoid = data.info.humanoid
            local multiplier = value / humanoid.MaxHealth
            local hpHigh, hpLow
            local LocalP = Players.LocalPlayer
            local isSelf = player == LocalP
            local sameTeam = (not isSelf) and player.Team ~= nil and player.Team == LocalP.Team
            local isFriend = (not isSelf) and S.FriendIds and S.FriendIds[player.UserId] ~= nil
            local useRole = S.RoleColor_Enabled and not isSelf and not isFriend and player.Team ~= nil
            if isSelf then
                hpHigh = S.Self_Health_High
                hpLow = S.Self_Health_Low
            elseif isFriend then
                hpHigh = S.Friend_Color
                hpLow = S.Friend_Color
            elseif useRole then
                local rc = player.TeamColor.Color
                hpHigh = rc
                hpLow = rc
            elseif sameTeam then
                hpHigh = S.Teammate_Health_High
                hpLow = S.Teammate_Health_Low
            else
                hpHigh = ESPFlags["Health_High"].Color
                hpLow = ESPFlags["Health_Low"].Color
            end
            local color = hpLow:Lerp(hpHigh, multiplier)
            objects["healthbar"].Size = UDim2.new(1, -2, multiplier, -2)
            objects["healthbar"].Position = UDim2.new(0, 1, 1 - multiplier, 1)
            objects["healthbar"].BackgroundColor3 = color
        end

        data.tool_added = function(item)
            if not item:IsA("Tool") then return end
            local holder = objects["holder"]
            local weapon = objects["weapon"]
            if not holder or holder.Parent == nil or not weapon then return end
            local char = data.info.character
            if not char then return end

            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                weapon.Text = tool.Name
                if ESPFlags["Weapon"] then
                    weapon.Parent = holder
                end
            else
                weapon.Text = ""
                weapon.Parent = esp.cache
            end
        end

        data.refresh_offsets = function()

            local oxN = tonumber(S.ESP_OffNameX) or 0
            local oyN = tonumber(S.ESP_OffName) or 0
            local oxD = tonumber(S.ESP_OffDistX) or 0
            local oyD = tonumber(S.ESP_OffDist) or 0
            local oxW = tonumber(S.ESP_OffWeapX) or 0
            local oyW = tonumber(S.ESP_OffWeap) or 0
            objects["name"].Position = dim2(0, oxN, 0, -5 + oyN)
            objects["distance"].Position = dim2(0, oxD, 1, 5 + oyD)
            local offset = 5 + oyD
            if objects["distance"].Parent == objects["holder"] then
                offset = offset + 5
            end
            if objects["weapon"].Parent == objects["holder"] then
                offset = offset + 5
            end
            objects["weapon"].Position = dim2(0, oxW, 1, offset + oyW)
        end

        data.descendantConnections = {}
        data.refresh_descendants = function()
            local character = player.Character
            if not character then return end
            local humanoid = character:WaitForChild("Humanoid", 5)
            if not humanoid then return end
            for _, c in ipairs(data.descendantConnections) do
                pcall(function() c:Disconnect() end)
            end
            data.descendantConnections = {}
            data.info.character = character
            data.info.humanoid = humanoid

            for _, conn in ipairs({
                humanoid.HealthChanged:Connect(data.health_changed),
                character.ChildAdded:Connect(data.tool_added),
                character.ChildRemoved:Connect(data.tool_added),
            }) do
                table.insert(data.descendantConnections, conn)
                table.insert(connections, conn)
            end
            data.health_changed(data.info.humanoid.Health)
        end


        data.refresh_descendants()
        if data.info.humanoid then
            data.health_changed(data.info.humanoid.Health)
        end
        table.insert(connections, player.CharacterAdded:Connect(data.refresh_descendants))
        local startChar = player.Character
        local tool = startChar and startChar:FindFirstChildOfClass("Tool")
        if tool then data.tool_added(tool) end
    end

    function esp:remove_object(player)
        local holder = esp[player.Name]
        if not holder then return end
        local objects = holder.objects
        if objects["tracer"] then
            local tr = objects["tracer"]
            pcall(function() tr:Remove() end)
            for i, l in ipairs(M.tracerList) do
                if l == tr then table.remove(M.tracerList, i) break end
            end
        end
        objects["holder"]:Destroy()
        esp[player.Name] = nil
    end

    function esp:refresh_elements()
        for _, v in Players:GetPlayers() do
            repeat
            if not v.Character then break end
            local path = esp[v.Name]
            local objects = path and path.objects
            if not objects then break end

            local holder0 = objects["holder"]
            if not holder0 or holder0.Parent == nil then break end
            local LocalPlayer = Players.LocalPlayer
            local isSelfR = v == LocalPlayer
            local sameTeamR = (not isSelfR) and v.Team ~= nil and v.Team == LocalPlayer.Team
            local isFriendR = (not isSelfR) and S.FriendIds and S.FriendIds[v.UserId] ~= nil
            local boxCR, nameCR, distCR, wepCR
            if isSelfR then
                boxCR = S.Self_Box_Color
                nameCR = S.Self_Name_Color
                distCR = S.Self_Distance_Color
                wepCR = S.Self_Weapon_Color
            elseif isFriendR then
                boxCR = S.Friend_Color
                nameCR = S.Friend_Color
                distCR = S.Friend_Color
                wepCR = S.Friend_Color
            elseif sameTeamR then
                boxCR = S.Teammate_Box_Color
                nameCR = S.Teammate_Name_Color
                distCR = S.Teammate_Distance_Color
                wepCR = S.Teammate_Weapon_Color
            else
                boxCR = ESPFlags["Box_Color"].Color
                nameCR = ESPFlags["Name_Color"].Color
                distCR = ESPFlags["Distance_Color"].Color
                wepCR = ESPFlags["Weapon_Color"].Color
            end
            local showHolder
            if isSelfR then
                showHolder = S.SelfESP_Enabled
            elseif isFriendR then
                showHolder = S.Friends_Enabled
            elseif sameTeamR then
                showHolder = S.Teammates_Enabled
            else
                showHolder = S.ESP_Enabled
            end
            objects.holder.Parent = showHolder and esp.screengui or esp.cache

            if S.RoleColor_Enabled and not isSelfR and not isFriendR and v.Team then
                local roleCR = v.TeamColor.Color
                boxCR, nameCR, distCR, wepCR = roleCR, roleCR, roleCR, roleCR
            end
            objects["name"].Parent = ESPFlags["Names"] and objects["holder"] or esp.cache
            objects["name"].TextColor3 = nameCR
            objects["name"].Text = buildName(v)

            local is_corner = ESPFlags["Box_Type"] == "Corner"
            if ESPFlags["Boxes"] then
                objects["corners"].Parent = (is_corner and objects["holder"]) or esp.cache
                objects["box_handler"].Parent = (is_corner and esp.cache or objects["holder"])
                objects["box_outline"].Parent = (is_corner and esp.cache or objects["holder"])
            else
                objects["corners"].Parent = esp.cache
                objects["box_handler"].Parent = esp.cache
                objects["box_outline"].Parent = esp.cache
            end
            objects["box_color"].Color = boxCR
            for _, fill in ipairs(objects["corner_fills"]) do
                fill.BackgroundColor3 = boxCR
            end
            objects["healthbar_holder"].Parent = ESPFlags["Healthbar"] and objects["holder"] or esp.cache

            if (S.ESP_HPSide or "Left") == "Right" then
                objects["healthbar_holder"].AnchorPoint = vec2(0, 0)
                objects["healthbar_holder"].Position = dim2(1, 5, 0, -1)
            else
                objects["healthbar_holder"].AnchorPoint = vec2(1, 0)
                objects["healthbar_holder"].Position = dim2(0, -5, 0, -1)
            end
            objects["weapon"].TextColor3 = wepCR
            objects["weapon"].Parent = ESPFlags["Weapon"] and v.Character:FindFirstChildOfClass("Tool") and objects["holder"] or esp.cache
            objects["distance"].TextColor3 = distCR
            objects["distance"].Parent = ESPFlags["Distance"] and objects["holder"] or esp.cache
            pcall(path.refresh_offsets, path)


            if path.info.humanoid then
                pcall(path.health_changed, path.info.humanoid.Health)
            end
            until true
        end
    end

    function esp:CleanupTracers()
        for _, line in ipairs(M.tracerList) do
            pcall(function() line:Remove() end)
        end
        table.clear(M.tracerList)
    end

    function esp:update_tracers(cam, viewport, playerList)
        local LocalPlayer = Players.LocalPlayer
        for _, player in ipairs(playerList or Players:GetPlayers()) do
            repeat
            local data = esp[player.Name]
            local line = data and data.objects and data.objects["tracer"]
            if not line then break end
            local show = false
            if S.Tracers_Enabled and data.info.character and data.info.humanoid and cam then
                local humanoid = data.info.humanoid
                local rootPart = humanoid.RootPart
                local alive = (not S.DeathCheck) or (humanoid.Health > 0)
                local isSelfP = player == LocalPlayer
                local sameTeamP = (not isSelfP) and player.Team ~= nil and player.Team == LocalPlayer.Team
                local isFriendP = (not isSelfP) and S.FriendIds and S.FriendIds[player.UserId] ~= nil
                local cat = isSelfP and S.SelfESP_Enabled or (isFriendP and S.Friends_Enabled or (sameTeamP and S.Teammates_Enabled or S.ESP_Enabled))
                if rootPart and alive and cat then
                    local sp, onScreen = cam:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        show = true
                        if isSelfP then line.Color = S.Self_Box_Color
                        elseif isFriendP then line.Color = S.Friend_Color
                        elseif sameTeamP then line.Color = S.Teammate_Box_Color
                        else line.Color = ESPFlags["Box_Color"].Color end
                        if S.RoleColor_Enabled and not isSelfP and not isFriendP and player.Team then
                            line.Color = player.TeamColor.Color
                        end
                        if S.ESP_Rainbow and not isSelfP and not isFriendP then
                            line.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        end
                        line.From = Vector2.new(viewport.X / 2, viewport.Y)
                        line.To = Vector2.new(sp.X, sp.Y)
                    end
                end
            end
            if line.Visible ~= show then line.Visible = show end
            until true
        end
    end

    return M
end

return ESP
end)();

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;

-- // ESP flags (defaults from PastaSense/modules/config.lua) --\\
local S = {
	ESP_Enabled = true,
	ESP_Rainbow = false,
	ESP_MaxDistance = 2000,
	ESP_HPSide = "Left",
	ESP_OffName = 0,
	ESP_OffNameX = 0,
	ESP_OffDist = 0,
	ESP_OffDistX = 0,
	ESP_OffWeap = 0,
	ESP_OffWeapX = 0,
	Tracers_Enabled = true,
	DeathCheck = true,
	RoleColor_Enabled = false,
	Friend_Color = Color3.fromRGB(255, 255, 255),
	Friends_Enabled = true,
	Teammates_Enabled = true,
	Teammate_Box_Color = Color3.fromRGB(80, 160, 255),
	Teammate_Name_Color = Color3.fromRGB(80, 160, 255),
	Teammate_Health_High = Color3.fromRGB(80, 160, 255),
	Teammate_Health_Low = Color3.fromRGB(80, 100, 200),
	Teammate_Distance_Color = Color3.fromRGB(80, 160, 255),
	Teammate_Weapon_Color = Color3.fromRGB(80, 160, 255),
	SelfESP_Enabled = false,
	Self_Box_Color = Color3.fromRGB(255, 255, 255),
	Self_Name_Color = Color3.fromRGB(255, 255, 255),
	Self_Health_High = Color3.fromRGB(255, 255, 255),
	Self_Health_Low = Color3.fromRGB(200, 200, 200),
	Self_Distance_Color = Color3.fromRGB(255, 255, 255),
	Self_Weapon_Color = Color3.fromRGB(255, 255, 255)
};

local ESPFlags = {
	["Names"] = true,
	["Name_DisplayName"] = true,
	["Name_UserName"] = true,
	["Name_Color"] = { Color = Color3.fromRGB(0, 255, 255) },
	["Boxes"] = true,
	["Box_Type"] = "Corner",
	["Box_Color"] = { Color = Color3.fromRGB(0, 255, 0) },
	["Healthbar"] = true,
	["Health_High"] = { Color = Color3.fromRGB(0, 255, 0) },
	["Health_Low"] = { Color = Color3.fromRGB(255, 0, 0) },
	["Distance"] = true,
	["Weapon"] = true,
	["Distance_Color"] = { Color = Color3.fromRGB(0, 255, 0) },
	["Weapon_Color"] = { Color = Color3.fromRGB(0, 255, 255) }
};

local ESPConnections = {};
local esp = ESP.New(S, ESPFlags, ESPConnections);

for _, Player in Players:GetPlayers() do
	esp:create_object(Player);
end;

table.insert(ESPConnections, Players.PlayerAdded:Connect(function(Player)
	esp:create_object(Player);
end));

table.insert(ESPConnections, Players.PlayerRemoving:Connect(function(Player)
	esp:remove_object(Player);
end));

esp:refresh_elements();

-- // ESP preview chips -> real ESP flags --\\
local ESPSetters = {
	ESP = function(Value) S.ESP_Enabled = Value end,
	Box = function(Value) ESPFlags.Boxes = Value end,
	Name = function(Value) ESPFlags.Names = Value end,
	Distance = function(Value) ESPFlags.Distance = Value end,
	ItemName = function(Value) ESPFlags.Weapon = Value end,
	Health = function(Value) ESPFlags.Healthbar = Value end,
	Tracer = function(Value) S.Tracers_Enabled = Value end
};

local function ApplyESPFlags(Key, Value)
	local Setter = ESPSetters[Key];

	if Setter then
		Setter(Value);
	end;

	esp:refresh_elements();
end;

-- // ESP render loop (compact version of PastaSense/modules/main.lua) --\\
table.insert(ESPConnections, RunService.RenderStepped:Connect(function()
	local Cam = workspace.CurrentCamera;

	if not Cam then
		return;
	end;

	local PlayerList = Players:GetPlayers();

	for _, Player in PlayerList do
		repeat
			local Data = esp[Player.Name];

			if type(Data) ~= "table" then
				break;
			end;

			local Objects = Data.objects;
			local Humanoid = Data.info.humanoid;
			local Holder = Objects and Objects["holder"];

			if not (Humanoid and Holder) then
				if Holder then
					Holder.Visible = false;
				end;
				break;
			end;

			if S.DeathCheck and Humanoid.Health <= 0 then
				Holder.Visible = false;
				break;
			end;

			local IsSelf = Player == LocalPlayer;
			local SameTeam = (not IsSelf) and Player.Team ~= nil and Player.Team == LocalPlayer.Team;
			local IsFriend = (not IsSelf) and S.FriendIds and S.FriendIds[Player.UserId] ~= nil;
			local Show;

			if IsSelf then
				Show = S.SelfESP_Enabled;
			elseif IsFriend then
				Show = S.Friends_Enabled;
			elseif SameTeam then
				Show = S.Teammates_Enabled;
			else
				Show = S.ESP_Enabled;
			end;

			if not Show then
				Holder.Visible = false;
				break;
			end;

			local RootPart = Humanoid.RootPart;

			if not RootPart then
				Holder.Visible = false;
				break;
			end;

			local BoxSize, BoxPos, OnScreen, Distance = esp:box_solve(RootPart);

			if not OnScreen or (Distance or math.huge) > (S.ESP_MaxDistance or math.huge) then
				Holder.Visible = false;
				break;
			end;

			if not Holder.Visible then
				Holder.Visible = true;
			end;

			Holder.Position = UDim2.fromOffset(BoxPos.X, BoxPos.Y);
			Holder.Size = UDim2.fromOffset(BoxSize.X, BoxSize.Y);

			local DistanceLabel = Objects["distance"];

			if IsSelf then
				if DistanceLabel.Text ~= "" then
					DistanceLabel.Text = "";
				end;
			else
				DistanceLabel.Text = tostring(math.floor(Distance / 3.28 + 0.5)) .. "m";
			end;
		until true;
	end;

	esp:update_tracers(Cam, Cam.ViewportSize, PlayerList);
end));

local Window = Fatality.new({
	Name = "FATALITY",
	Expire = "never",
	ESPPreview = {
		Elements = {
			{ Key = "ESP", Label = "Enemy ESP", Default = true },
			{ Key = "Box", Label = "Box", Default = true },
			{ Key = "Name", Label = "Names", Default = true },
			{ Key = "Distance", Label = "Distance", Default = true },
			{ Key = "ItemName", Label = "Weapon", Default = true },
			{ Key = "Health", Label = "Health bar", Default = true },
			{ Key = "Tracer", Label = "Tracers", Default = true }
		},
		Callback = ApplyESPFlags
	}
});

local Rage = Window:AddMenu({
	Name = "RAGE",
	Icon = "skull"
})

local Legit = Window:AddMenu({
	Name = "LEGIT",
	Icon = "target"
})

local Visual = Window:AddMenu({
	Name = "VISUAL",
	Icon = "eye"
})

local Misc = Window:AddMenu({
	Name = "MISC",
	Icon = "settings"
})

local Skins = Window:AddMenu({
	Name = "SKINS",
	Icon = "palette"
})

local Lua = Window:AddMenu({
	Name = "LUA",
	Icon = "code"
})

do
	local Weapon = Rage:AddSection({
		Position = 'left',
		Name = "WEAPON"
	});
	
	local Extra = Rage:AddSection({
		Position = 'center',
		Name = "EXTREA"
	});
	
	local General = Rage:AddSection({
		Position = 'right',
		Name = "GENERAL"
	});
	
	Weapon:AddSlider({
		Name = "Hit-chance",
		Default = 61
	})
	
	Weapon:AddSlider({
		Name = "Pointscale",
		Type = "%",
		Default = 0
	})
	
	Weapon:AddSlider({
		Name = "Min-damage",
		Type = "%",
		Default = 85
	})
	
	Weapon:AddDropdown({
		Name = "Hitboxes",
		Values = {"Head",'Neck','Arms','Legs'}
	})
	
	Weapon:AddDropdown({
		Name = "Multipoint",
		Values = {"Head",'Neck','Arms','Legs'}
	})
	
	Weapon:AddDropdown({
		Name = "Target selection",
		Values = {"Damage"},
		Default = "Damage"
	})
	
	local Autostop = Extra:AddToggle({
		Name = "Autostop",
		Option = true;
	});
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Autostop.Option:AddToggle({
		Name = "Something"
	})
	
	Extra:AddToggle({
		Name = "Autoscope",
	});
	
	Extra:AddToggle({
		Name = "Ignore limbs on moving",
	});
	
	Extra:AddToggle({
		Name = "Autorevolver",
	});
	
	General:AddToggle({
		Name = "Aimbot",
		Risky = true
	})
	
	General:AddToggle({
		Name = "Slient aim",
		Risky = false
	})
	
	General:AddSlider({
		Name = "Maximum fov",
		Type = " deg",
		Default = 0
	})
	
	General:AddToggle({
		Name = "Autofire",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Delay shot",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Duck peek assist",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Force bodyaim",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Force shoot",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Headshot only",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Knife bot",
		Risky = false
	})
	
	General:AddToggle({
		Name = "Zeus bot",
		Risky = false
	})
	
	local NoSpread = General:AddToggle({
		Name = "Nospread",
		Risky = false,
		Option = true
	})
	
	NoSpread.Option:AddToggle({
		Name = "Something"
	})

	NoSpread.Option:AddToggle({
		Name = "Something"
	})

	NoSpread.Option:AddToggle({
		Name = "Something"
	})

	NoSpread.Option:AddToggle({
		Name = "Something"
	})
	
	local Doubletap = General:AddToggle({
		Name = "Doubletap",
		Risky = true,
		Option = true
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})

	Doubletap.Option:AddToggle({
		Name = "Something"
	})
	
	General:AddButton({
		Name = "Notification",
		Callback = function()
			Notification:Notify({
				Title = "Notification",
				Content = "Testing Notification",
				Duration = math.random(3,7),
				Icon = "info"
			})
		end,
	})
end

do
	local Aim = Legit:AddSection({
		Position = 'left',
		Name = "AIM"
	});
	
	local Rcs = Legit:AddSection({
		Position = 'left',
		Name = "RCS"
	});

	local Trigger = Legit:AddSection({
		Position = 'center',
		Name = "TRIGGER"
	});
	
	local Backtrack = Legit:AddSection({
		Position = 'center',
		Name = "BACKTRACK"
	});

	local General = Legit:AddSection({
		Position = 'right',
		Name = "GENERAL"
	});
	
	Aim:AddToggle({
		Name = "Aim assist"
	})
	
	Aim:AddDropdown({
		Name = "Mode",
		Default = "Adaptive",
		Values = {"Adaptive","value 1",'Value 2'}
	})
	
	Aim:AddDropdown({
		Name = "Hitboxes",
		Multi = true,
		Default = {
			["Head"] = true
		},
		Values = {
			"Head",
			'Neck',
			'Arms',
			'Legs'
		}
	})
	
	Aim:AddSlider({
		Name = "Multipoint"
	})
	
	Aim:AddSlider({
		Name = "Aim fov",
		Round = 1,
		Default = 0.1,
		Type = " deg"
	})
	
	Aim:AddSlider({
		Name = "Aim speed",
		Default = 1,
		Type = "%"
	})
	
	Aim:AddSlider({
		Name = "Min-damage",
		Default = 61,
	})
	

	Aim:AddToggle({
		Name = "Only in scpoe"
	})
	

	Aim:AddToggle({
		Name = "Autostop"
	})
	
	Rcs:AddToggle({
		Name = "Recoil control"
	})
	
	Rcs:AddSlider({
		Name = "Speed",
		Default = 1,
		Type = "%"
	})
	

	Rcs:AddToggle({
		Name = "Re-center"
	})
	

	Rcs:AddSlider({
		Name = "Start bullet",
		Default = 1,
	})
	
	Trigger:AddToggle({
		Name = "Triggerbot"
	})
	
	Trigger:AddSlider({
		Name = "Hit-chance",
		Default = 100,
		Type = "%"
	})
	
	Trigger:AddToggle({
		Name = "Use seed when available"
	})
	
	Trigger:AddSlider({
		Name = "Min-damage",
		Default = 0,
		Type = "%"
	})
	
	Trigger:AddSlider({
		Name = "Reaction time",
		Default = 0,
		Type = "ms"
	})
	
	Trigger:AddToggle({
		Name = "Wait for aim assist hitgroup"
	})
	
	Trigger:AddToggle({
		Name = "Only in Scope"
	})
	
	Backtrack:AddSlider({
		Name = "Backtrack",
		Default = 0,
		Type = "%"
	})
	
	General:AddToggle({
		Name = "Enabled"
	})
	
	General:AddDropdown({
		Name = "Disablers",
		Values = {"d1",'d2'}
	})
	
	General:AddToggle({
		Name = "Visualize fov",
		Option = true
	}).Option:AddColorPicker({
		Name = "Color",
		Default = Color3.fromRGB(255, 34, 75)
	})
	
	General:AddToggle({
		Name = "Autorevolver"
	})
end

do
	local Misc = Visual:AddSection({
		Name = "MISC",
		Position = 'left'
	})
	
	local Model = Visual:AddSection({
		Name = "MODEL",
		Position = 'center'
	})
	
	Misc:AddToggle({
		Name = "Thirdperson",
		Option = true
	}).Option:AddSlider({
		Name = "Distance"
	});
	
	Misc:AddToggle({
		Name = "Overhead override",
		Option = true
	}).Option:AddDropdown({
		Name = "Override"
	});
	
	Misc:AddToggle({
		Name = "Fov override",
		Option = true
	}).Option:AddToggle({
		Name = "Something"
	})
	
	Misc:AddToggle({
		Name = "Viewmodel override",
		Option = true
	}).Option:AddToggle({
		Name = "Something"
	})
	
	Misc:AddDropdown({
		Name = "Remove scope"
	})
	
	local pc = Misc:AddToggle({
		Name = "Penetration crosshair",
		Option = true
	}).Option;
	
	pc:AddColorPicker({
		Name = "Walls",
		Default = Color3.fromRGB(111, 255, 0)
	})
	
	pc:AddColorPicker({
		Name = "Can't walls",
		Default = Color3.fromRGB(255, 0, 4)
	})
	
	Misc:AddToggle({
		Name = "Force crosshair",
		Option = true
	}).Option:AddToggle({
		Name = "Something"
	})
	
	Misc:AddDropdown({
		Name = "Spread"
	})
	
	Misc:AddToggle({
		Name = "Bullet tracer",
		Option = true
	}).Option:AddColorPicker({
		Name = "Color",
		Default = Color3.fromRGB(255, 41, 116)
	})
	
	Model:AddDropdown({
		Name = "Visible",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Invisible",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Arms",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Viewmodel",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddDropdown({
		Name = "Attachments",
		Default = "Disabled",
		Values = {"Disabled",'Something'}
	})
	
	Model:AddToggle({
		Name = 'Glow',
		Option = true
		
	}).Option:AddColorPicker({
		Name = "Color"
	})
	
	Model:AddKeybind({
		Name = "Toggle"
	})

end
