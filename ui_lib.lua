local lib = {};

local rs = game:GetService("RunService");
local uis = game:GetService("UserInputService");
local ts = game:GetService("TweenService");
local plrs = game:GetService("Players");
local ws = game:GetService("Workspace");
local scrn = Vector2.new();
local mouse = plrs.LocalPlayer:GetMouse();

lib.flags = {};
lib.toggled = false;
lib.dragging = false;
lib.drag_offset = Vector2.new();

function lib:create_window(cfg)
    cfg = cfg or {};
    local win = {};

    local main = Instance.new("ScreenGui");
    main.Name = "modernui";
    main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    main.Parent = game:GetService("CoreGui");

    local base = Instance.new("Frame");
    base.Name = "base";
    base.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
    base.BorderColor3 = Color3.fromRGB(40, 40, 40);
    base.BorderSizePixel = 1;
    base.Position = UDim2.new(0.5, -250, 0.5, -175);
    base.Size = UDim2.new(0, 500, 0, 350);
    base.Parent = main;

    local stroke = Instance.new("UIStroke");
    stroke.Color = Color3.fromRGB(75, 75, 75);
    stroke.Thickness = 1.5;
    stroke.Parent = base;

    local uicorner = Instance.new("UICorner");
    uicorner.CornerRadius = UDim.new(0, 6);
    uicorner.Parent = base;

    local topbar = Instance.new("Frame");
    topbar.Name = "topbar";
    topbar.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    topbar.BorderSizePixel = 0;
    topbar.Size = UDim2.new(1, 0, 0, 30);
    topbar.Parent = base;

    local topstroke = Instance.new("UIStroke");
    topstroke.Color = Color3.fromRGB(60, 60, 60);
    topstroke.Thickness = 1;
    topstroke.Parent = topbar;

    local uicorner_2 = Instance.new("UICorner");
    uicorner_2.CornerRadius = UDim.new(0, 6);
    uicorner_2.Parent = topbar;

    local title = Instance.new("TextLabel");
    title.Name = "title";
    title.BackgroundTransparency = 1;
    title.Position = UDim2.new(0, 10, 0, 0);
    title.Size = UDim2.new(1, -20, 1, 0);
    title.Font = Enum.Font.Gotham;
    title.Text = cfg.title or "modern ui";
    title.TextColor3 = Color3.fromRGB(255, 255, 255);
    title.TextSize = 14;
    title.TextXAlignment = Enum.TextXAlignment.Left;
    title.Parent = topbar;

    local container = Instance.new("Frame");
    container.Name = "container";
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    container.BorderSizePixel = 0;
    container.Position = UDim2.new(0, 5, 0, 35);
    container.Size = UDim2.new(1, -10, 1, -40);
    container.Parent = base;

    local containerstroke = Instance.new("UIStroke");
    containerstroke.Color = Color3.fromRGB(50, 50, 50);
    containerstroke.Thickness = 1;
    containerstroke.Parent = container;

    local uicorner_3 = Instance.new("UICorner");
    uicorner_3.CornerRadius = UDim.new(0, 6);
    uicorner_3.Parent = container;

    local uipadding = Instance.new("UIPadding");
    uipadding.PaddingBottom = UDim.new(0, 5);
    uipadding.PaddingLeft = UDim.new(0, 5);
    uipadding.PaddingRight = UDim.new(0, 5);
    uipadding.PaddingTop = UDim.new(0, 5);
    uipadding.Parent = container;

    local uilist = Instance.new("UIListLayout");
    uilist.Padding = UDim.new(0, 5);
    uilist.SortOrder = Enum.SortOrder.LayoutOrder;
    uilist.Parent = container;

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            lib.dragging = true;
            lib.drag_offset = base.Position - UDim2.new(0, input.Position.X, 0, input.Position.Y);
        end
    end);

    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            lib.dragging = false;
        end
    end);

    uis.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and lib.dragging then
            base.Position = lib.drag_offset + UDim2.new(0, input.Position.X, 0, input.Position.Y);
        end
    end);

    function win:toggle()
        lib.toggled = not lib.toggled;
        main.Enabled = lib.toggled;
    end

    uis.InputBegan:Connect(function(input)
        if input.KeyCode == (cfg.toggle_key or Enum.KeyCode.RightShift) then
            win:toggle();
        end
    end);

    win.base = base;
    win.container = container;
    return win;
end

return lib;