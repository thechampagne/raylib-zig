const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - input mouse wheel");

    var boxPositionY: i32 = screenHeight/2 - 40;

    var scrollSpeed: i32 = 4;            // Scrolling speed in pixels

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        boxPositionY -= @floatToInt(i32, (c.GetMouseWheelMove()* @intToFloat(f32, scrollSpeed)));
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);
        
        c.DrawRectangle(screenWidth/2 - 40, boxPositionY, 80, 80, c.MAROON);

        c.DrawText("Use mouse wheel to move the cube up and down!", 10, 10, 20, c.GRAY);

        c.DrawText(c.TextFormat("Box position Y: %03i", boxPositionY), 10, 40, 20, c.LIGHTGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
