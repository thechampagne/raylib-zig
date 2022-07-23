const c = @cImport(@cInclude("raylib.h"));

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d picking");

    // Define the camera to look into our 3d world
    var camera: c.Camera = undefined;
    camera.position = .{ .x = 10.0, .y = 10.0, .z = 10.0 }; // Camera position
    camera.target = .{ .x = 0.0, .y = 0.0, .z = 0.0 };      // Camera looking at point
    camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 };          // Camera up vector (rotation towards target)
    camera.fovy = 45.0;                                // Camera field-of-view Y
    camera.projection = c.CAMERA_PERSPECTIVE;                   // Camera mode type

    var cubePosition: c.Vector3 = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
    var cubeSize: c.Vector3 = .{ .x = 2.0, .y = 2.0, .z = 2.0 };

    var ray: c.Ray = undefined;                    // Picking line ray

    var collision: c.RayCollision = undefined;

    c.SetCameraMode(camera, c.CAMERA_FREE); // Set a free camera mode

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera);          // Update camera

        if (c.IsMouseButtonPressed(c.MOUSE_BUTTON_LEFT))
        {
            if (!collision.hit)
            {
                ray = c.GetMouseRay(c.GetMousePosition(), camera);

                // Check collision between ray and box
                collision = c.GetRayCollisionBox(ray,
                            .{ .min = .{ .x = cubePosition.x - cubeSize.x/2, .y = cubePosition.y - cubeSize.y/2, .z = cubePosition.z - cubeSize.z/2 },
                                          .max = .{ .x = cubePosition.x + cubeSize.x/2, .y = cubePosition.y + cubeSize.y/2, .z = cubePosition.z + cubeSize.z/2 }});
            }
            else collision.hit = false;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

            c.ClearBackground(c.RAYWHITE);

            c.BeginMode3D(camera);

                if (collision.hit)
                {
                    c.DrawCube(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, c.RED);
                    c.DrawCubeWires(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, c.MAROON);

                    c.DrawCubeWires(cubePosition, cubeSize.x + 0.2, cubeSize.y + 0.2, cubeSize.z + 0.2, c.GREEN);
                }
                else
                {
                    c.DrawCube(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, c.GRAY);
                    c.DrawCubeWires(cubePosition, cubeSize.x, cubeSize.y, cubeSize.z, c.DARKGRAY);
                }

                c.DrawRay(ray, c.MAROON);
                c.DrawGrid(10, 1.0);

            c.EndMode3D();

            c.DrawText("Try selecting the box with mouse!", 240, 10, 20, c.DARKGRAY);

            if (collision.hit) c.DrawText("BOX SELECTED", @divFloor((screenWidth - c.MeasureText("BOX SELECTED", 30)), 2), (screenHeight * 0.1), 30, c.GREEN);

            c.DrawFPS(10, 10);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
