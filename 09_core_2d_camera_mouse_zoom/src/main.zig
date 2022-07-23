const c = @cImport({
    @cInclude("raylib.h");
    @cInclude("rlgl.h");
    @cInclude("raymath.h");
});

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera mouse zoom");

    var camera: c.Camera2D = undefined;

    camera.zoom = 1.0;

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        // Translate based on mouse right click
        if (c.IsMouseButtonDown(c.MOUSE_BUTTON_RIGHT))
        {
            var delta = c.GetMouseDelta();
            delta = c.Vector2Scale(delta, -1.0/camera.zoom);

            camera.target = c.Vector2Add(camera.target, delta);
        }

        // Zoom based on mouse wheel
        var wheel = c.GetMouseWheelMove();
        if (wheel != 0)
        {
            // Get the world point that is under the mouse
            var mouseWorldPos = c.GetScreenToWorld2D(c.GetMousePosition(), camera);
            
            // Set the offset to where the mouse is
            camera.offset = c.GetMousePosition();

            // Set the target to match, so that the camera maps the world space point 
            // under the cursor to the screen space point under the cursor at any zoom
            camera.target = mouseWorldPos;

            // Zoom increment
            const zoomIncrement = 0.125;

            camera.zoom += (wheel*zoomIncrement);
            if (camera.zoom < zoomIncrement) camera.zoom = zoomIncrement;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();
            c.ClearBackground(c.BLACK);

            c.BeginMode2D(camera);

                // Draw the 3d grid, rotated 90 degrees and centered around 0,0 
                // just so we have something in the XY plane
                c.rlPushMatrix();
                    c.rlTranslatef(0, 25*50, 0);
                    c.rlRotatef(90, 1, 0, 0);
                    c.DrawGrid(100, 50);
                c.rlPopMatrix();

                // Draw a reference circle
                c.DrawCircle(100, 100, 50, c.YELLOW);
                
            c.EndMode2D();

            c.DrawText("Mouse right button drag to move, mouse wheel to zoom", 10, 10, 20, c.WHITE);
        
        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
