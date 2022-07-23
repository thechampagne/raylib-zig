const c = @cImport(@cInclude("raylib.h"));

const MAX_GESTURE_STRINGS = 20;

const screenWidth = 800;
const screenHeight = 450;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------
    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - input gestures");

    var touchPosition = c.Vector2{ .x = 0, .y = 0 };
    var touchArea = c.Rectangle{ .x = 220, .y = 10, .width = screenWidth - 230.0, .height = screenHeight - 20.0 };

    var gesturesCount: usize = 0;
    var gestureStrings: [MAX_GESTURE_STRINGS][32]u8 = undefined;

    var currentGesture: i32 = c.GESTURE_NONE;
    var lastGesture: i32 = c.GESTURE_NONE;

    //SetGesturesEnabled(0b0000000000001001);   // Enable only some gestures to be detected

    c.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!c.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        lastGesture = currentGesture;
        currentGesture = c.GetGestureDetected();
        touchPosition = c.GetTouchPosition(0);

        if (c.CheckCollisionPointRec(touchPosition, touchArea) and (currentGesture != c.GESTURE_NONE))
        {
            if (currentGesture != lastGesture)
            {
                // Store gesture string
                switch (currentGesture)
                {
                    c.GESTURE_TAP => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE TAP"); break; },
                    c.GESTURE_DOUBLETAP => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE DOUBLETAP"); break; },
                    c.GESTURE_HOLD => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE HOLD"); break; },
                    c.GESTURE_DRAG => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE DRAG"); break; },
                    c.GESTURE_SWIPE_RIGHT => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE SWIPE RIGHT"); break; },
                    c.GESTURE_SWIPE_LEFT => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE SWIPE LEFT"); break; },
                    c.GESTURE_SWIPE_UP => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE SWIPE UP"); break; },
                    c.GESTURE_SWIPE_DOWN => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE SWIPE DOWN"); break; },
                    c.GESTURE_PINCH_IN => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE PINCH IN"); break; },
                    c.GESTURE_PINCH_OUT => { _ = c.TextCopy(&gestureStrings[gesturesCount], "GESTURE PINCH OUT"); break; },
                    else => break
                }

                gesturesCount += 1;

                // Reset gestures strings
                if (gesturesCount >= MAX_GESTURE_STRINGS)
                {   
                    var i: i32 = 0;
                    while (i < MAX_GESTURE_STRINGS) : ( i += 1) _ = c.TextCopy(&gestureStrings[i], "\\0");

                    gesturesCount = 0;
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        c.BeginDrawing();

            c.ClearBackground(c.RAYWHITE);

            c.DrawRectangleRec(touchArea, c.GRAY);
            c.DrawRectangle(225, 15, screenWidth - 240, screenHeight - 30, c.RAYWHITE);

            c.DrawText("GESTURES TEST AREA", screenWidth - 270, screenHeight - 40, 20, c.Fade(c.GRAY, 0.5));

            var i: usize = 0;
            while (i < gesturesCount) : ( i += 1)
            {
                if (i % @as(i32, 2) == 0) { c.DrawRectangle(10, @intCast(i32, 30 + 20*i), 200, 20, c.Fade(c.LIGHTGRAY, 0.5)); }
                else { c.DrawRectangle(10, @intCast(i32, 30 + 20*i), 200, 20, c.Fade(c.LIGHTGRAY, 0.3)); }

                if (i < gesturesCount - 1) { c.DrawText(&gestureStrings[i], 35, @intCast(i32, 36 + 20*i), 10, c.DARKGRAY); }
                else { c.DrawText(&gestureStrings[i], 35, @intCast(i32, 36 + 20*i), 10, c.MAROON); }
            }

            c.DrawRectangleLines(10, 29, 200, screenHeight - 50, c.GRAY);
            c.DrawText("DETECTED GESTURES", 50, 15, 10, c.GRAY);

            if (currentGesture != c.GESTURE_NONE) c.DrawCircleV(touchPosition, 30, c.MAROON);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
