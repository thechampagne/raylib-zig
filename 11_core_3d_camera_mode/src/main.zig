const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera mode");

    // Define the camera to look into our 3d world
    var camera: c.Camera3D = undefined;
    camera.position = .{ .x = 0.0, . y = 10.0, .z = 10.0 };  // Camera position
    camera.target = .{ .x = 0.0, . y = 0.0, .z = 0.0 };      // Camera looking at point
    camera.up = .{ .x = 0.0, . y = 1.0, .z = 0.0 };          // Camera up vector (rotation towards target)
    camera.fovy = 45.0;                                // Camera field-of-view Y
    camera.projection = c.CAMERA_PERSPECTIVE;             // Camera mode type

    var cubePosition = .{ .x = 0.0, .y = 0.0, .z = 0.0 };

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

            c.BeginMode3D(camera);

                c.DrawCube(cubePosition, 2.0, 2.0, 2.0, c.RED);
                c.DrawCubeWires(cubePosition, 2.0, 2.0, 2.0, c.MAROON);

                c.DrawGrid(10, 1.0);

            c.EndMode3D();

            c.DrawText("Welcome to the third dimension!", 10, 40, 20, c.DARKGRAY);

            c.DrawFPS(10, 10);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
