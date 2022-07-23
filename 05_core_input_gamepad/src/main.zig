const c = @cImport(@cInclude("raylib.h"));
const platform = @cImport({
    // NOTE: Gamepad name ID depends on drivers and OS
    @cDefine("XBOX360_LEGACY_NAME_ID", "\"Xbox Controller\"");

    if (@hasDecl(c, "PLATFORM_RPI")) {
        @cDefine("XBOX360_NAME_ID", "\"Microsoft X-Box 360 pad\"");
        @cDefine("PS3_NAME_ID", "\"PLAYSTATION(R)3 Controller\"");
    } else {
        @cDefine("XBOX360_NAME_ID", "\"Xbox 360 Controller\"");
        @cDefine("PS3_NAME_ID", "\"PLAYSTATION(R)3 Controller\"");
    }
});

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------

    c.SetConfigFlags(c.FLAG_MSAA_4X_HINT); // Set MSAA 4X hint before windows creation

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - gamepad input");

    const texPs3Pad = c.LoadTexture("resources/ps3.png");

    const texXboxPad = c.LoadTexture("resources/xbox.png");

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);

        if (c.IsGamepadAvailable(0)) {
            c.DrawText(c.TextFormat("GP1: %s", c.GetGamepadName(0)), 10, 10, 10, c.BLACK);

            if (c.TextIsEqual(c.GetGamepadName(0), platform.XBOX360_NAME_ID) or c.TextIsEqual(c.GetGamepadName(0), platform.XBOX360_LEGACY_NAME_ID)) {
                c.DrawTexture(texXboxPad, 0, 0, c.DARKGRAY);

                // Draw buttons: xbox home
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_MIDDLE)) c.DrawCircle(394, 89, 19, c.RED);

                // Draw buttons: basic
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_MIDDLE_RIGHT)) c.DrawCircle(436, 150, 9, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_MIDDLE_LEFT)) c.DrawCircle(352, 150, 9, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_LEFT)) c.DrawCircle(501, 151, 15, c.BLUE);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_DOWN)) c.DrawCircle(536, 187, 15, c.LIME);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) c.DrawCircle(572, 151, 15, c.MAROON);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_UP)) c.DrawCircle(536, 115, 15, c.GOLD);

                // Draw buttons: d-pad
                c.DrawRectangle(317, 202, 19, 71, c.BLACK);
                c.DrawRectangle(293, 228, 69, 19, c.BLACK);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_UP)) c.DrawRectangle(317, 202, 19, 26, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_DOWN)) c.DrawRectangle(317, 202 + 45, 19, 26, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_LEFT)) c.DrawRectangle(292, 228, 25, 19, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_RIGHT)) c.DrawRectangle(292 + 44, 228, 26, 19, c.RED);

                // Draw buttons: left-right back
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_TRIGGER_1)) c.DrawCircle(259, 61, 20, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_TRIGGER_1)) c.DrawCircle(536, 61, 20, c.RED);

                // Draw axis: left joystick
                c.DrawCircle(259, 152, 39, c.BLACK);
                c.DrawCircle(259, 152, 34, c.LIGHTGRAY);
                c.DrawCircle(259 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_LEFT_X) * 20)), 152 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_LEFT_Y) * 20)), 25, c.BLACK);

                // Draw axis: right joystick
                c.DrawCircle(461, 237, 38, c.BLACK);
                c.DrawCircle(461, 237, 33, c.LIGHTGRAY);
                c.DrawCircle(461 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_RIGHT_X) * 20)), 237 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_RIGHT_Y) * 20)), 25, c.BLACK);

                // Draw axis: left-right triggers
                c.DrawRectangle(170, 30, 15, 70, c.GRAY);
                c.DrawRectangle(604, 30, 15, 70, c.GRAY);
                c.DrawRectangle(170, 30, 15, @floatToInt(i32, (((1 + c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_LEFT_TRIGGER)) / 2) * 70)), c.RED);
                c.DrawRectangle(604, 30, 15, @floatToInt(i32, (((1 + c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_RIGHT_TRIGGER)) / 2) * 70)), c.RED);

                //DrawText(TextFormat("Xbox axis LT: %02.02f", GetGamepadAxisMovement(0, GAMEPAD_AXIS_LEFT_TRIGGER)), 10, 40, 10, BLACK);
                //DrawText(TextFormat("Xbox axis RT: %02.02f", GetGamepadAxisMovement(0, GAMEPAD_AXIS_RIGHT_TRIGGER)), 10, 60, 10, BLACK);
            } else if (c.TextIsEqual(c.GetGamepadName(0), platform.PS3_NAME_ID)) {
                c.DrawTexture(texPs3Pad, 0, 0, c.DARKGRAY);

                // Draw buttons: ps
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_MIDDLE)) c.DrawCircle(396, 222, 13, c.RED);

                // Draw buttons: basic
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_MIDDLE_LEFT)) c.DrawRectangle(328, 170, 32, 13, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_MIDDLE_RIGHT)) c.DrawTriangle(.{ .x = 436, .y = 168 }, .{ .x = 436, .y = 185 }, .{ .x = 464, .y = 177 }, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_UP)) c.DrawCircle(557, 144, 13, c.LIME);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) c.DrawCircle(586, 173, 13, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_DOWN)) c.DrawCircle(557, 203, 13, c.VIOLET);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_FACE_LEFT)) c.DrawCircle(527, 173, 13, c.PINK);

                // Draw buttons: d-pad
                c.DrawRectangle(225, 132, 24, 84, c.BLACK);
                c.DrawRectangle(195, 161, 84, 25, c.BLACK);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_UP)) c.DrawRectangle(225, 132, 24, 29, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_DOWN)) c.DrawRectangle(225, 132 + 54, 24, 30, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_LEFT)) c.DrawRectangle(195, 161, 30, 25, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_FACE_RIGHT)) c.DrawRectangle(195 + 54, 161, 30, 25, c.RED);

                // Draw buttons: left-right back buttons
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_LEFT_TRIGGER_1)) c.DrawCircle(239, 82, 20, c.RED);
                if (c.IsGamepadButtonDown(0, c.GAMEPAD_BUTTON_RIGHT_TRIGGER_1)) c.DrawCircle(557, 82, 20, c.RED);

                // Draw axis: left joystick
                c.DrawCircle(319, 255, 35, c.BLACK);
                c.DrawCircle(319, 255, 31, c.LIGHTGRAY);
                c.DrawCircle(319 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_LEFT_X) * 20)), 255 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_LEFT_Y) * 20)), 25, c.BLACK);

                // Draw axis: right joystick
                c.DrawCircle(475, 255, 35, c.BLACK);
                c.DrawCircle(475, 255, 31, c.LIGHTGRAY);
                c.DrawCircle(475 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_RIGHT_X) * 20)), 255 + @floatToInt(i32, (c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_RIGHT_Y) * 20)), 25, c.BLACK);

                // Draw axis: left-right triggers
                c.DrawRectangle(169, 48, 15, 70, c.GRAY);
                c.DrawRectangle(611, 48, 15, 70, c.GRAY);
                c.DrawRectangle(169, 48, 15, @floatToInt(i32, (((1 - c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_LEFT_TRIGGER)) / 2) * 70)), c.RED);
                c.DrawRectangle(611, 48, 15, @floatToInt(i32, (((1 - c.GetGamepadAxisMovement(0, c.GAMEPAD_AXIS_RIGHT_TRIGGER)) / 2) * 70)), c.RED);
            } else {
                c.DrawText("- GENERIC c.GAMEPAD -", 280, 180, 20, c.GRAY);

                // TODO: Draw generic gamepad
            }

            c.DrawText(c.TextFormat("DETECTED AXIS [%i]:", c.GetGamepadAxisCount(0)), 10, 50, 10, c.MAROON);

            var i: i32 = 0;
            while (i < c.GetGamepadAxisCount(0)) : (i += 1) {
                c.DrawText(c.TextFormat("AXIS %i: %.02f", i, c.GetGamepadAxisMovement(0, i)), 20, 70 + 20 * i, 10, c.DARKGRAY);
            }

            if (c.GetGamepadButtonPressed() != -1) {
                c.DrawText(c.TextFormat("DETECTED BUTTON: %i", c.GetGamepadButtonPressed()), 10, 430, 10, c.RED);
            } else c.DrawText("DETECTED BUTTON: NONE", 10, 430, 10, c.GRAY);
        } else {
            c.DrawText("GP1: NOT DETECTED", 10, 10, 10, c.GRAY);

            c.DrawTexture(texXboxPad, 0, 0, c.LIGHTGRAY);
        }

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------

    c.UnloadTexture(texPs3Pad);

    c.UnloadTexture(texXboxPad);

    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
