# 08 — How games attain realistic built environments (efficiently)

## Realism is evidence + geometry + material response + light + composition
1. **Source photography**: multi-angle current images with clear identities; a single AI-generated approximate image of 'college tower' is NOT a source of truth. Build the actual architecture from observed features.
2. **Measured-like blockout**: exact XZ context, meaningful hill elevation, known floors, layered volume silhouette.
3. **Architectural modeling**: facade subdivisions; recesses, reveal depth, mullions, canopies, parapets, steps/ramps and trims. These produce parallax and contact shadows from first-person viewpoint.
4. **Material authoring**: plausible color and surface roughness, physically scaled texture repetition, realistic glass. A clean procedural concrete/paint atlas can outperform randomly colored cube geometry.
5. **Lighting**: physically coherent sun direction, sky ambient, balanced exposure, coherent shadow direction, subtle fog only when scene scale calls for it. Avoid baked black windows and neon saturation.
6. **Scene dressing**: realistic curbs, light poles, drains, benches, railings, planters/trees, seams; only add when shown/supported and do not consume whole 5h window.
7. **Side-by-side review**: match focal length/camera position to a reference photo; fix biggest composition/silhouette errors first.

## Possible higher-end methods (not the first sprint)
- **Photogrammetry/SfM** from many properly permitted, overlapping photos can reconstruct a mesh, but it is slow, often noisy, struggles with reflective glass, and usually needs retopology/LOD and legal rights. DO NOT promise that 3 random snapshots yield a photorealistic tower. Avoid cloud paid reconstruction dependencies in this session.
- **Blender** for manually modeled modular facade assets (optional if already installed). Export `.glb` to Godot; maintain source `.blend` only if necessary and rights clear. Procedural GDScript is adequate for this first focused pilot.
- **Image generation** can create *original non-identifying tileable surfaces* (only if explicitly requested), but cannot validate geometry, door locations or authenticity. This package asks for no image generation.
- **Photorealistic GIS photogrammetry** is outside scope and GPU/time budget; license/time and integration complexity is much higher than facade modules.

## GTX 1650 / WSLg / Compatibility constraints
- Engine stays Godot 4.7.2 Standard, OpenGL Compatibility (`gl_compatibility`), no Vulkan-only effects/decal nodes.
- Reuse 512–1024px material textures; 2K sparingly on large visible unique assets, confirm total GPU use rather than guess from model name. Prefer atlases/sharing and LOD/visibility ranges. Keep draw calls/transparent glass/lights sensible.
- `StandardMaterial3D` metallic/roughness with restrained specular; transparent windows can cost overdraw. Avoid many dynamic shadowed spot lights, heavy GI or full-resolution camera-traced PBR.
- Use conservative MSAA/AA and adjustable performance settings where valid for Compatibility. Measure actual gameplay FPS with WSLg and `glxinfo -B`; a successful import or CPU glxinfo alone does not guarantee smoothness.
