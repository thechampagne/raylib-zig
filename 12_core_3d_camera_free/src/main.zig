const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free");

    // Define the camera to look into our 3d world
    var camera: c.Camera3D = undefined;
    camera.position = .{ .x = 10.0, .y = 10.0, .z = 10.0 }; // Camera position
    camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 };      // Camera looking at point
    camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 };          // Camera up vector (rotation towards target)
    camera.fovy = 45.0;                                // Camera field-of-view Y
    camera.projection = c.CAMERA_PERSPECTIVE;                   // Camera mode type

    var cubePosition: c.Vector3 = .{ .x = 0.0, .y = 0.0, .z = 0.0 };

    c.SetCameraMode(camera, c.CAMERA_FREE); // Set a free camera mode

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera);          // Update camera

        if (c.IsKeyDown('Z')) camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
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

            c.DrawRectangle( 10, 10, 320, 133, c.Fade(c.SKYBLUE, 0.5));
            c.DrawRectangleLines( 10, 10, 320, 133, c.BLUE);

            c.DrawText("Free camera default controls:", 20, 20, 10, c.BLACK);
            c.DrawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, c.DARKGRAY);
            c.DrawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, c.DARKGRAY);
            c.DrawText("- Alt + Mouse Wheel Pressed to Rotate", 40, 80, 10, c.DARKGRAY);
            c.DrawText("- Alt + Ctrl + Mouse Wheel Pressed for Smooth Zoom", 40, 100, 10, c.DARKGRAY);
            c.DrawText("- Z to zoom to (0, 0, 0)", 40, 120, 10, c.DARKGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
