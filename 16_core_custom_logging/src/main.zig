const c = @cImport({
    @cInclude("raylib.h");
    @cInclude("time.h");
    @cInclude("stdio.h");
});

const screenWidth = 800;
const screenHeight = 450;

fn CustomLog(msgType: c_int, text: [*c]const u8, args: [*c]c.struct___va_list_tag) callconv(.C) void {
    var timeStr: [64]u8 = undefined;
    var now = c.time(null);
    var tm_info = c.localtime(&now);

    _ = c.strftime(&timeStr, @sizeOf(@TypeOf(timeStr)), "%Y-%m-%d %H:%M:%S", tm_info);
    _ = c.printf("[%s] ", timeStr);

    switch (msgType) {
        c.LOG_INFO => _ = c.printf("[INFO] : "),
        c.LOG_ERROR => _ = c.printf("[ERROR]: "),
        c.LOG_WARNING => _ = c.printf("[WARN] : "),
        c.LOG_DEBUG => _ = c.printf("[DEBUG]: "),
        else => {}
    }

    _ = c.vprintf(text, args);
    _ = c.printf("\n");
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {

    // Initialization
    //--------------------------------------------------------------------------------------

    // Set custom logger
    c.SetTraceLogCallback(CustomLog);

    c.InitWindow(screenWidth, screenHeight, "raylib [core] example - custom logging");

    c.SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
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

        c.DrawText("Check out the console output to see the custom logger in action!", 60, 200, 20, c.LIGHTGRAY);

        c.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //-------------------------------------------------------------------------------------
    c.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
