Controls = {
    Enter = 0xCEFD9220,
    Up = 0x6319DB71,
    Down = 0x05CA7C52,
    Left = 0xA65EBAB4,
    Right = 0xDEB34313,
    Plus = 0x6FED71BC,
    Min = 0x51104035,
    Backspace = 0x5B48F938
}

Positions = {
    marker = {
        active = false,
        x = 0.0,
        y = 0.0,
        z = 0.0,
        h = 0.0,
        r = 1.0
    }
}

Positions.start = function()
    if (Positions.marker.active) then
        return
    end

    local playerPedId = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPedId)

    Positions.marker.x = math.floor(playerCoords.x * 100) / 100
    Positions.marker.y = math.floor(playerCoords.y * 100) / 100
    Positions.marker.z = math.floor(playerCoords.z * 100) / 100
    Positions.marker.h = GetEntityHeading(playerPedId)
    Positions.marker.r = 1.0

    Positions.marker.h = Positions.marker.h + 0.5

    if (Positions.marker.h > 360) then
        Positions.marker.h = 0.0
    elseif (Positions.marker.h < 0) then
        Positions.marker.h = 360.0
    end

    Positions.marker.active = true
end

Positions.stop = function()
    Positions.marker = {
        active = false,
        x = 0.0,
        y = 0.0,
        z = 0.0,
        h = 0.0,
        r = 1.0
    }
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if (IsControlJustPressed(0, Controls.Enter) and not Positions.marker.active) then
            Positions.start()
        elseif (IsControlJustPressed(0, Controls.Backspace) and Positions.marker.active) then
            Positions.stop()
        end

        if (IsControlPressed(0, Controls.Up) and Positions.marker.active) then
            Positions.marker.x = Positions.marker.x + 0.01
        end

        if (IsControlPressed(0, Controls.Down) and Positions.marker.active) then
            Positions.marker.x = Positions.marker.x - 0.01
        end

        if (IsControlPressed(0, Controls.Left) and Positions.marker.active) then
            Positions.marker.y = Positions.marker.y + 0.01
        end

        if (IsControlPressed(0, Controls.Right) and Positions.marker.active) then
            Positions.marker.y = Positions.marker.y - 0.01
        end

        if (IsControlPressed(0, Controls.Plus) and Positions.marker.active) then
            Positions.marker.z = Positions.marker.z + 0.01
        end

        if (IsControlPressed(0, Controls.Min) and Positions.marker.active) then
            Positions.marker.z = Positions.marker.z - 0.01
        end
    end
end)

function DrawScaleText(text, x, y, size, r, g, b, a)
    local xc = x / 1.0;
    local yc = y / 1.0;

    SetScriptGfxDrawOrder(3)
    SetTextScale(size, size)
    SetTextCentre(true)
    SetTextColor(r, g, b, a)
    SetTextFontForCurrentCommand(1)
    DisplayText(CreateVarString(10, 'LITERAL_STRING', text), xc, yc)
    SetScriptGfxDrawOrder(3)
end

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)

        if (Positions.marker.active) then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, Positions.marker.x, Positions.marker.y, Positions.marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 250, 0, 0, 100, false, true, 2, false, false, false, false)

            local text = "{ x = "..Positions.marker.x..", y = "..Positions.marker.y..", z = "..Positions.marker.z..", h = "..Positions.marker.h.." }"

            DrawScaleText(text, 0.5, 0.9, 0.8, 255, 255, 255, 100)
        end
    end
end)