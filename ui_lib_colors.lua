-- Customizable UI colors
local colors = {
    main_background = Color3.fromRGB(25, 25, 25),    -- Base background
    secondary_bg = Color3.fromRGB(30, 30, 30),       -- Container background
    light_contrast = Color3.fromRGB(35, 35, 35),     -- Button background
    element_bg = Color3.fromRGB(40, 40, 40),         -- Button/toggle background
    border = Color3.fromRGB(60, 60, 60),             -- Strokes/borders
    separator = Color3.fromRGB(55, 55, 55),          -- Separators
    toggle_on = Color3.fromRGB(70, 70, 70),          -- Toggle ON state
    toggle_knob_on = Color3.fromRGB(220, 220, 220),  -- Toggle knob ON state
    toggle_off = Color3.fromRGB(50, 50, 50),         -- Toggle OFF state
    toggle_knob_off = Color3.fromRGB(180, 180, 180), -- Toggle knob OFF state
    text_primary = Color3.fromRGB(255, 255, 255),    -- Primary text
    text_secondary = Color3.fromRGB(200, 200, 200),  -- Secondary text
    text_disabled = Color3.fromRGB(180, 180, 180),   -- Disabled/description text
    highlight = Color3.fromRGB(75, 75, 75),          -- Highlights/accents
}

-- Create a color wheel for color picking
local function create_color_wheel(parent, title, current_color, callback)
    local ts = game:GetService("TweenService");
    
    -- Main frame
    local color_frame = Instance.new("Frame");
    color_frame.Name = "color_wheel_frame";
    color_frame.BackgroundColor3 = colors.element_bg;
    color_frame.BorderSizePixel = 0;
    color_frame.Size = UDim2.new(1, 0, 0, 180);
    color_frame.ClipsDescendants = true;
    color_frame.Parent = parent;
    
    local frame_stroke = Instance.new("UIStroke");
    frame_stroke.Color = colors.border;
    frame_stroke.Thickness = 1;
    frame_stroke.Parent = color_frame;
    
    local frame_corner = Instance.new("UICorner");
    frame_corner.CornerRadius = UDim.new(0, 4);
    frame_corner.Parent = color_frame;
    
    -- Title
    local color_title = Instance.new("TextLabel");
    color_title.Name = "title";
    color_title.BackgroundTransparency = 1;
    color_title.Position = UDim2.new(0, 10, 0, 8);
    color_title.Size = UDim2.new(1, -20, 0, 20);
    color_title.Font = Enum.Font.GothamBold;
    color_title.Text = title or "Color";
    color_title.TextColor3 = colors.text_primary;
    color_title.TextSize = 14;
    color_title.TextXAlignment = Enum.TextXAlignment.Left;
    color_title.Parent = color_frame;
    
    -- Color wheel (HSV circle)
    local wheel = Instance.new("ImageLabel");
    wheel.Name = "wheel";
    wheel.BackgroundTransparency = 1;
    wheel.Position = UDim2.new(0, 15, 0, 35);
    wheel.Size = UDim2.new(0, 120, 0, 120);
    wheel.Image = "rbxassetid://6020299385"; -- Color wheel asset
    wheel.Parent = color_frame;
    
    -- Color wheel cursor
    local wheel_cursor = Instance.new("Frame");
    wheel_cursor.Name = "cursor";
    wheel_cursor.AnchorPoint = Vector2.new(0.5, 0.5);
    wheel_cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    wheel_cursor.BorderSizePixel = 0;
    wheel_cursor.Position = UDim2.new(0.5, 0, 0.5, 0);
    wheel_cursor.Size = UDim2.new(0, 8, 0, 8);
    wheel_cursor.ZIndex = 10;
    wheel_cursor.Parent = wheel;
    
    local cursor_corner = Instance.new("UICorner");
    cursor_corner.CornerRadius = UDim.new(1, 0);
    cursor_corner.Parent = wheel_cursor;
    
    local cursor_stroke = Instance.new("UIStroke");
    cursor_stroke.Color = Color3.fromRGB(0, 0, 0);
    cursor_stroke.Thickness = 1;
    cursor_stroke.Parent = wheel_cursor;
    
    -- Brightness slider
    local brightness_frame = Instance.new("Frame");
    brightness_frame.Name = "brightness";
    brightness_frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    brightness_frame.BorderSizePixel = 0;
    brightness_frame.Position = UDim2.new(0, 145, 0, 35);
    brightness_frame.Size = UDim2.new(0, 30, 0, 120);
    brightness_frame.Parent = color_frame;
    
    local brightness_corner = Instance.new("UICorner");
    brightness_corner.CornerRadius = UDim.new(0, 4);
    brightness_corner.Parent = brightness_frame;
    
    local brightness_gradient = Instance.new("UIGradient");
    brightness_gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    });
    brightness_gradient.Rotation = 90;
    brightness_gradient.Parent = brightness_frame;
    
    -- Brightness slider cursor
    local brightness_cursor = Instance.new("Frame");
    brightness_cursor.Name = "cursor";
    brightness_cursor.AnchorPoint = Vector2.new(0.5, 0.5);
    brightness_cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    brightness_cursor.BorderSizePixel = 0;
    brightness_cursor.Position = UDim2.new(0.5, 0, 0, 0);
    brightness_cursor.Size = UDim2.new(1, 6, 0, 6);
    brightness_cursor.ZIndex = 10;
    brightness_cursor.Parent = brightness_frame;
    
    local brightness_cursor_corner = Instance.new("UICorner");
    brightness_cursor_corner.CornerRadius = UDim.new(1, 0);
    brightness_cursor_corner.Parent = brightness_cursor;
    
    local brightness_cursor_stroke = Instance.new("UIStroke");
    brightness_cursor_stroke.Color = Color3.fromRGB(0, 0, 0);
    brightness_cursor_stroke.Thickness = 1;
    brightness_cursor_stroke.Parent = brightness_cursor;
    
    -- Preview box
    local preview = Instance.new("Frame");
    preview.Name = "preview";
    preview.BackgroundColor3 = current_color or Color3.fromRGB(255, 0, 0);
    preview.BorderSizePixel = 0;
    preview.Position = UDim2.new(0, 190, 0, 35);
    preview.Size = UDim2.new(0.4, -200, 0, 50);
    preview.Parent = color_frame;
    
    local preview_corner = Instance.new("UICorner");
    preview_corner.CornerRadius = UDim.new(0, 4);
    preview_corner.Parent = preview;
    
    local preview_stroke = Instance.new("UIStroke");
    preview_stroke.Color = Color3.fromRGB(100, 100, 100);
    preview_stroke.Thickness = 1;
    preview_stroke.Parent = preview;
    
    -- RGB values
    local r_value = Instance.new("TextLabel");
    r_value.Name = "r_value";
    r_value.BackgroundTransparency = 1;
    r_value.Position = UDim2.new(0, 190, 0, 95);
    r_value.Size = UDim2.new(0.4, -200, 0, 20);
    r_value.Font = Enum.Font.Gotham;
    r_value.Text = "R: 255";
    r_value.TextColor3 = colors.text_secondary;
    r_value.TextSize = 12;
    r_value.TextXAlignment = Enum.TextXAlignment.Left;
    r_value.Parent = color_frame;
    
    local g_value = Instance.new("TextLabel");
    g_value.Name = "g_value";
    g_value.BackgroundTransparency = 1;
    g_value.Position = UDim2.new(0, 190, 0, 115);
    g_value.Size = UDim2.new(0.4, -200, 0, 20);
    g_value.Font = Enum.Font.Gotham;
    g_value.Text = "G: 0";
    g_value.TextColor3 = colors.text_secondary;
    g_value.TextSize = 12;
    g_value.TextXAlignment = Enum.TextXAlignment.Left;
    g_value.Parent = color_frame;
    
    local b_value = Instance.new("TextLabel");
    b_value.Name = "b_value";
    b_value.BackgroundTransparency = 1;
    b_value.Position = UDim2.new(0, 190, 0, 135);
    b_value.Size = UDim2.new(0.4, -200, 0, 20);
    b_value.Font = Enum.Font.Gotham;
    b_value.Text = "B: 0";
    b_value.TextColor3 = colors.text_secondary;
    b_value.TextSize = 12;
    b_value.TextXAlignment = Enum.TextXAlignment.Left;
    b_value.Parent = color_frame;
    
    -- Variables for color calculation
    local hue, sat, val = 0, 1, 1;
    local current_color = current_color or Color3.fromRGB(255, 0, 0);
    
    -- Get initial HSV from current color
    local h, s, v = Color3.toHSV(current_color);
    hue, sat, val = h, s, v;
    
    -- Position cursors based on initial color
    local angle = hue * math.pi * 2;
    local radius = sat * 60;
    wheel_cursor.Position = UDim2.new(0.5 + math.cos(angle) * radius / 60, 0, 0.5 + math.sin(angle) * radius / 60, 0);
    brightness_cursor.Position = UDim2.new(0.5, 0, 1 - val, 0);
    
    -- Update the color display
    local function update_color()
        local color = Color3.fromHSV(hue, sat, val);
        preview.BackgroundColor3 = color;
        brightness_gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 0))
        });
        
        -- Update RGB text
        local r, g, b = math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5);
        r_value.Text = "R: " .. r;
        g_value.Text = "G: " .. g;
        b_value.Text = "B: " .. b;
        
        -- Call callback with the new color
        if callback then
            callback(color);
        end
    end
    
    -- Wheel interaction
    local wheel_dragging = false;
    
    wheel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            wheel_dragging = true;
            
            -- Calculate hue and saturation from mouse position
            local center = Vector2.new(wheel.AbsolutePosition.X + wheel.AbsoluteSize.X / 2, wheel.AbsolutePosition.Y + wheel.AbsoluteSize.Y / 2);
            local radius = wheel.AbsoluteSize.X / 2;
            local mouse_pos = Vector2.new(input.Position.X, input.Position.Y);
            local direction = (mouse_pos - center).Unit;
            local distance = math.min((mouse_pos - center).Magnitude, radius);
            
            -- Set cursor position
            local offset = direction * distance;
            wheel_cursor.Position = UDim2.new(0.5 + offset.X / radius, 0, 0.5 + offset.Y / radius, 0);
            
            -- Calculate hue and saturation
            hue = (math.atan2(offset.Y, offset.X) / (math.pi * 2)) % 1;
            sat = distance / radius;
            
            update_color();
        end
    end);
    
    wheel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and wheel_dragging then
            -- Calculate hue and saturation from mouse position
            local center = Vector2.new(wheel.AbsolutePosition.X + wheel.AbsoluteSize.X / 2, wheel.AbsolutePosition.Y + wheel.AbsoluteSize.Y / 2);
            local radius = wheel.AbsoluteSize.X / 2;
            local mouse_pos = Vector2.new(input.Position.X, input.Position.Y);
            local direction = (mouse_pos - center).Unit;
            local distance = math.min((mouse_pos - center).Magnitude, radius);
            
            -- Set cursor position
            local offset = direction * distance;
            wheel_cursor.Position = UDim2.new(0.5 + offset.X / radius, 0, 0.5 + offset.Y / radius, 0);
            
            -- Calculate hue and saturation
            hue = (math.atan2(offset.Y, offset.X) / (math.pi * 2)) % 1;
            sat = distance / radius;
            
            update_color();
        end
    end);
    
    -- Brightness slider interaction
    local brightness_dragging = false;
    
    brightness_frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            brightness_dragging = true;
            
            -- Calculate value from mouse position
            local relative_pos = (input.Position.Y - brightness_frame.AbsolutePosition.Y) / brightness_frame.AbsoluteSize.Y;
            val = 1 - math.clamp(relative_pos, 0, 1);
            
            -- Set cursor position
            brightness_cursor.Position = UDim2.new(0.5, 0, relative_pos, 0);
            
            update_color();
        end
    end);
    
    brightness_frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and brightness_dragging then
            -- Calculate value from mouse position
            local relative_pos = (input.Position.Y - brightness_frame.AbsolutePosition.Y) / brightness_frame.AbsoluteSize.Y;
            relative_pos = math.clamp(relative_pos, 0, 1);
            val = 1 - relative_pos;
            
            -- Set cursor position
            brightness_cursor.Position = UDim2.new(0.5, 0, relative_pos, 0);
            
            update_color();
        end
    end);
    
    -- Stop dragging on input end
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            wheel_dragging = false;
            brightness_dragging = false;
        end
    end);
    
    -- Initial update
    update_color();
    
    return color_frame;
end

return {
    colors = colors,
    create_color_wheel = create_color_wheel
}