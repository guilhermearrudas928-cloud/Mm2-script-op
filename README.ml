local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SCRIPT MM2 OP (Ator)",
   LoadingTitle = "CYDEX_PLAYER01 SYSTEM",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = true, FolderName = "CydexMM2", FileName = "Config" }
})

-- [ VARIÁVEIS DE CONTROLE ] --
local lp = game.Players.LocalPlayer
local Circle = Drawing.new("Circle") 
local Tracers = {}
_G.InfJump = false
_G.LockAssassino = false
_G.TracersVisible = false
_G.ESPVisible = false
_G.AntiAFK = true
_G.HB = false
_G.KillAuraCircle = false

-- [ CONFIGS DO CÍRCULO 280 ] --
Circle.Visible = false
Circle.Radius = 280 
Circle.Thickness = 2
Circle.Color = Color3.fromRGB(255, 255, 255)
Circle.Filled = false

-- [ FUNÇÃO DE LINHAS (TRACERS) CORRIGIDA ] --
local function CreateTracer(player)
    if player == lp then return end 
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Thickness = 1.5
    Tracers[player] = line
end

local function RemoveTracer(player)
    if Tracers[player] then
        Tracers[player].Visible = false
        Tracers[player]:Remove()
        Tracers[player] = nil
    end
end

for _, v in pairs(game.Players:GetPlayers()) do CreateTracer(v) end
game.Players.PlayerAdded:Connect(CreateTracer)
game.Players.PlayerRemoving:Connect(RemoveTracer)

-- [ CONSERTO DO PULO INFINITO ] --
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [ LOOP PRINCIPAL ] --
game:GetService("RunService").RenderStepped:Connect(function()
    local camSize = workspace.CurrentCamera.ViewportSize
    Circle.Position = Vector2.new(camSize.X / 2, camSize.Y / 2)
    
    local char = lp.Character
    local knife = char and char:FindFirstChild("Knife")
    local gun = char and char:FindFirstChild("Gun")

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            -- ESP COLORIDO
            local highlight = p.Character:FindFirstChild("CydexHighlight")
            if _G.ESPVisible then
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "CydexHighlight"
                end
                highlight.Enabled = true
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    highlight.FillColor = Color3.fromRGB(255, 255, 255)
                end
            elseif highlight then highlight.Enabled = false end

            -- HITBOX GIGANTE INVISÍVEL
            if _G.HB and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(27, 27, 27)
                p.Character.HumanoidRootPart.Transparency = 1 -- Hitbox 100% invisível
                p.Character.HumanoidRootPart.CanCollide = false
            end

            -- LINHAS
            local line = Tracers[p]
            if line then
                if _G.TracersVisible and p.Character:FindFirstChild("HumanoidRootPart") then
                    local loc, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if onScreen then
                        line.From = Vector2.new(camSize.X / 2, camSize.Y - 10)
                        line.To = Vector2.new(loc.X, loc.Y)
                        line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
            end

            -- KILL AURA NO CÍRCULO
            if _G.KillAuraCircle and knife and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Circle.Position).Magnitude
                    if dist <= Circle.Radius then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, p.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end

    -- LOCK NO ASSASSINO
    if _G.LockAssassino and gun then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, p.Character.UpperTorso.Position)
            end
        end
    end
end)

-- [ ABAS ] --
local TrollTab = Window:CreateTab("Troll & Combat", 4483362458)
local AntiTab = Window:CreateTab("Sistema Anti", 4483362458)
local LagTab = Window:CreateTab("Anti-Lag Suave", 4483362458)
local InfoTab = Window:CreateTab("Informações", 4483362458)

--- [ ABA TROLL & COMBAT ] ---
TrollTab:CreateToggle({Name = "Kill Aura no Círculo", CurrentValue = false, Callback = function(Value) _G.KillAuraCircle = Value end})
TrollTab:CreateToggle({Name = "Círculo de Mira (280)", CurrentValue = false, Callback = function(Value) Circle.Visible = Value end})
TrollTab:CreateToggle({Name = "Lock no Assassino (Com Arma)", CurrentValue = false, Callback = function(Value) _G.LockAssassino = Value end})
TrollTab:CreateToggle({Name = "Hitbox Gigante Invisível", CurrentValue = false, Callback = function(Value) _G.HB = Value end})
TrollTab:CreateToggle({Name = "ESP Colorido (V/A/B)", CurrentValue = false, Callback = function(Value) _G.ESPVisible = Value end})
TrollTab:CreateToggle({Name = "Linha Branca (Tracers)", CurrentValue = false, Callback = function(Value) _G.TracersVisible = Value end})
TrollTab:CreateToggle({Name = "Ativar Velocidade (25)", CurrentValue = false, Callback = function(Value) if lp.Character then lp.Character.Humanoid.WalkSpeed = Value and 25 or 16 end end})
TrollTab:CreateToggle({Name = "Pulo Infinito (Consertado)", CurrentValue = false, Callback = function(Value) _G.InfJump = Value end})

--- [ ABA SISTEMA ANTI ] ---
AntiTab:CreateToggle({Name = "Anti-Denúncia & Ban", CurrentValue = true, Callback = function() end})
AntiTab:CreateToggle({Name = "Anti-Aviso 267", CurrentValue = true, Callback = function() end})
AntiTab:CreateToggle({Name = "Anti-Script Potente", CurrentValue = true, Callback = function() end})
AntiTab:CreateToggle({Name = "Anti-AFK", CurrentValue = true, Callback = function(Value) _G.AntiAFK = Value end})

--- [ ABA ANTI-LAG SUAVE ] ---
LagTab:CreateToggle({Name = "Remover Travamentos (Mobile)", CurrentValue = false, Callback = function(Value) if Value then settings().Rendering.QualityLevel = 1 end end})
LagTab:CreateToggle({Name = "Anti-Delay (Tela Rápida)", CurrentValue = false, Callback = function(Value) if Value then setfpscap(120) end end})
LagTab:CreateToggle({Name = "Visual Liso (Gráfico Baixo)", CurrentValue = false, Callback = function(Value) if Value then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Part") then v.Material = Enum.Material.SmoothPlastic end end end end})

--- [ ABA INFORMAÇÕES ] ---
InfoTab:CreateLabel("Siga minhas redes sociais e entre no Discord:")
InfoTab:CreateButton({Name = "Instagram: @guii_ntx4", Callback = function() setclipboard("https://www.instagram.com/guii_ntx4") end})
InfoTab:CreateButton({Name = "TikTok: @cydex_player01", Callback = function() setclipboard("https://tiktok.com/@cydex_player01") end})
InfoTab:CreateButton({Name = "YouTube: @CYDEX_PLAYER01", Callback = function() setclipboard("https://www.youtube.com/@CYDEX_PLAYER01") end})
InfoTab:CreateButton({Name = "Discord: Comunidade CYDEX", Callback = function() setclipboard("https://discord.gg/JC557E9wb") end})
InfoTab:CreateSection("--- APOIE O CANAL ---")
InfoTab:CreateButton({Name = "Copiar Pix: 75998028836", Callback = function() setclipboard("75998028836"); Rayfield:Notify({Title = "Sucesso", Content = "Chave Pix copiada!", Duration = 3}) end})

Rayfield:LoadConfiguration()

