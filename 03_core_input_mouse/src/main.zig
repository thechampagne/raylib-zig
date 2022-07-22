const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - mouse input");

    var ballPosition = c.Vector2{ .x = @as(f32, -100.0), .y = @as(f32, -100.0) };

    var ballColor = c.DARKBLUE;

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        ballPosition = c.GetMousePosition();

        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT)) { ballColor = c.MAROON; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_MIDDLE)) { ballColor = c.LIME; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_RIGHT)) { ballColor = c.DARKBLUE; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_SIDE)) { ballColor = c.PURPLE; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_EXTRA)) { ballColor = c.YELLOW; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_FORWARD)) { ballColor = c.ORANGE; }
        else if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_BACK)) { ballColor = c.BEIGE; }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawCircleV(ballPosition, 40, ballColor);

        c.DrawText("move ball with mouse and click mouse button to change color", 10, 10, 20, c.DARKGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
