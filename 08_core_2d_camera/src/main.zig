const c = @cImport(@cInclude("raylib.h"));

const MAX_BUILDINGS = 100;

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera");

    var player = c.Rectangle{ .x = 400, .y = 280, .width = 40, .height = 40 };
    var buildings: [MAX_BUILDINGS]c.Rectangle = undefined;
    var buildColors: [MAX_BUILDINGS]c.Color = undefined;

    var spacing: i32 = 0;

    var i: usize = 0;
    while (i < MAX_BUILDINGS) : (i += 1)
    {
        buildings[i].width = @intToFloat(f32, c.GetRandomValue(50, 200));
        buildings[i].height = @intToFloat(f32, c.GetRandomValue(100, 800));
        buildings[i].y = screenHeight - 130.0 - buildings[i].height;
        buildings[i].x = -6000.0 + @intToFloat(f32, spacing);

        spacing += @floatToInt(i32, buildings[i].width);

        buildColors[i] = .{ .r = @intCast(u8, c.GetRandomValue(200, 240)), .g = @intCast(u8, c.GetRandomValue(200, 240)), .b = @intCast(u8, c.GetRandomValue(200, 250)), .a = 255 };
    }

    var camera: c.Camera2D = undefined;
    camera.target = .{ .x = player.x + 20.0, .y = player.y + 20.0 };
    camera.offset = .{ .x = screenWidth/2.0, .y = screenHeight/2.0 };
    camera.rotation = 0.0;
    camera.zoom = 1.0;

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        // Player movement
        if (c.IsKeyDown(c.KEY_RIGHT)) { player.x += 2; }
        else if (c.IsKeyDown(c.KEY_LEFT)) player.x -= 2;

        // Camera target follows player
        camera.target = .{ .x = player.x + 20, .y = player.y + 20 };

        // Camera rotation controls
        if (c.IsKeyDown(c.KEY_A)) { camera.rotation -= 1; }
        else if (c.IsKeyDown(c.KEY_S)) camera.rotation += 1;

        // Limit camera rotation to 80 degrees (-40 to 40)
        if (camera.rotation > 40) { camera.rotation = 40; }
        else if (camera.rotation < -40) camera.rotation = -40;

        // Camera zoom controls
        camera.zoom += (c.GetMouseWheelMove()*0.05);

        if (camera.zoom > 3.0) { camera.zoom = 3.0; }
        else if (camera.zoom < 0.1) camera.zoom = 0.1;

        // Camera reset (zoom and rotation)
        if (c.IsKeyPressed(c.KEY_R))
        {
            camera.zoom = 1.0;
            camera.rotation = 0.0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

        c.ClearBackground(c.RAYWHITE);

            c.BeginMode2D(camera);

                c.DrawRectangle(-6000, 320, 13000, 8000, c.DARKGRAY);

                var index: usize = 0;
                while (i < MAX_BUILDINGS) : (i += 1) c.DrawRectangleRec(buildings[index], buildColors[index]);

                c.DrawRectangleRec(player, c.RED);

                c.DrawLine(@floatToInt(i32, camera.target.x), -screenHeight*10, @floatToInt(i32, camera.target.x), screenHeight*10, c.GREEN);
                c.DrawLine(-screenWidth*10, @floatToInt(i32, camera.target.y), screenWidth*10, @floatToInt(i32, camera.target.y), c.GREEN);

            c.EndMode2D();

            c.DrawText("SCREEN AREA", 640, 10, 20, c.RED);

            c.DrawRectangle(0, 0, screenWidth, 5, c.RED);
            c.DrawRectangle(0, 5, 5, screenHeight - 10, c.RED);
            c.DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, c.RED);
            c.DrawRectangle(0, screenHeight - 5, screenWidth, 5, c.RED);

            c.DrawRectangle( 10, 10, 250, 113, c.Fade(c.SKYBLUE, 0.5));
            c.DrawRectangleLines( 10, 10, 250, 113, c.BLUE);

            c.DrawText("Free 2d camera controls:", 20, 20, 10, c.BLACK);
            c.DrawText("- Right/Left to move Offset", 40, 40, 10, c.DARKGRAY);
            c.DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, c.DARKGRAY);
            c.DrawText("- A / S to Rotate", 40, 80, 10, c.DARKGRAY);
            c.DrawText("- R to reset Zoom and Rotation", 40, 100, 10, c.DARKGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
