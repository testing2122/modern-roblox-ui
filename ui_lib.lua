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
lib.current_tab = nil;

function lib:create_window(cfg)
    cfg = cfg or {};
    local win = {};
    win.tabs = {};
    win.tab_buttons = {};

    local main = Instance.new("ScreenGui");
    main.Name = "modernui";
    main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    main.Parent = game:GetService("CoreGui");

    local base = Instance.new("Frame");
    base.Name = "base";
    base.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
    base.BorderColor3 = Color3.fromRGB(40, 40, 40);
    base.BorderSizePixel = 1;
    base.Position = UDim2.new(0.5, -300, 0.5, -200); -- Increased size
    base.Size = UDim2.new(0, 600, 0, 400); -- Increased size
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

    -- Tab panel on the left
    local tabpanel = Instance.new("Frame");
    tabpanel.Name = "tabpanel";
    tabpanel.BackgroundColor3 = Color3.fromRGB(28, 28, 28);
    tabpanel.BorderSizePixel = 0;
    tabpanel.Position = UDim2.new(0, 5, 0, 35);
    tabpanel.Size = UDim2.new(0, 140, 1, -40);
    tabpanel.Parent = base;

    local tabpanelstroke = Instance.new("UIStroke");
    tabpanelstroke.Color = Color3.fromRGB(55, 55, 55);
    tabpanelstroke.Thickness = 1;
    tabpanelstroke.Parent = tabpanel;

    local tabpanelcorner = Instance.new("UICorner");
    tabpanelcorner.CornerRadius = UDim.new(0, 6);
    tabpanelcorner.Parent = tabpanel;

    local tabscroll = Instance.new("ScrollingFrame");
    tabscroll.Name = "tabscroll";
    tabscroll.BackgroundTransparency = 1;
    tabscroll.BorderSizePixel = 0;
    tabscroll.Position = UDim2.new(0, 0, 0, 5);
    tabscroll.Size = UDim2.new(1, 0, 1, -10);
    tabscroll.CanvasSize = UDim2.new(0, 0, 0, 0);
    tabscroll.ScrollBarThickness = 2;
    tabscroll.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75);
    tabscroll.Parent = tabpanel;

    local tablist = Instance.new("UIListLayout");
    tablist.Padding = UDim.new(0, 5);
    tablist.SortOrder = Enum.SortOrder.LayoutOrder;
    tablist.Parent = tabscroll;

    local tabpadding = Instance.new("UIPadding");
    tabpadding.PaddingBottom = UDim.new(0, 5);
    tabpadding.PaddingLeft = UDim.new(0, 5);
    tabpadding.PaddingRight = UDim.new(0, 5);
    tabpadding.PaddingTop = UDim.new(0, 5);
    tabpadding.Parent = tabscroll;

    -- Content container
    local container = Instance.new("Frame");
    container.Name = "container";
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    container.BorderSizePixel = 0;
    container.Position = UDim2.new(0, 150, 0, 35); -- Moved to accommodate tabpanel
    container.Size = UDim2.new(1, -155, 1, -40); -- Resized to accommodate tabpanel
    container.Parent = base;

    local containerstroke = Instance.new("UIStroke");
    containerstroke.Color = Color3.fromRGB(50, 50, 50);
    containerstroke.Thickness = 1;
    containerstroke.Parent = container;

    local uicorner_3 = Instance.new("UICorner");
    uicorner_3.CornerRadius = UDim.new(0, 6);
    uicorner_3.Parent = container;

    local pages = Instance.new("Folder");
    pages.Name = "pages";
    pages.Parent = container;

    -- Drag functionality
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

    -- Toggle UI visibility
    function win:toggle()
        lib.toggled = not lib.toggled;
        main.Enabled = lib.toggled;
    end

    -- Create tab function
    function win:create_tab(tab_cfg)
        tab_cfg = tab_cfg or {};
        local tab = {};
        
        -- Tab button
        local tabbutton = Instance.new("TextButton");
        tabbutton.Name = tab_cfg.name or "tab";
        tabbutton.BackgroundColor3 = Color3.fromRGB(35, 35, 35);
        tabbutton.BorderSizePixel = 0;
        tabbutton.Size = UDim2.new(1, 0, 0, 30);
        tabbutton.Font = Enum.Font.Gotham;
        tabbutton.Text = tab_cfg.name or "tab";
        tabbutton.TextColor3 = Color3.fromRGB(200, 200, 200);
        tabbutton.TextSize = 12;
        tabbutton.AutoButtonColor = false;
        tabbutton.Parent = tabscroll;
        
        local tabbuttonstroke = Instance.new("UIStroke");
        tabbuttonstroke.Color = Color3.fromRGB(60, 60, 60);
        tabbuttonstroke.Thickness = 1;
        tabbuttonstroke.Parent = tabbutton;
        
        local tabbuttoncorner = Instance.new("UICorner");
        tabbuttoncorner.CornerRadius = UDim.new(0, 4);
        tabbuttoncorner.Parent = tabbutton;
        
        -- Tab separator (line below the tab)
        local separator = Instance.new("Frame");
        separator.Name = "separator";
        separator.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
        separator.BorderSizePixel = 0;
        separator.Position = UDim2.new(0, 5, 1, 0);
        separator.Size = UDim2.new(1, -10, 0, 1);
        separator.Parent = tabbutton;
        
        -- Tab page (content container for the tab)
        local page = Instance.new("ScrollingFrame");
        page.Name = tab_cfg.name or "page";
        page.BackgroundTransparency = 1;
        page.BorderSizePixel = 0;
        page.Position = UDim2.new(0, 5, 0, 5);
        page.Size = UDim2.new(1, -10, 1, -10);
        page.CanvasSize = UDim2.new(0, 0, 0, 0);
        page.ScrollBarThickness = 2;
        page.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75);
        page.Visible = false;
        page.Parent = pages;
        
        local pagelist = Instance.new("UIListLayout");
        pagelist.Padding = UDim.new(0, 8);
        pagelist.SortOrder = Enum.SortOrder.LayoutOrder;
        pagelist.Parent = page;
        
        local pagepadding = Instance.new("UIPadding");
        pagepadding.PaddingBottom = UDim.new(0, 5);
        pagepadding.PaddingLeft = UDim.new(0, 5);
        pagepadding.PaddingRight = UDim.new(0, 5);
        pagepadding.PaddingTop = UDim.new(0, 5);
        pagepadding.Parent = page;
        
        -- Auto-resize canvas
        pagelist:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pagelist.AbsoluteContentSize.Y + 10);
        end);
        
        -- Tab selection functionality
        tabbutton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, v in pairs(pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false;
                end
            end
            
            -- Set all tab buttons to inactive color
            for _, v in pairs(win.tab_buttons) do
                v.BackgroundColor3 = Color3.fromRGB(35, 35, 35);
                v.TextColor3 = Color3.fromRGB(200, 200, 200);
            end
            
            -- Show current tab and highlight button
            page.Visible = true;
            tabbutton.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
            tabbutton.TextColor3 = Color3.fromRGB(255, 255, 255);
            lib.current_tab = tab;
        end);
        
        -- Insert to tabs table
        table.insert(win.tabs, tab);
        table.insert(win.tab_buttons, tabbutton);
        
        -- Set as active if first tab
        if #win.tabs == 1 then
            tabbutton.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
            tabbutton.TextColor3 = Color3.fromRGB(255, 255, 255);
            page.Visible = true;
            lib.current_tab = tab;
        end
        
        -- Auto-resize tab list
        tablist:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabscroll.CanvasSize = UDim2.new(0, 0, 0, tablist.AbsoluteContentSize.Y + 10);
        end);
        
        tab.button = tabbutton;
        tab.container = page;
        
        return tab;
    end

    -- Key binding to toggle UI
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