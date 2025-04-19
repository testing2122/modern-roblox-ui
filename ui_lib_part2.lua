        -- Create button function for tab with embedded description
        function tab:create_button(btn_cfg)
            btn_cfg = btn_cfg or {};
            
            -- Main button container
            local button = Instance.new("TextButton");
            button.Name = btn_cfg.name or "button";
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            button.BorderSizePixel = 0;
            button.Size = UDim2.new(1, 0, 0, btn_cfg.description and 45 or 30); -- Taller if description
            button.Text = "";
            button.AutoButtonColor = false;
            button.ClipsDescendants = true; -- For ripple effect
            button.Parent = page;
            
            local button_stroke = Instance.new("UIStroke");
            button_stroke.Color = Color3.fromRGB(60, 60, 60);
            button_stroke.Thickness = 1;
            button_stroke.Parent = button;
            
            local button_corner = Instance.new("UICorner");
            button_corner.CornerRadius = UDim.new(0, 4);
            button_corner.Parent = button;
            
            -- Button title
            local btn_title = Instance.new("TextLabel");
            btn_title.Name = "title";
            btn_title.BackgroundTransparency = 1;
            btn_title.Position = UDim2.new(0, 10, 0, 0);
            btn_title.Size = UDim2.new(1, -20, 0, 30);
            btn_title.Font = Enum.Font.Gotham;
            btn_title.Text = btn_cfg.text or "button";
            btn_title.TextColor3 = Color3.fromRGB(230, 230, 230);
            btn_title.TextSize = 12;
            btn_title.TextXAlignment = Enum.TextXAlignment.Left;
            btn_title.Parent = button;
            
            -- Optional description (embedded)
            if btn_cfg.description then
                local description = Instance.new("TextLabel");
                description.Name = "description";
                description.BackgroundTransparency = 1;
                description.Position = UDim2.new(0, 10, 0, 26);
                description.Size = UDim2.new(1, -20, 0, 15);
                description.Font = Enum.Font.Gotham;
                description.Text = btn_cfg.description;
                description.TextColor3 = Color3.fromRGB(180, 180, 180);
                description.TextSize = 10;
                description.TextXAlignment = Enum.TextXAlignment.Left;
                description.TextWrapped = true;
                description.Parent = button;
            end
            
            -- Add shine effect for hover
            create_shine(button);
            
            -- Add ripple effect for click
            button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    create_ripple(button, input.Position);
                end
            end);
            
            -- Connect callback
            button.MouseButton1Click:Connect(function()
                if btn_cfg.callback then
                    btn_cfg.callback();
                end
            end);
            
            return button;
        end
        
        -- Create toggle switch function with embedded description
        function tab:create_toggle(toggle_cfg)
            toggle_cfg = toggle_cfg or {};
            local toggle_state = toggle_cfg.default or false;
            
            -- Track toggle in flags
            if toggle_cfg.flag then
                lib.flags[toggle_cfg.flag] = toggle_state;
            end
            
            -- Main toggle container
            local toggle_frame = Instance.new("Frame");
            toggle_frame.Name = "toggle_frame";
            toggle_frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            toggle_frame.BorderSizePixel = 0;
            toggle_frame.Size = UDim2.new(1, 0, 0, toggle_cfg.description and 45 or 30); -- Taller if description
            toggle_frame.ClipsDescendants = true; -- For ripple effect
            toggle_frame.Parent = page;
            
            local frame_stroke = Instance.new("UIStroke");
            frame_stroke.Color = Color3.fromRGB(60, 60, 60);
            frame_stroke.Thickness = 1;
            frame_stroke.Parent = toggle_frame;
            
            local frame_corner = Instance.new("UICorner");
            frame_corner.CornerRadius = UDim.new(0, 4);
            frame_corner.Parent = toggle_frame;
            
            -- Toggle text
            local toggle_text = Instance.new("TextLabel");
            toggle_text.Name = "text";
            toggle_text.BackgroundTransparency = 1;
            toggle_text.Position = UDim2.new(0, 10, 0, 0);
            toggle_text.Size = UDim2.new(1, -60, 0, 30);
            toggle_text.Font = Enum.Font.Gotham;
            toggle_text.Text = toggle_cfg.text or "toggle";
            toggle_text.TextColor3 = Color3.fromRGB(230, 230, 230);
            toggle_text.TextSize = 12;
            toggle_text.TextXAlignment = Enum.TextXAlignment.Left;
            toggle_text.Parent = toggle_frame;
            
            -- Optional description (embedded)
            if toggle_cfg.description then
                local description = Instance.new("TextLabel");
                description.Name = "description";
                description.BackgroundTransparency = 1;
                description.Position = UDim2.new(0, 10, 0, 26);
                description.Size = UDim2.new(1, -60, 0, 15);
                description.Font = Enum.Font.Gotham;
                description.Text = toggle_cfg.description;
                description.TextColor3 = Color3.fromRGB(180, 180, 180);
                description.TextSize = 10;
                description.TextXAlignment = Enum.TextXAlignment.Left;
                description.TextWrapped = true;
                description.Parent = toggle_frame;
            end
            
            -- Toggle track (background)
            local track = Instance.new("Frame");
            track.Name = "track";
            track.AnchorPoint = Vector2.new(1, 0.5);
            track.BackgroundColor3 = toggle_state and colors.toggle_on or colors.toggle_off;
            track.BorderSizePixel = 0;
            track.Position = UDim2.new(1, -10, 0.5, 0); -- Centered vertically
            track.Size = UDim2.new(0, 40, 0, 18);
            track.Parent = toggle_frame;
            
            local track_corner = Instance.new("UICorner");
            track_corner.CornerRadius = UDim.new(1, 0);
            track_corner.Parent = track;
            
            -- Toggle knob (indicator)
            local knob = Instance.new("Frame");
            knob.Name = "knob";
            knob.AnchorPoint = Vector2.new(0, 0.5);
            knob.BackgroundColor3 = toggle_state and colors.toggle_knob_on or colors.toggle_knob_off;
            knob.BorderSizePixel = 0;
            knob.Position = toggle_state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0);
            knob.Size = UDim2.new(0, 14, 0, 14);
            knob.Parent = track;
            
            local knob_corner = Instance.new("UICorner");
            knob_corner.CornerRadius = UDim.new(1, 0);
            knob_corner.Parent = knob;
            
            -- Toggle hit box
            local hitbox = Instance.new("TextButton");
            hitbox.Name = "hitbox";
            hitbox.BackgroundTransparency = 1;
            hitbox.Size = UDim2.new(1, 0, 1, 0);
            hitbox.Text = "";
            hitbox.ZIndex = 10;
            hitbox.Parent = toggle_frame;
            
            -- Add ripple effect
            hitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    create_ripple(toggle_frame, input.Position);
                end
            end);
            
            -- Update toggle visual state
            local function update_toggle()
                if toggle_state then
                    ts:Create(track, toggle_tween, {BackgroundColor3 = colors.toggle_on}):Play();
                    ts:Create(knob, toggle_tween, {
                        Position = UDim2.new(1, -16, 0.5, 0), 
                        BackgroundColor3 = colors.toggle_knob_on
                    }):Play();
                else
                    ts:Create(track, toggle_tween, {BackgroundColor3 = colors.toggle_off}):Play();
                    ts:Create(knob, toggle_tween, {
                        Position = UDim2.new(0, 2, 0.5, 0), 
                        BackgroundColor3 = colors.toggle_knob_off
                    }):Play();
                end
                
                if toggle_cfg.flag then
                    lib.flags[toggle_cfg.flag] = toggle_state;
                end
                
                if toggle_cfg.callback then
                    toggle_cfg.callback(toggle_state);
                end
            end
            
            -- Connect toggle functionality
            hitbox.MouseButton1Click:Connect(function()
                toggle_state = not toggle_state;
                update_toggle();
            end);
            
            -- Public toggle API
            local toggle_api = {};
            
            function toggle_api:set_state(state)
                if toggle_state ~= state then
                    toggle_state = state;
                    update_toggle();
                end
            end
            
            function toggle_api:get_state()
                return toggle_state;
            end
            
            return toggle_api;
        end
        
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