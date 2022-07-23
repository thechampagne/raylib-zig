const c = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
});

const G = 400;
const PLAYER_JUMP_SPD = 350.0;
const PLAYER_HOR_SPD = 200.0;

const Player = struct {
    position: c.Vector2,
    speed: f32,
    canJump: bool,
};

const EnvItem = struct {
    rect: c.Rectangle,
    blocking: bool,
    color: c.Color,
};

const screenWidth = 800;
const screenHeight = 450;

fn UpdatePlayer(player: *Player, envItems: []EnvItem, envItemsLength: i32, delta: f32) void
{
    if (c.IsKeyDown(c.KEY_LEFT)) player.position.x -= PLAYER_HOR_SPD*delta;
    if (c.IsKeyDown(c.KEY_RIGHT)) player.position.x += PLAYER_HOR_SPD*delta;
    if (c.IsKeyDown(c.KEY_SPACE) and player.canJump)
    {
        player.speed = -PLAYER_JUMP_SPD;
        player.canJump = false;
    }

    var hitObstacle: usize = 0;
    var i: usize = 0;
    while (i < envItemsLength) : (i += 1)
    {
        var ei: EnvItem = envItems[i];
        var p: *c.Vector2 = &(player.position);
        if (ei.blocking and
            ei.rect.x <= p.*.x and
            ei.rect.x + ei.rect.width >= p.*.x and
            ei.rect.y >= p.*.y and
            ei.rect.y < p.*.y + player.speed*delta)
        {
            hitObstacle = 1;
            player.speed = 0.0;
            p.*.y = ei.rect.y;
        }
    }

    if (hitObstacle == 0)
    {
        player.position.y += player.speed*delta;
        player.speed += G*delta;
        player.canJump = false;
    }
    else player.canJump = true;
}

fn UpdateCameraCenter(camera: *c.Camera2D, player: *Player, _: []EnvItem, _: i32, _: f32, width: i32, height: i32) void
{
    camera.*.offset = .{ .x = @intToFloat(f32, width) /2.0, .y = @intToFloat(f32, height) /2.0 };
    camera.*.target = player.position;
}

fn UpdateCameraCenterInsideMap(camera: *c.Camera2D, player: *Player, envItems: []EnvItem, envItemsLength: i32, _: f32, width: i32, height: i32) void
{
    camera.*.target = player.position;
    camera.*.offset = .{ .x = @intToFloat(f32, width) /2.0, .y = @intToFloat(f32, height) /2.0 };
    var minX: f32 = 1000;
    var minY: f32 = 1000;
    var maxX: f32 = -1000;
    var maxY: f32 = -1000;

    var i: usize = 0;
    while (i < envItemsLength) : (i += 1)
    {
        var ei: EnvItem = envItems[i];
        minX = @minimum(ei.rect.x, minX);
        maxX = @minimum(ei.rect.x + ei.rect.width, maxX);
        minY = @minimum(ei.rect.y, minY);
        maxY = @minimum(ei.rect.y + ei.rect.height, maxY);
    }

    var max = c.GetWorldToScreen2D(.{ .x = maxX, .y = maxY }, camera.*);
    var min = c.GetWorldToScreen2D(.{ .x = minX, .y = minY }, camera.*);

    if (max.x < @intToFloat(f32, width)) camera.*.offset.x = @intToFloat(f32, width) - (max.x - @intToFloat(f32, @divFloor(width, 2)));
    if (max.y < @intToFloat(f32, height)) camera.*.offset.y = @intToFloat(f32, height) - (max.y - @intToFloat(f32, @divFloor(height, 2)));
    if (min.x > 0) camera.*.offset.x = @intToFloat(f32, width) /2 - min.x;
    if (min.y > 0) camera.*.offset.y = @intToFloat(f32, height) /2 - min.y;
}

fn UpdateCameraCenterSmoothFollow(camera: *c.Camera2D, player: *Player, _: []EnvItem, _: i32, delta: f32, width: i32, height: i32) void
{
    var minSpeed: f32 = 30;
    var minEffectLength: f32 = 10;
    var fractionSpeed: f32 = 0.8;

    camera.*.offset = .{ .x = @intToFloat(f32, width) /2.0, .y = @intToFloat(f32, height) /2.0 };
    var diff = c.Vector2Subtract(player.position, camera.*.target);
    var length = c.Vector2Length(diff);

    if (length > minEffectLength)
    {
        var speed = @maximum(fractionSpeed*length, minSpeed);
        camera.*.target = c.Vector2Add(camera.*.target, c.Vector2Scale(diff, speed*delta/length));
    }
}


fn UpdateCameraEvenOutOnLanding(camera: *c.Camera2D, player: *Player, _: []EnvItem, _: i32, delta: f32, width: i32, height: i32) void
{
    var evenOutSpeed: f32 = 700;
    var eveningOut = false;
    var evenOutTarget: f32 = undefined;

    camera.*.offset = .{ .x = @intToFloat(f32, width) /2.0, .y = @intToFloat(f32, height) /2.0 };
    camera.*.target.x = player.position.x;

    if (eveningOut)
    {
        if (evenOutTarget > camera.*.target.y)
        {
            camera.*.target.y += evenOutSpeed*delta;

            if (camera.*.target.y > evenOutTarget)
            {
                camera.*.target.y = evenOutTarget;
                eveningOut = false;
            }
        }
        else
        {
            camera.*.target.y -= evenOutSpeed*delta;

            if (camera.*.target.y < evenOutTarget)
            {
                camera.*.target.y = evenOutTarget;
                eveningOut = false;
            }
        }
    }
    else
    {
        if (player.canJump and (player.speed == 0) and (player.position.y != camera.*.target.y))
        {
            eveningOut = true;
            evenOutTarget = player.position.y;
        }
    }
}

fn UpdateCameraPlayerBoundsPush(camera: *c.Camera2D, player: *Player, _: []EnvItem, _: i32, _: f32, width: i32, height: i32) void
{
    var bbox = .{ .x = 0.2, .y = 0.2 };

    var bboxWorldMin = c.GetScreenToWorld2D(.{ .x = (1 - bbox.x)*0.5* @intToFloat(f32, width), .y = (1 - bbox.y)*0.5* @intToFloat(f32, height) }, camera.*);
    var bboxWorldMax = c.GetScreenToWorld2D(.{ .x = (1 + bbox.x)*0.5* @intToFloat(f32, width), .y = (1 + bbox.y)*0.5* @intToFloat(f32, height) }, camera.*);
    camera.*.offset = .{ .x = (1 - bbox.x)*0.5 * @intToFloat(f32, width), .y = (1 - bbox.y)*0.5* @intToFloat(f32, height) };

    if (player.position.x < bboxWorldMin.x) camera.*.target.x = player.position.x;
    if (player.position.y < bboxWorldMin.y) camera.*.target.y = player.position.y;
    if (player.position.x > bboxWorldMax.x) camera.*.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x);
    if (player.position.y > bboxWorldMax.y) camera.*.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y);
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera");

    var player: Player = undefined;
    player.position = .{ .x = 400, .y = 280 };
    player.speed = 0;
    player.canJump = false;
    var envItems =  [_]EnvItem{
        EnvItem{ .rect = c.Rectangle{ .x = 0, .y = 0, .width = 1000, .height = 400}, .blocking = false, .color = c.LIGHTGRAY },
        EnvItem{ .rect = c.Rectangle{ .x = 0, .y = 400, .width = 1000, .height = 200 }, .blocking = true, .color = c.GRAY },
        EnvItem{ .rect = c.Rectangle{ .x = 300, .y = 200, .width = 400, .height = 10 }, .blocking = true, .color = c.GRAY },
        EnvItem{ .rect = c.Rectangle{ .x = 250, .y = 300, .width = 100, .height = 10 }, .blocking = true, .color = c.GRAY },
        EnvItem{ .rect = c.Rectangle{ .x = 650, .y = 300, .width = 100, .height = 10 }, .blocking = true, .color = c.GRAY }
    };

    var envItemsLength: i32 = envItems.len;

    var camera: c.Camera2D = undefined;
    camera.target = player.position;
    camera.offset = .{ .x = screenWidth/2.0, .y = screenHeight/2.0 };
    camera.rotation = 0.0;
    camera.zoom = 1.0;

    var cameraUpdaters  = [_]fn(*c.Camera2D, *Player, []EnvItem, i32, f32, i32, i32) void{
        UpdateCameraCenter,
        UpdateCameraCenterInsideMap,
        UpdateCameraCenterSmoothFollow,
        UpdateCameraEvenOutOnLanding,
        UpdateCameraPlayerBoundsPush
    };

    var cameraOption: usize = 0;
    var cameraUpdatersLength: usize = cameraUpdaters.len;

    var cameraDescriptions = [_][]const u8{
        "Follow player center",
        "Follow player center, but clamp to map edges",
        "Follow player center; smoothed",
        "Follow player center horizontally; updateplayer center vertically after landing",
        "Player push camera on getting too close to screen edge"
    };

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        var deltaTime = c.GetFrameTime();

        UpdatePlayer(&player, &envItems, envItemsLength, deltaTime);

        camera.zoom += (c.GetMouseWheelMove()*0.05);

        if (camera.zoom > 3.0) { camera.zoom = 3.0; }
        else if (camera.zoom < 0.25) camera.zoom = 0.25;

        if (c.IsKeyPressed(c.KEY_R))
        {
            camera.zoom = 1.0;
            player.position = .{ .x = 400, .y = 280 };
        }

        if (c.IsKeyPressed(c.KEY_C)) cameraOption = @intCast(usize, (cameraOption + 1) % cameraUpdatersLength);

        // Call update camera function by its pointer
        cameraUpdaters[cameraOption](&camera, &player, &envItems, envItemsLength, deltaTime, screenWidth, screenHeight);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

           c.ClearBackground(c.LIGHTGRAY);

            c.BeginMode2D(camera);

                var i: usize = 0;
                while (i < envItemsLength) : (i += 1) c.DrawRectangleRec(envItems[i].rect, envItems[i].color);

                var playerRect = c.Rectangle{ .x = player.position.x - 20, .y = player.position.y - 40, .width = 40, .height = 40 };
                c.DrawRectangleRec(playerRect, c.RED);

            c.EndMode2D();

            c.DrawText("Controls:", 20, 20, 10, c.BLACK);
            c.DrawText("- Right/Left to move", 40, 40, 10, c.DARKGRAY);
            c.DrawText("- Space to jump", 40, 60, 10, c.DARKGRAY);
            c.DrawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, c.DARKGRAY);
            c.DrawText("- C to change camera mode", 40, 100, 10, c.DARKGRAY);
            c.DrawText("Current camera mode:", 20, 120, 10, c.BLACK);
            c.DrawText(cameraDescriptions[cameraOption].ptr, 40, 140, 10, c.DARKGRAY);
        
        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
