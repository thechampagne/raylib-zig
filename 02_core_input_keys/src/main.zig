const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - keyboard input");

    var ballPosition = c.Vector2{ .x = @as(f32, screenWidth/2), .y = @as(f32, screenHeight/2) };

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        if (c.IsKeyDown(c.KEY_RIGHT)) ballPosition.x += @as(f32, 2.0);
        if (c.IsKeyDown(c.KEY_LEFT)) ballPosition.x -= @as(f32, 2.0);
        if (c.IsKeyDown(c.KEY_UP)) ballPosition.y -= @as(f32, 2.0);
        if (c.IsKeyDown(c.KEY_DOWN)) ballPosition.y += @as(f32, 2.0);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);

        c.DrawText("move the ball with arrow keys", 10, 10, 20, c.DARKGRAY);

        c.DrawCircleV(ballPosition, 50, c.MAROON);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
