const gui = @import("gui.zig");
const backend_glfw = @import("backend_glfw.zig");
const backend_vk = @import("backend_vulkan.zig");

pub const VkPipelineRenderingCreateInfoKHR = backend_vk.VkPipelineRenderingCreateInfoKHR;
pub const ImGui_ImplVulkan_InitInfo = backend_vk.ImGui_ImplVulkan_InitInfo;

pub fn init(
    window: *const anyopaque, // zglfw.Window
    context: *const anyopaque,
    loader: fn(fn_name: *const u8, context: *const anyopaque) ?*const fn () callconv(.C) void,
    vk_init: *const backend_vk.ImGui_ImplVulkan_InitInfo,
) void {
    backend_glfw.init(window);
    backend_vk.init(context, loader, vk_init);
}

pub fn deinit() void {
    backend_vk.deinit();
    backend_glfw.deinit();
}

pub fn newFrame(fb_width: u32, fb_height: u32) void {
    backend_glfw.newFrame();
    backend_vk.newFrame();

    gui.io.setDisplaySize(@as(f32, @floatFromInt(fb_width)), @as(f32, @floatFromInt(fb_height)));
    gui.io.setDisplayFramebufferScale(1.0, 1.0);

    gui.newFrame();
}

pub fn draw(
    command_buffer: *const anyopaque, // VkCommandBuffer
    pipeline: ?*const anyopaque, // VkPipeline
) void {
    gui.render();
    backend_vk.render(gui.getDrawData(), command_buffer, pipeline);
}
