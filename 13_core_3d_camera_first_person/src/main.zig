const c = @cImport(@cInclude("raylib.h"));

const MAX_COLUMNS = 20;

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person");

    // Define the camera to look into our 3d world (position, target, up vector)
    var camera: c.Camera = undefined;
    camera.position = .{ .x = 4.0, .y = 2.0, .z = 4.0 };
    camera.target = .{ .x = 0.0, .y = 1.8, .z = 0.0 };
    camera.up = .{ .x = 0.0, .y = 1.0, .z = 0.0 };
    camera.fovy = 60.0;
    camera.projection = c.CAMERA_PERSPECTIVE;

    // Generates some random columns
    var heights: [MAX_COLUMNS]f32 = undefined;
    var positions: [MAX_COLUMNS]c.Vector3 = undefined;
    var colors: [MAX_COLUMNS]c.Color = undefined;

    var i: usize = 0;
    while (i < MAX_COLUMNS) : (i += 1)
    {
        heights[i] =  @intToFloat(f32, c.GetRandomValue(1, 12));
        positions[i] = .{ .x = @intToFloat(f32, c.GetRandomValue(-15, 15)), .y = heights[i]/2.0, .z = @intToFloat(f32, c.GetRandomValue(-15, 15)) };
        colors[i] = .{ .r = @intCast(u8, c.GetRandomValue(20, 255)), .g = @intCast(u8, c.GetRandomValue(10, 55)), .b = 30, .a = 255 };
    }

    c.SetCameraMode(camera, c.CAMERA_FIRST_PERSON); // Set a first person camera mode

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        c.UpdateCamera(&camera);                  // Update camera
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

            c.ClearBackground(c.RAYWHITE);

            c.BeginMode3D(camera);

                c.DrawPlane(.{ .x = 0.0, .y = 0.0, .z = 0.0 }, .{ .x = 32.0, .y = 32.0 }, c.LIGHTGRAY); // Draw ground
                c.DrawCube(.{ .x = -16.0, .y = 2.5, .z = 0.0 }, 1.0, 5.0, 32.0, c.BLUE);     // Draw a blue wall
                c.DrawCube(.{ .x = 16.0, .y = 2.5, .z = 0.0 }, 1.0, 5.0, 32.0, c.LIME);      // Draw a green wall
                c.DrawCube(.{ .x = 0.0, .y = 2.5, .z = 16.0 }, 32.0, 5.0, 1.0, c.GOLD);      // Draw a yellow wall

                var index: usize = 0;
                // Draw some cubes around
                while (index < MAX_COLUMNS) : (index += 1)
                {
                    c.DrawCube(positions[index], 2.0, heights[index], 2.0, colors[index]);
                    c.DrawCubeWires(positions[index], 2.0, heights[index], 2.0, c.MAROON);
                }

            c.EndMode3D();

            c.DrawRectangle( 10, 10, 220, 70, c.Fade(c.SKYBLUE, 0.5));
            c.DrawRectangleLines( 10, 10, 220, 70, c.BLUE);

            c.DrawText("First person camera default controls:", 20, 20, 10, c.BLACK);
            c.DrawText("- Move with keys: W, A, S, D", 40, 40, 10, c.DARKGRAY);
            c.DrawText("- Mouse move to look around", 40, 60, 10, c.DARKGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
