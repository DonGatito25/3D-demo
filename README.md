# 3D-test

Open the project in Godot 4.5 and press **F5** or manually run. The cube, sphere, cylinder, capsule, and donut are editable in `main.tscn`. The cube uses the imported `assets/checker.svg` texture.

- **L** toggles the directional light and its shadows. Ambient light stays on.
- **I** switches the same 400 blocks between individual mesh nodes and a GPU-instanced `MultiMesh`. Instancing is on at startup.

## Profiling

Run from the editor, leave the light on, and select **Raster → Total Draw Calls** under **Debugger → Monitors**. Press **I** in the game window to compare the modes. The on-screen counter reads the same engine monitor. [Godot Performance reference](https://docs.godotengine.org/en/4.5/classes/class_performance.html)

| Mode | Draw calls per frame | Viewport CPU time | Viewport GPU time |
| --- | ---: | ---: | ---: |
| Individual meshes | 407 | 0.400 ms | 0.887 ms |
| GPU instancing | 8 | 0.083 ms | 0.813 ms |

These are medians over 60 rendered frames per mode at 960 × 540 on an Apple M2 in Godot 4.5.1 (Mobile renderer, Vulkan). Both modes rendered 9,550 visible 3D primitives. The project uses Mobile to expose the cost of individual draw calls. Forward+ automatically batches identical opaque meshes. [Godot 3D optimization guide](https://docs.godotengine.org/en/4.5/tutorials/performance/optimizing_3d_performance.html)
