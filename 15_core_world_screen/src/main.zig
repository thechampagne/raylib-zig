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
    var camera: c.Camera = undefined;
    camera.position = .{ .x = 10.0, .y = 10.0, .z = 10.0 };
    camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 };
    camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
    camera.fovy = 45.0;
    camera.projection = c.CAMERA_PERSPECTIVE;

    var cubePosition = c.Vector3{ .x = 0.0, .y = 0.0, .z = 0.0 };
    var cubeScreenPosition = c.Vector2{ .x = 0.0, .y = 0.0 };

    c.SetCameraMode(camera, c.CAMERA_FREE); // Set a free camera mode

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera);          // Update camera

        // Calculate cube screen space position (with a little offset to be in top)
        cubeScreenPosition = c.GetWorldToScreen(.{ .x = cubePosition.x, .y = cubePosition.y + 2.5, .z = cubePosition.z}, camera);
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

            c.DrawText("Enemy: 100 / 100", @divExact(@floatToInt(i32, cubeScreenPosition.x) - c.MeasureText("Enemy: 100/100", 20), 2), @floatToInt(i32, cubeScreenPosition.y), 20, c.BLACK);
            c.DrawText("Text is always on top of the cube", @divExact((screenWidth - c.MeasureText("Text is always on top of the cube", 20)), 2), 25, 20, c.GRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
