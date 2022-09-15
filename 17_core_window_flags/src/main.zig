const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------


    // Possible window flags
    // FLAG_VSYNC_HINT
    // FLAG_FULLSCREEN_MODE    -> not working properly -> wrong scaling!
    // FLAG_WINDOW_RESIZABLE
    // FLAG_WINDOW_UNDECORATED
    // FLAG_WINDOW_TRANSPARENT
    // FLAG_WINDOW_HIDDEN
    // FLAG_WINDOW_MINIMIZED   -> Not supported on window creation
    // FLAG_WINDOW_MAXIMIZED   -> Not supported on window creation
    // FLAG_WINDOW_UNFOCUSED
    // FLAG_WINDOW_TOPMOST
    // FLAG_WINDOW_HIGHDPI     -> errors after minimize-resize, fb size is recalculated
    // FLAG_WINDOW_ALWAYS_RUN
    // FLAG_MSAA_4X_HINT

    // Set configuration flags for window creation
    //SetConfigFlags(FLAG_VSYNC_HINT | FLAG_MSAA_4X_HINT | FLAG_WINDOW_HIGHDPI);
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - window flags");

    var ballPosition = c.Vector2{ .x = @intToFloat(f32, c.GetScreenWidth()) / 2.0, .y = @intToFloat(f32, c.GetScreenHeight()) / 2.0 };
    var ballSpeed = c.Vector2{ .x = 5.0, .y = 4.0 };
    var ballRadius: f32 = 20;

    var framesCounter: i32 = 0;

    //SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //-----------------------------------------------------
        if (c.IsKeyPressed(c.KEY_F)) c.ToggleFullscreen();  // modifies window size when scaling!

        if (c.IsKeyPressed(c.KEY_R))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_RESIZABLE)) { c.ClearWindowState(c.FLAG_WINDOW_RESIZABLE); }
            else { c.SetWindowState(c.FLAG_WINDOW_RESIZABLE); }
        }

        if (c.IsKeyPressed(c.KEY_D))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_UNDECORATED)) { c.ClearWindowState(c.FLAG_WINDOW_UNDECORATED); }
            else { c.SetWindowState(c.FLAG_WINDOW_UNDECORATED); }
        }

        if (c.IsKeyPressed(c.KEY_H))
        {
            if (!c.IsWindowState(c.FLAG_WINDOW_HIDDEN)) c.SetWindowState(c.FLAG_WINDOW_HIDDEN);

            framesCounter = 0;
        }

        if (c.IsWindowState(c.FLAG_WINDOW_HIDDEN))
        {
            framesCounter += 1;
            if (framesCounter >= 240) c.ClearWindowState(c.FLAG_WINDOW_HIDDEN); // Show window after 3 seconds
        }

        if (c.IsKeyPressed(c.KEY_N))
        {
            if (!c.IsWindowState(c.FLAG_WINDOW_MINIMIZED)) c.MinimizeWindow();

            framesCounter = 0;
        }

        if (c.IsWindowState(c.FLAG_WINDOW_MINIMIZED))
        {
            framesCounter += 1;
            if (framesCounter >= 240) c.RestoreWindow(); // Restore window after 3 seconds
        }

        if (c.IsKeyPressed(c.KEY_M))
        {
            // NOTE: Requires FLAG_WINDOW_RESIZABLE enabled!
            if (c.IsWindowState(c.FLAG_WINDOW_MAXIMIZED)) { c.RestoreWindow(); }
            else { c.MaximizeWindow(); }
        }

        if (c.IsKeyPressed(c.KEY_U))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_UNFOCUSED)) { c.ClearWindowState(c.FLAG_WINDOW_UNFOCUSED); }
            else { c.SetWindowState(c.FLAG_WINDOW_UNFOCUSED); }
        }

        if (c.IsKeyPressed(c.KEY_T))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_TOPMOST)) { c.ClearWindowState(c.FLAG_WINDOW_TOPMOST); }
            else { c.SetWindowState(c.FLAG_WINDOW_TOPMOST); }
        }

        if (c.IsKeyPressed(c.KEY_A))
        {
            if (c.IsWindowState(c.FLAG_WINDOW_ALWAYS_RUN)) { c.ClearWindowState(c.FLAG_WINDOW_ALWAYS_RUN); }
            else { c.SetWindowState(c.FLAG_WINDOW_ALWAYS_RUN); }
        }

        if (c.IsKeyPressed(c.KEY_V))
        {
            if (c.IsWindowState(c.FLAG_VSYNC_HINT)) { c.ClearWindowState(c.FLAG_VSYNC_HINT); }
            else { c.SetWindowState(c.FLAG_VSYNC_HINT); }
        }

        // Bouncing ball logic
        ballPosition.x += ballSpeed.x;
        ballPosition.y += ballSpeed.y;
        if ((ballPosition.x >= @intToFloat(f32,c.GetScreenWidth() - @floatToInt(i32,ballRadius))) or (ballPosition.x <= ballRadius)) ballSpeed.x *= -1.0;
        if ((ballPosition.y >=  @intToFloat(f32,c.GetScreenHeight() - @floatToInt(i32,ballRadius))) or (ballPosition.y <= ballRadius)) ballSpeed.y *= -1.0;
        //-----------------------------------------------------

        // Draw
        //-----------------------------------------------------
        c.BeginDrawing();

        if (c.IsWindowState(c.FLAG_WINDOW_TRANSPARENT)) { c.ClearBackground(c.BLANK); }
        else { c.ClearBackground(c.RAYWHITE); }

        c.DrawCircleV(ballPosition, ballRadius, c.MAROON);
        c.DrawRectangleLinesEx(c.Rectangle{ .x = 0, .y = 0, .width = @intToFloat(f32,c.GetScreenWidth()), .height = @intToFloat(f32, c.GetScreenHeight()) }, 4, c.RAYWHITE);

        c.DrawCircleV(c.GetMousePosition(), 10, c.DARKBLUE);

        c.DrawFPS(10, 10);

        c.DrawText(c.TextFormat("Screen Size: [%i, %i]", c.GetScreenWidth(), c.GetScreenHeight()), 10, 40, 10, c.GREEN);

        // Draw window state info
        c.DrawText("Following flags can be set after window creation:", 10, 60, 10, c.GRAY);
        if (c.IsWindowState(c.FLAG_FULLSCREEN_MODE)) { c.DrawText("[F] FLAG_FULLSCREEN_MODE: on", 10, 80, 10, c.LIME); }
        else { c.DrawText("[F] FLAG_FULLSCREEN_MODE: off", 10, 80, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_RESIZABLE)) { c.DrawText("[R] FLAG_WINDOW_RESIZABLE: on", 10, 100, 10, c.LIME); }
        else { c.DrawText("[R] FLAG_WINDOW_RESIZABLE: off", 10, 100, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_UNDECORATED)) { c.DrawText("[D] FLAG_WINDOW_UNDECORATED: on", 10, 120, 10, c.LIME); }
        else { c.DrawText("[D] FLAG_WINDOW_UNDECORATED: off", 10, 120, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_HIDDEN)) { c.DrawText("[H] FLAG_WINDOW_HIDDEN: on", 10, 140, 10, c.LIME); }
        else { c.DrawText("[H] FLAG_WINDOW_HIDDEN: off", 10, 140, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_MINIMIZED)) { c.DrawText("[N] FLAG_WINDOW_MINIMIZED: on", 10, 160, 10, c.LIME); }
        else { c.DrawText("[N] FLAG_WINDOW_MINIMIZED: off", 10, 160, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_MAXIMIZED)) { c.DrawText("[M] FLAG_WINDOW_MAXIMIZED: on", 10, 180, 10, c.LIME); }
        else { c.DrawText("[M] FLAG_WINDOW_MAXIMIZED: off", 10, 180, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_UNFOCUSED)) { c.DrawText("[G] FLAG_WINDOW_UNFOCUSED: on", 10, 200, 10, c.LIME); }
        else { c.DrawText("[U] FLAG_WINDOW_UNFOCUSED: off", 10, 200, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_TOPMOST)) { c.DrawText("[T] FLAG_WINDOW_TOPMOST: on", 10, 220, 10, c.LIME); }
        else { c.DrawText("[T] FLAG_WINDOW_TOPMOST: off", 10, 220, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_ALWAYS_RUN)) { c.DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: on", 10, 240, 10, c.LIME); }
        else { c.DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: off", 10, 240, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_VSYNC_HINT)) { c.DrawText("[V] FLAG_VSYNC_HINT: on", 10, 260, 10, c.LIME); }
        else { c.DrawText("[V] FLAG_VSYNC_HINT: off", 10, 260, 10, c.MAROON); }

        c.DrawText("Following flags can only be set before window creation:", 10, 300, 10, c.GRAY);
        if (c.IsWindowState(c.FLAG_WINDOW_HIGHDPI)) { c.DrawText("FLAG_WINDOW_HIGHDPI: on", 10, 320, 10, c.LIME); }
        else { c.DrawText("FLAG_WINDOW_HIGHDPI: off", 10, 320, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_WINDOW_TRANSPARENT)) { c.DrawText("FLAG_WINDOW_TRANSPARENT: on", 10, 340, 10, c.LIME); }
        else { c.DrawText("FLAG_WINDOW_TRANSPARENT: off", 10, 340, 10, c.MAROON); }
        if (c.IsWindowState(c.FLAG_MSAA_4X_HINT)) { c.DrawText("FLAG_MSAA_4X_HINT: on", 10, 360, 10, c.LIME); }
        else { c.DrawText("FLAG_MSAA_4X_HINT: off", 10, 360, 10, c.MAROON); }

        c.EndDrawing();
        //-----------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
