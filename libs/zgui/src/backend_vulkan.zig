pub const VkPipelineRenderingCreateInfoKHR = extern struct {
    s_type: i32 = 1000044002,
    p_next: ?*const anyopaque = null,
    view_mask: u32,
    color_attachment_count: u32 = 0,
    p_color_attachment_formats: ?[*]const i32 = null,
    depth_attachment_format: i32,
    stencil_attachment_format: i32,
};

pub const ImGui_ImplVulkan_InitInfo = extern struct {
    instance: *const anyopaque, // VkInstance
    physical_device: *const anyopaque, // VkPhysicalDevice
    device: *const anyopaque, // VkDevice
    queue_family: u32,
    queue: *const anyopaque, // VkQueue
    descriptor_pool: *const anyopaque, // VkDescriptorPool; See requirements in note above
    render_pass: ?*const anyopaque = null, // VkRenderPass; Ignored if using dynamic rendering
    min_image_count: u32, // >= 2
    image_count: u32, // >= MinImageCount
    msaasamples: i32, // VkSampleCountFlagBits; 0 defaults to VK_SAMPLE_COUNT_1_BIT

    // (Optional)
    pipeline_cache: ?*const anyopaque = null, // VkPipelineCache
    subpass: u32 = 0,

    // (Optional) Dynamic Rendering
    // Need to explicitly enable VK_KHR_dynamic_rendering extension to use this, even for Vulkan 1.3.
    use_dynamic_rendering: bool = true,
    pipeline_rendering_create_info: VkPipelineRenderingCreateInfoKHR, // VkPipelineRenderingCreateInfoKHR

    // (Optional) Allocation, Debugging
    allocator: ?*const anyopaque = null, // const VkAllocationCallbacks*
    check_vk_result_fn: ?*const anyopaque = null, // void (*CheckVkResultFn)(VkResult err);
    min_allocation_size: u64 = 1024*1024, // VkDeviceSize; Minimum allocation size. Set to 1024*1024 to satisfy zealous best practices validation layer and waste a little memory.
};

pub fn init(
    // PFN_vkVoidFunction(*loader_func)(const char* function_name, void* user_data)
    context: *const anyopaque,
    loader: fn(fn_name: *const u8, context: *const anyopaque) ?*const fn () callconv(.C) void,
    info: *const ImGui_ImplVulkan_InitInfo,
) void {
    if (!ImGui_ImplVulkan_LoadFunctions(loader, context)) {
        @panic("failed to load vulkan functions for imgui");
    }

    if (!ImGui_ImplVulkan_Init(info)) {
        @panic("failed to init vulkan for imgui");
    }
}

pub fn deinit() void {
    ImGui_ImplVulkan_Shutdown();
}

pub fn newFrame() void {
    ImGui_ImplVulkan_NewFrame();
}

pub fn render(
    draw_data: *const anyopaque, // *ImDrawData
    command_buffer: *const anyopaque, // VkCommandBuffer
    pipeline: ?*const anyopaque, // VkPipeline
) void {
    ImGui_ImplVulkan_RenderDrawData(draw_data, command_buffer, pipeline);
}

// Those functions are defined in 'imgui_impl_vulkan.cpp`
extern fn ImGui_ImplVulkan_Init(info: *const ImGui_ImplVulkan_InitInfo) bool;
extern fn ImGui_ImplVulkan_Shutdown() void;
extern fn ImGui_ImplVulkan_NewFrame() void;
extern fn ImGui_ImplVulkan_RenderDrawData(
    draw_data: *const anyopaque, // *ImDrawData
    command_buffer: *const anyopaque, // VkCommandBuffer
    pipeline: ?*const anyopaque, // VkPipeline
) void;


extern fn ImGui_ImplVulkan_LoadFunctions(
    loader: *const anyopaque, // PFN_vkVoidFunction(*loader_func)(const char* function_name, void* user_data)
    user_data: *const anyopaque, // void*
) bool;