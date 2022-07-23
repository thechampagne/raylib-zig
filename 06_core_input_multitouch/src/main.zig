const c = @cImport(@cInclude("raylib.h"));

const MAX_TOUCH_POINTS = 10;

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - input multitouch");

    var touchPositions: [MAX_TOUCH_POINTS]c.Vector2 = undefined;

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        // Get multiple touchpoints
        var i: usize = 0;
        while (i < MAX_TOUCH_POINTS) : ( i += 1) touchPositions[i] = c.GetTouchPosition(@intCast(i32, i));
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);

            var index: usize = 0;
            while (index < MAX_TOUCH_POINTS) : ( index += 1)
            {
                // Make sure point is not (0, 0) as this means there is no touch for it
                if ((touchPositions[index].x > 0) and (touchPositions[index].y > 0))
                {
                    // Draw circle and touch index number
                    c.DrawCircleV(touchPositions[index], 34, c.ORANGE);
                    c.DrawText(c.TextFormat("%d", index), @floatToInt(i32, touchPositions[index].x - 10), @floatToInt(i32, touchPositions[index].y - 70), 40, c.BLACK);
                }
            }

            c.DrawText("touch the screen at multiple locations to get multiple balls", 10, 10, 20, c.DARKGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
